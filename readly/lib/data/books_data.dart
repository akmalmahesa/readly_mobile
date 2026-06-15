import '../core/models.dart';
import 'package:flutter/foundation.dart';

/// Populated at runtime by [AppData] from Firestore (catalog + per-user
/// library overlay). Empty until the user is signed in and the first
/// snapshot arrives.
final List<Book> allBooks = [];

List<Book> get continueReadingBooks =>
    allBooks.where((b) => b.isReading).toList();
List<Book> get completedBooks => allBooks.where((b) => b.isCompleted).toList();
List<Book> get savedBooks => allBooks.where((b) => b.isSaved).toList();
List<Book> get trendingBooks => allBooks.where((b) => !b.isCompleted).toList();
List<Book> get homeSpotlightBooks => allBooks
    .where(
      (book) => {
        'The Great Gatsby',
        '1984',
        'Pride and Prejudice',
        'Dune',
        'The Hobbit',
        'Atomic Habits',
        'The Secret History',
      }.contains(book.title),
    )
    .toList();

// Notifier to signal library changes (data load / completed status / progress updates).
final ValueNotifier<int> libraryVersion = ValueNotifier<int>(0);
