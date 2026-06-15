import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/books_data.dart';
import '../data/xp_data.dart';
import '../services/auth_service.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/trending_card.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([libraryVersion, XpData.totalXp]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar()),
                SliverToBoxAdapter(child: _buildGreeting()),
                SliverToBoxAdapter(child: _buildContinueReading(context)),
                SliverToBoxAdapter(child: _buildTrendingHeader()),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: _buildTrendingGrid(context),
                ),
                SliverToBoxAdapter(child: _buildPopularBooksHeader()),
                SliverToBoxAdapter(child: _buildPopularBooks(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.menu, color: AppColors.textPrimary, size: 22),
              const SizedBox(width: 10),
              const Text(
                'Readly',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tagBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ── Greeting + XP ─────────────────────────────────────────────────────────

  Widget _buildGreeting() {
    final email = AuthService.instance.currentUser?.email;
    final name = (email == null || email.isEmpty) ? 'Reader' : email.split('@').first;
    final level = XpData.level;
    final currentLevelXp = XpData.currentLevelXp;
    final xpNeeded = XpData.xpNeededForNextLevel;
    final progress = XpData.levelProgress;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hi, $name!', style: AppTextStyles.displayTitle),
          const SizedBox(height: 4),
          Text(
            'LEVEL $level',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 1.2,
              fontFamily: 'sans-serif',
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.progressBg,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level >= 10
                ? '${XpData.totalXp.value} XP'
                : '$currentLevelXp / $xpNeeded XP',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  // ── Continue Reading ───────────────────────────────────────────────────────

  Widget _buildContinueReading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 14),
          child: Text('Continue Reading', style: AppTextStyles.sectionTitle),
        ),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: continueReadingBooks.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final book = continueReadingBooks[i];
              return ContinueReadingCard(
                book: book,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailScreen(book: book),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Trending ───────────────────────────────────────────────────────────────

  Widget _buildTrendingHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Trending Now', style: AppTextStyles.sectionTitle),
          Text(
            'SEE ALL',
            style: AppTextStyles.label.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingGrid(BuildContext context) {
    final books = trendingBooks;

    if (books.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'No trending books right now.',
            style: AppTextStyles.caption,
          ),
        ),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, i) {
        final book = books[i];
        return TrendingCard(
          book: book,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
          ),
        );
      }, childCount: books.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
    );
  }

  Widget _buildPopularBooksHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Popular Books', style: AppTextStyles.sectionTitle),
          Text(
            'TRENDING',
            style: AppTextStyles.label.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBooks(BuildContext context) {
    final books = homeSpotlightBooks;
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: books.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final book = books[index];
          return SizedBox(
            width: 180,
            child: TrendingCard(
              book: book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
              ),
            ),
          );
        },
      ),
    );
  }
}
