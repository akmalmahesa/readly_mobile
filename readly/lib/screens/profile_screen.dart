import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../data/badges_data.dart';
import '../data/books_data.dart';
import '../data/reading_levels.dart';
import '../data/xp_data.dart';
import '../services/auth_service.dart';
import '../widgets/trending_card.dart';
import 'book_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([libraryVersion, XpData.totalXp]),
      builder: (context, _) {
        final completed = completedBooks;
        final wishlist = savedBooks.where((book) => !book.isCompleted).toList();
        final unlockedBadges = BadgesData.badges
            .where((badge) => badge.isUnlocked)
            .toList();
        final level = XpData.level;
        final levelName = ReadingLevels.labelForLevel(level);
        final currentLevelXp = XpData.currentLevelXp;
        final xpNeeded = XpData.xpNeededForNextLevel;
        final progress = XpData.levelProgress;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopActions(context),
                  const SizedBox(height: 18),
                  _buildHeader(level, levelName, completed.length),
                  const SizedBox(height: 16),
                  _buildLevelCard(
                    level,
                    levelName,
                    currentLevelXp,
                    xpNeeded,
                    progress,
                  ),
                  const SizedBox(height: 14),
                  _buildStatsRow(
                    completed.length,
                    wishlist.length,
                    BadgesData.unlockedCount,
                  ),
                  const SizedBox(height: 18),
                  _buildFriendsSection(),
                  const SizedBox(height: 18),
                  _buildBadgeSummary(unlockedBadges),
                  const SizedBox(height: 18),
                  _buildWishlistSection(wishlist, context),
                  const SizedBox(height: 18),
                  _buildReadSection(completed, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _roundAction(Icons.share_outlined),
        const SizedBox(width: 10),
        _roundAction(
          Icons.logout,
          onTap: () => AuthService.instance.signOut(),
        ),
      ],
    );
  }

  Widget _roundAction(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildHeader(int level, String levelName, int completedCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 3),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/id/64/200/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _displayName(),
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _pill('Level $level', AppColors.primary, AppColors.surface),
            _pill(levelName, AppColors.accent, AppColors.surface),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${XpData.totalXp.value} XP • $completedCount books read',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  String _displayName() {
    final email = AuthService.instance.currentUser?.email;
    if (email == null || email.isEmpty) return 'Reader';
    return email.split('@').first;
  }

  Widget _pill(String text, Color bgColor, Color fgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fgColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    int level,
    String levelName,
    int currentLevelXp,
    int xpNeeded,
    double progress,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level $level Progress', style: AppTextStyles.label),
              Text(
                '$currentLevelXp / $xpNeeded XP',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.progressBg,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            level >= 10
                ? 'Max level reached'
                : '${XpData.xpToNextLevel} XP to reach Level ${level + 1}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 8),
          Text(
            levelName,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int completed, int wishlistCount, int badgeCount) {
    return Row(
      children: [
        Expanded(
          child: _statCard(Icons.check_circle_outline, completed, 'Read'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(Icons.book_outlined, wishlistCount, 'Wishlist'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(Icons.emoji_events_outlined, badgeCount, 'Badges'),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, int count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildFriendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Friends (2)', style: AppTextStyles.sectionTitle),
            Text(
              'View all →',
              style: AppTextStyles.label.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            _FriendAvatar(
              name: 'Sarah',
              imageUrl: 'https://picsum.photos/id/65/200/200',
            ),
            SizedBox(width: 14),
            _FriendAvatar(
              name: 'Maya',
              imageUrl: 'https://picsum.photos/id/66/200/200',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgeSummary(List badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Badge Summary', style: AppTextStyles.sectionTitle),
            Text(
              'View all →',
              style: AppTextStyles.label.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: badges.take(4).map((badge) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent.withOpacity(0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(badge.icon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(badge.name, style: AppTextStyles.label),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWishlistSection(List<Book> wishlist, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Readlist / Wishlist', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        if (wishlist.isEmpty)
          Text('No books in your wishlist yet.', style: AppTextStyles.caption)
        else
          SizedBox(
            height: 238,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: wishlist.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final book = wishlist[index];
                return SizedBox(
                  width: 160,
                  child: TrendingCard(
                    book: book,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(book: book),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildReadSection(List<Book> completed, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Read', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        if (completed.isEmpty)
          Text('No completed books yet.', style: AppTextStyles.caption)
        else
          SizedBox(
            height: 238,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: completed.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final book = completed[index];
                return SizedBox(
                  width: 160,
                  child: TrendingCard(
                    book: book,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(book: book),
                      ),
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

class _FriendAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _FriendAvatar({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.5),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTextStyles.caption),
      ],
    );
  }
}
