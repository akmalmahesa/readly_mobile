import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/theme.dart';
import '../data/app_data.dart';
import '../data/books_data.dart';
import 'reading_tracker.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Book get _sharedBook =>
      allBooks.firstWhere((book) => book.id == widget.book.id);

  void _toggleSaved(Book book) {
    AppData.instance.toggleSaved(book.id, !book.isSaved);
  }

  void _startOrUpdateReading(BuildContext context, Book book) {
    if (book.isReading) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReadingTrackerPage()),
      );
    } else {
      AppData.instance.updateProgress(book.id, 0, book.pages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: libraryVersion,
      builder: (context, _, _) {
        final book = _sharedBook;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              _buildHeroAppBar(context, book),
              SliverToBoxAdapter(child: _buildMetaCard(book)),
              SliverToBoxAdapter(child: _buildAbout(book)),
              SliverToBoxAdapter(child: _buildTags(book)),
              if (book.isReading)
                SliverToBoxAdapter(child: _buildProgressCard(book)),
              SliverToBoxAdapter(child: _buildActionButtons(context, book)),
              SliverToBoxAdapter(child: _buildSimilarBooks(context, book)),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }

  // ── Hero AppBar ────────────────────────────────────────────────────────────

  SliverAppBar _buildHeroAppBar(BuildContext context, Book book) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              book.coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.72)],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              right: 20,
              child: _buildHeroInfo(book),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroInfo(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: book.genres.map((g) {
            final isEastern = g == 'Eastern';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isEastern
                    ? AppColors.accent
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEastern)
                    const Text('🌏 ', style: TextStyle(fontSize: 11)),
                  Text(
                    g,
                    style: TextStyle(
                      color: isEastern ? AppColors.textPrimary : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          book.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        Text(
          book.author,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 14,
            fontFamily: 'sans-serif',
          ),
        ),
      ],
    );
  }

  // ── Meta card ──────────────────────────────────────────────────────────────

  Widget _buildMetaCard(Book book) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _MetaItem(
            icon: Icons.star,
            iconColor: AppColors.starColor,
            value: book.rating.toString(),
            label: 'Rating',
          ),
          _divider(),
          _MetaItem(
            icon: Icons.menu_book_outlined,
            value: '${book.pages}',
            label: 'Pages',
          ),
          _divider(),
          _MetaItem(
            icon: Icons.calendar_today_outlined,
            value: book.year.toString(),
            label: 'Published',
          ),
          _divider(),
          _MetaItem(icon: Icons.language, value: book.origin, label: 'Origin'),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 36, color: AppColors.borderColor);

  // ── About ──────────────────────────────────────────────────────────────────

  Widget _buildAbout(Book book) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this book',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 12),
          Text(book.description, style: AppTextStyles.body),
        ],
      ),
    );
  }

  // ── Tags ───────────────────────────────────────────────────────────────────

  Widget _buildTags(Book book) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: book.tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.tagBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Text(tag, style: AppTextStyles.caption),
          );
        }).toList(),
      ),
    );
  }

  // ── Progress card (only when currently reading) ────────────────────────────

  Widget _buildProgressCard(Book book) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.currentReadingBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC8E6D4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book, color: AppColors.primary, size: 16),
              SizedBox(width: 6),
              Text(
                'Currently reading',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontSize: 14,
                  fontFamily: 'sans-serif',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: book.progress,
              backgroundColor: Colors.white.withOpacity(0.6),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${book.currentPage} / ${book.pages} pages (${book.progressPercent}%)',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 8),
          const Text(
            'Update progress →',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              fontFamily: 'sans-serif',
            ),
          ),
        ],
      ),
    );
  }

  // ── Action buttons ─────────────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context, Book book) {
    final isSaved = book.isSaved;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _startOrUpdateReading(context, book),
              icon: const Icon(Icons.menu_book_outlined, size: 18),
              label: Text(book.isReading ? 'Update Progress' : 'Start Reading'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'sans-serif',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _toggleSaved(book),
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_outline,
                size: 18,
              ),
              label: Text(isSaved ? 'Saved' : 'Add to Library'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isSaved
                    ? AppColors.textPrimary
                    : AppColors.primary,
                backgroundColor: isSaved
                    ? AppColors.accent
                    : Colors.transparent,
                side: BorderSide(
                  color: isSaved ? AppColors.accent : AppColors.primary,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'sans-serif',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Similar books ──────────────────────────────────────────────────────────

  Widget _buildSimilarBooks(BuildContext context, Book book) {
    final similar = allBooks.where((b) => b.id != book.id).take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 14),
          child: Text(
            'You might also like',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Georgia',
            ),
          ),
        ),
        SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: similar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final b = similar[i];
              return GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => BookDetailScreen(book: b)),
                ),
                child: SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          b.coverUrl,
                          height: 135,
                          width: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 135,
                            width: 110,
                            color: AppColors.tagBg,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        b.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bookTitle,
                      ),
                      Text(
                        b.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Reusable meta item ─────────────────────────────────────────────────────

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _MetaItem({
    required this.icon,
    this.iconColor = AppColors.textSecondary,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'sans-serif',
            ),
          ),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
