import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models.dart';
import 'books_data.dart';
import 'xp_data.dart';

/// Bridges Firestore (`books` catalog + per-user `library` overlay + user
/// profile) into the existing [allBooks] / [libraryVersion] / [XpData]
/// reactive state used throughout the UI.
class AppData {
  AppData._();
  static final AppData instance = AppData._();

  final _firestore = FirebaseFirestore.instance;

  String? _uid;
  StreamSubscription? _booksSub;
  StreamSubscription? _librarySub;
  StreamSubscription? _userSub;

  Map<String, Book> _catalog = {};
  Map<String, Map<String, dynamic>> _library = {};

  /// Starts listening to Firestore for the signed-in user [uid].
  void startListening(String uid) {
    if (_uid == uid) return;
    stopListening();
    _uid = uid;

    _booksSub = _firestore.collection('books').snapshots().listen((snapshot) {
      _catalog = {
        for (final doc in snapshot.docs) doc.id: Book.fromMap(doc.id, doc.data()),
      };
      _rebuildAllBooks();
    });

    _librarySub = _firestore
        .collection('users')
        .doc(uid)
        .collection('library')
        .snapshots()
        .listen((snapshot) {
      _library = {for (final doc in snapshot.docs) doc.id: doc.data()};
      _rebuildAllBooks();
    });

    _userSub = _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      final xp = doc.data()?['totalXp'] as int? ?? 0;
      XpData.totalXp.value = xp;
    });
  }

  /// Cancels all Firestore subscriptions and clears local state. Called on
  /// sign-out.
  void stopListening() {
    _booksSub?.cancel();
    _librarySub?.cancel();
    _userSub?.cancel();
    _booksSub = null;
    _librarySub = null;
    _userSub = null;
    _uid = null;

    _catalog = {};
    _library = {};
    allBooks.clear();
    XpData.totalXp.value = 0;
    libraryVersion.value++;
  }

  void _rebuildAllBooks() {
    allBooks.clear();
    for (final entry in _catalog.entries) {
      final book = entry.value;
      final overlay = _library[entry.key];
      book.isSaved = overlay?['isSaved'] as bool? ?? false;
      book.isCompleted = overlay?['isCompleted'] as bool? ?? false;
      book.currentPage = overlay?['currentPage'] as int?;
      allBooks.add(book);
    }
    libraryVersion.value++;
  }

  /// Adds or removes [bookId] from the user's saved/wishlist set.
  Future<void> toggleSaved(String bookId, bool value) async {
    final uid = _uid;
    if (uid == null) return;

    final book = _catalog[bookId];
    if (book != null) {
      book.isSaved = value;
      libraryVersion.value++;
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('library')
        .doc(bookId)
        .set({
      'isSaved': value,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Updates reading progress for [bookId] and awards XP, mirroring the
  /// original local-only logic in reading_tracker.dart.
  Future<void> updateProgress(String bookId, int currentPage, int totalPages) async {
    final uid = _uid;
    if (uid == null) return;

    final wasCompleted = _library[bookId]?['isCompleted'] as bool? ??
        _catalog[bookId]?.isCompleted ??
        false;
    final isCompleted = currentPage >= totalPages;
    final earnedXp = isCompleted && !wasCompleted ? totalPages : 10;
    final hasStarted = _library[bookId]?['currentPage'] != null;

    final book = _catalog[bookId];
    if (book != null) {
      book.currentPage = currentPage;
      book.isCompleted = isCompleted;
      libraryVersion.value++;
    }
    XpData.addXp(earnedXp);

    final libraryDoc = _firestore
        .collection('users')
        .doc(uid)
        .collection('library')
        .doc(bookId);

    await libraryDoc.set({
      'currentPage': currentPage,
      'isCompleted': isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
      if (!hasStarted) 'startedAt': FieldValue.serverTimestamp(),
      if (isCompleted && !wasCompleted) 'completedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore.collection('users').doc(uid).set({
      'totalXp': FieldValue.increment(earnedXp),
    }, SetOptions(merge: true));
  }
}
