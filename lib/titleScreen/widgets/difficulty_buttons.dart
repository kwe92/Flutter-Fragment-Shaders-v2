import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'difficulty_button.dart';

class DifficultyButtons extends StatelessWidget {
  final int difficulty;

  final void Function(int difficulty) onDifficultyPressed;

  final void Function(int? difficulty) onDifficultyFocused;

  const DifficultyButtons({
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const slideOffset = Offset(0, 0.2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DifficultyButton(
          label: 'Casual',
          selected: difficulty == 0,
          onPressed: () => onDifficultyPressed.call(0),
          onHover: (over) => onDifficultyFocused.call(over ? 0 : null),
        ).animate()
          ..fadeIn(delay: 1.3.seconds, duration: 0.35.seconds)
          ..slide(begin: slideOffset),
        DifficultyButton(
          label: 'Normal',
          selected: difficulty == 1,
          onPressed: () => onDifficultyPressed.call(1),
          onHover: (over) => onDifficultyFocused.call(over ? 1 : null),
        ).animate()
          ..fadeIn(delay: 1.5.seconds, duration: 0.35.seconds)
          ..slide(begin: slideOffset),
        DifficultyButton(
          label: 'Hardcore',
          selected: difficulty == 2,
          onPressed: () => onDifficultyPressed.call(2),
          onHover: (over) => onDifficultyFocused.call(over ? 2 : null),
        ).animate()
          ..fadeIn(delay: 1.7.seconds, duration: 0.35.seconds)
          ..slide(begin: slideOffset),
        const Gap(20),
      ],
    );
  }
}
