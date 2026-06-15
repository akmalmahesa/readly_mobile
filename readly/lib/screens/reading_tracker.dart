import 'package:flutter/material.dart';
import '../widgets/xp_card.dart';
import '../widgets/reading_item.dart';
import '../widgets/update_panel.dart';
import '../widgets/completed_item.dart';
import '../data/app_data.dart';
import '../data/books_data.dart';
import '../core/models.dart';
import '../core/theme.dart';

class ReadingTrackerPage extends StatefulWidget {
  const ReadingTrackerPage({super.key});

  @override
  State<ReadingTrackerPage> createState() => _ReadingTrackerPageState();
}

class _ReadingTrackerPageState extends State<ReadingTrackerPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  String? selectedBookId;
  double sliderValue = 0;
  bool justUpdated = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Book> get readingList =>
      allBooks.where((b) => !b.isCompleted && b.currentPage != null).toList();

  List<Book> get readBooks => allBooks.where((b) => b.isCompleted).toList();

  Book? get selectedEntry {
    try {
      return readingList.firstWhere((b) => b.id == selectedBookId);
    } catch (e) {
      return null;
    }
  }

  GlobalKey _keyForBook(String bookId) {
    final existingKey = _itemKeys[bookId];
    if (existingKey != null) return existingKey;

    final createdKey = GlobalKey();
    _itemKeys[bookId] = createdKey;
    return createdKey;
  }

  void openBook(String bookId, double currentPage) {
    setState(() {
      selectedBookId = bookId;
      sliderValue = currentPage;
      justUpdated = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[bookId];
      final context = key?.currentContext;
      if (context == null) return;

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: 0.12,
      );
    });
  }

  void handleUpdate() {
    if (selectedBookId == null) return;

    final book = allBooks.firstWhere((b) => b.id == selectedBookId);
    AppData.instance.updateProgress(book.id, sliderValue.toInt(), book.pages);

    setState(() => justUpdated = true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: libraryVersion,
      builder: (context, _, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final book = selectedEntry;
    final selectedIndex = selectedBookId == null
        ? -1
        : readingList.indexWhere((entry) => entry.id == selectedBookId);

    return Scaffold(
      backgroundColor: AppColors.background, // ✅ pakai theme
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reading Tracker",
                    style: AppTextStyles.displayTitle, // ✅ theme
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Track your progress, earn XP with every update",
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),

            /// XP CARD
            const XpCard(),

            /// CURRENTLY READING
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Currently Reading",
                style: AppTextStyles.sectionTitle, // ✅ theme
              ),
            ),

            const SizedBox(height: 10),

            /// LIST READING
            if (readingList.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("No books in progress", style: AppTextStyles.body),
              )
            else
              Column(
                children: [
                  for (var i = 0; i < readingList.length; i++)
                    KeyedSubtree(
                      key: _keyForBook(readingList[i].id),
                      child: Column(
                        children: [
                          ReadingItem(
                            cr: {
                              'bookId': readingList[i].id,
                              'currentPage': readingList[i].currentPage ?? 0,
                              'totalPages': readingList[i].pages,
                            },
                            book: {
                              'title': readingList[i].title,
                              'author': readingList[i].author,
                              'cover': readingList[i].coverUrl,
                            },
                            selectedBookId: selectedBookId,
                            onTap: () => openBook(
                              readingList[i].id,
                              (readingList[i].currentPage ?? 0).toDouble(),
                            ),
                          ),
                          if (i == selectedIndex && book != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: UpdatePanel(
                                selectedEntry: {
                                  'cr': {'totalPages': book.pages},
                                  'book': {
                                    'title': book.title,
                                    'cover': book.coverUrl,
                                  },
                                },
                                sliderValue: sliderValue,
                                setSliderValue: (v) {
                                  setState(() => sliderValue = v);
                                },
                                handleUpdate: handleUpdate,
                                justUpdated: justUpdated,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),

            /// COMPLETED SECTION
            if (readBooks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Completed (${readBooks.length})",
                      style: AppTextStyles.sectionTitle, // ✅ theme
                    ),
                    const SizedBox(height: 10),

                    ...readBooks.map((book) {
                      return CompletedItem(
                        book: {
                          'title': book.title,
                          'author': book.author,
                          'cover': book.coverUrl,
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
