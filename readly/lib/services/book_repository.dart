import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/seed_books.dart';

/// One-time seeding of the Firestore `books` catalog collection.
class BookRepository {
  static final _books = FirebaseFirestore.instance.collection('books');

  /// Seeds the `books` collection from [seedBooks] if it's currently empty.
  /// Cheap no-op (single read) after the first successful run.
  static Future<void> seedIfEmpty() async {
    final snapshot = await _books.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    for (final book in seedBooks) {
      batch.set(_books.doc(book.id), {
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'coverUrl': book.coverUrl,
        'rating': book.rating,
        'pages': book.pages,
        'year': book.year,
        'origin': book.origin,
        'genres': book.genres,
        'tags': book.tags,
      });
    }
    await batch.commit();
  }
}
