import 'package:flutter/material.dart';
import '../core/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text('📚', style: TextStyle(fontSize: 52)),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Readly',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track books, unlock badges, keep reading.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontFamily: 'sans-serif',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
