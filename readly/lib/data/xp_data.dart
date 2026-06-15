import 'package:flutter/foundation.dart';
import 'reading_levels.dart';

class XpData {
  static const List<int> _levelStarts = [
    0,
    100,
    300,
    600,
    1000,
    1500,
    2100,
    2800,
    3600,
    4500,
  ];

  static const List<int> _levelEnds = [
    100,
    300,
    600,
    1000,
    1500,
    2100,
    2800,
    3600,
    4500,
    5500,
  ];

  static final ValueNotifier<int> totalXp = ValueNotifier<int>(0);

  static int get level => levelForXp(totalXp.value);

  static String get levelName => ReadingLevels.labelForLevel(level);

  static int get currentLevelXp => totalXp.value - _levelStarts[level - 1];

  static int get xpNeededForNextLevel =>
      level >= 10 ? 0 : _levelEnds[level - 1] - _levelStarts[level - 1];

  static int get xpToNextLevel =>
      level >= 10 ? 0 : _levelEnds[level - 1] - totalXp.value;

  static double get levelProgress {
    if (level >= 10) return 1;
    final start = _levelStarts[level - 1];
    final end = _levelEnds[level - 1];
    return ((totalXp.value - start) / (end - start)).clamp(0, 1);
  }

  static int levelForXp(int xp) {
    for (var i = _levelStarts.length - 1; i >= 0; i--) {
      if (xp >= _levelStarts[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  static void addXp(int amount) {
    totalXp.value += amount;
  }
}
