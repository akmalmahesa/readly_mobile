import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../data/books_data.dart';
import '../widgets/explore_book_tile.dart';
import 'book_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Book> get _searchResults {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return allBooks
        .where(
          (b) =>
              b.title.toLowerCase().contains(q) ||
              b.author.toLowerCase().contains(q),
        )
        .toList();
  }

  // ── Sections config ────────────────────────────────────────────────────────

  static const _sections = [
    _SectionConfig(
      title: 'Recently reviewed',
      subtitle: 'Books our members are talking about',
      layout: _Layout.featured,
      bookIndices: [0, 2],
    ),
    _SectionConfig(
      title: 'New releases',
      subtitle: 'The new books our community is most excited about',
      layout: _Layout.grid2,
      bookIndices: [8, 9],
    ),
    _SectionConfig(
      title: 'Bestsellers',
      subtitle: 'Popular reads that keep showing up on every shelf',
      layout: _Layout.grid3,
      bookIndices: [12, 13, 14],
    ),
    _SectionConfig(
      title: 'Eastern treasures',
      subtitle: 'Discover timeless stories from the East',
      layout: _Layout.grid3,
      bookIndices: [0, 3, 6],
    ),
    _SectionConfig(
      title: 'Western lit',
      subtitle: 'Timeless masterpieces from the West',
      layout: _Layout.grid3,
      bookIndices: [1, 4, 5],
    ),
    _SectionConfig(
      title: 'Local books',
      subtitle: 'Stories from our own backyard',
      layout: _Layout.grid3,
      bookIndices: [7, 10, 11],
    ),
  ];

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: libraryVersion,
      builder: (context, _, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                if (_query.isNotEmpty)
                  SliverToBoxAdapter(child: _buildSearchResults())
                else
                  ..._sections.map(
                    (s) =>
                        SliverToBoxAdapter(child: _SectionWidget(config: s)),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Header + Search bar ────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Search', style: AppTextStyles.displayTitle),
          const SizedBox(height: 4),
          Container(height: 2, width: 50, color: AppColors.textPrimary),
          const SizedBox(height: 12),
          const Text(
            'Books',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              decoration: TextDecoration.underline,
              decorationThickness: 2,
              fontFamily: 'sans-serif',
            ),
          ),
          const SizedBox(height: 12),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (v) => setState(() => _query = v),
        decoration: const InputDecoration(
          hintText: 'Search 9M+ books',
          hintStyle: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontFamily: 'sans-serif',
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // ── Search results list ────────────────────────────────────────────────────

  Widget _buildSearchResults() {
    final results = _searchResults;
    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No books found.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'sans-serif',
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.borderColor, height: 1),
      itemBuilder: (context, i) => _SearchResultTile(book: results[i]),
    );
  }
}

// ── Search result tile ─────────────────────────────────────────────────────

class _SearchResultTile extends StatelessWidget {
  final Book book;
  const _SearchResultTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          book.coverUrl,
          width: 46,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(width: 46, height: 60, color: AppColors.tagBg),
        ),
      ),
      title: Text(
        book.title,
        style: const TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(book.author, style: AppTextStyles.caption),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: AppColors.starColor, size: 14),
          const SizedBox(width: 3),
          Text(book.rating.toString(), style: AppTextStyles.caption),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
      ),
    );
  }
}

// ── Section widget ─────────────────────────────────────────────────────────

enum _Layout { featured, grid2, grid3 }

class _SectionConfig {
  final String title;
  final String subtitle;
  final _Layout layout;
  final List<int> bookIndices;

  const _SectionConfig({
    required this.title,
    required this.subtitle,
    required this.layout,
    required this.bookIndices,
  });
}

class _SectionWidget extends StatelessWidget {
  final _SectionConfig config;
  const _SectionWidget({super.key, required this.config});

  List<Book> get _books {
    if (allBooks.isEmpty) return [];
    return config.bookIndices.map((i) => allBooks[i % allBooks.length]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(config.title, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 3),
                Text(config.subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final books = _books;
    final needed = config.layout == _Layout.grid3 ? 3 : 2;
    if (books.length < needed) return const SizedBox.shrink();
    switch (config.layout) {
      case _Layout.featured:
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: ExploreBookTile(book: books[0], height: 160),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: ExploreBookTile(book: books[1], height: 160),
            ),
          ],
        );
      case _Layout.grid2:
        return Row(
          children: [
            Expanded(
              child: ExploreBookTile(
                book: books[0],
                showBookmark: true,
                height: 130,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ExploreBookTile(
                book: books[1],
                showBookmark: true,
                height: 130,
              ),
            ),
          ],
        );
      case _Layout.grid3:
        return Row(
          children: [
            Expanded(
              child: ExploreBookTile(
                book: books[0],
                showBookmark: true,
                height: 130,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ExploreBookTile(
                book: books[1],
                showBookmark: true,
                height: 130,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ExploreBookTile(
                book: books[2],
                showBookmark: true,
                height: 130,
              ),
            ),
          ],
        );
    }
  }
}
