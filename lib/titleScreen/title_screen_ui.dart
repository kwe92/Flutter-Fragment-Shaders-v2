import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';

import '../common/ui_scaler.dart';

import 'widgets/difficulty_buttons.dart';
import 'widgets/start_button.dart';
import 'widgets/title_text.dart';

@immutable
class TitleScreenUi extends StatelessWidget {
  final int difficulty;

  final void Function(int) onDifficultyPressed;

  final void Function(int?) onDifficultyFocused;

  final VoidCallback onStartPressed;

  const TitleScreenUi({
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
    required this.onStartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
      child: Stack(
        children: [
          /// Title Text
          const TopLeft(
            child: UiScaler(
              alignment: Alignment.topLeft,
              child: TitleText(),
            ),
          ),
          BottomLeft(
            // Add from here...
            child: UiScaler(
              alignment: Alignment.bottomLeft,
              child: DifficultyButtons(
                difficulty: difficulty,
                onDifficultyPressed: onDifficultyPressed,
                onDifficultyFocused: onDifficultyFocused,
              ),
            ),
          ),

          BottomRight(
            child: UiScaler(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 40),
                child: StartButton(onPressed: onStartPressed),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------//

// flutter_animate package

//   - offers a declarative approach to animating widgets seemlessly

//   - wrap target widget with Animate widget

//   - initialize controllers for the Animate widget

//   - automatically play animations

//   - fade effects

//   - slide effects

//   - shimmer effects and MORE!!!

//---------------------------------------------------------------------------------------------------------------------------------------//

// Animating Widgets With The flutter_animate animate extension

//   - a declarative way to add animations to a widget

//   - add animation to a widget with a chain of method calls
//     initially with the .animate() method to Wrap the widget in an Animate widget

//---------------------------------------------------------------------------------------------------------------------------------------//

// flutter_animate: seconds Extension

//   - a concise way to add a duration using integers and doubles with a seconds property
//     added through an extension

//---------------------------------------------------------------------------------------------------------------------------------------//

// Hovering Shimmer Effect

//   - .shimmer() method part of the flutter_animate declarative API

//   - autoPlay should be false as to not play the animation on app start up or view loading
//     if that functionality is not required

//---------------------------------------------------------------------------------------------------------------------------------------//

// FocusableControlBuilder

//   - state.isHovered || state.isFocused properties to handle if a widget is hovered or focused

//   - under the hood, FocusableControlBuilder wraps the built in FocusableActionDetector