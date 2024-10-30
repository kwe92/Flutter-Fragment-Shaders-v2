import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../assets.dart';
import '../common/shader_effect.dart';
import '../common/ticking_builder.dart';
import '../common/ui_scaler.dart';
import '../styles.dart';

// TODO: Move widgets to a widgets folder

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
              child: _TitleText(),
            ),
          ),
          BottomLeft(
            // Add from here...
            child: UiScaler(
              alignment: Alignment.bottomLeft,
              child: _DifficultyBtns(
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
                child: _StartBtn(onPressed: onStartPressed),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Consumer<FragmentPrograms?>(
      // Add from here...
      builder: (context, fragmentPrograms, _) {
        if (fragmentPrograms == null) return content;
        //!! TODO: review the bellow code
        return TickingBuilder(
          builder: (context, time) {
            return AnimatedSampler(
              (image, size, canvas) {
                const double overdrawPx = 30;
                final shader = fragmentPrograms.ui.fragmentShader();
                shader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, time)
                  ..setImageSampler(0, image);
                Rect rect = Rect.fromLTWH(-overdrawPx, -overdrawPx, size.width + overdrawPx, size.height + overdrawPx);
                canvas.drawRect(rect, Paint()..shader = shader);
              },

              //!! review end

              child: content,
            );
          },
        );
      },
    );
  }

  Widget get content => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //!! TODO: Review offsetting widgets | can use Transform.translate(offset: Offset()) to move a widget (Translation ridgeid motion) and Positined to position the widget in common places like center top left right etc. Seems like it can be used to as a Translation as well
              Transform.translate(
                offset: Offset(-(TextStyles.h1.letterSpacing! * .5), 0),
                child: Text('OUTPOST', style: TextStyles.h1),
              ),
              Image.asset(AssetPaths.titleSelectedLeft, height: 65),
              Text('57', style: TextStyles.h2),
              Image.asset(AssetPaths.titleSelectedRight, height: 65),
            ],
          ).animate().fadeIn(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 800),
              ),
          Text('INTO THE UNKNOWN', style: TextStyles.h3).animate().fadeIn(delay: 1.seconds, duration: .7.seconds),
        ],
      );
}

class _DifficultyBtns extends StatelessWidget {
  final int difficulty;

  final void Function(int difficulty) onDifficultyPressed;

  final void Function(int? difficulty) onDifficultyFocused;

  const _DifficultyBtns({
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
  });

  @override
  Widget build(BuildContext context) {
    const slideOffset = Offset(0, 0.2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DifficultyBtn(
          label: 'Casual',
          selected: difficulty == 0,
          onPressed: () => onDifficultyPressed.call(0),
          onHover: (over) => onDifficultyFocused.call(over ? 0 : null),
        ).animate()
          ..fadeIn(delay: 1.3.seconds, duration: 0.35.seconds)
          ..slide(begin: slideOffset),
        _DifficultyBtn(
          label: 'Normal',
          selected: difficulty == 1,
          onPressed: () => onDifficultyPressed.call(1),
          onHover: (over) => onDifficultyFocused.call(over ? 1 : null),
        ).animate()
          ..fadeIn(delay: 1.5.seconds, duration: 0.35.seconds)
          ..slide(begin: slideOffset),
        _DifficultyBtn(
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

class _DifficultyBtn extends StatelessWidget {
  final String label;

  final bool selected;

  final VoidCallback onPressed;

  final void Function(bool hasFocus) onHover;

  const _DifficultyBtn({
    required this.selected,
    required this.onPressed,
    required this.onHover,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    //!! TODO: look into FocusableControlBuilder
    return FocusableControlBuilder(
      onPressed: onPressed,
      onHoverChanged: (_, state) => onHover.call(state.isHovered),
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            height: 60,
            child: Stack(
              children: [
                /// Bg with fill and outline
                AnimatedOpacity(
                  duration: 0.3.seconds,
                  //!! display widget in this case a Container with a BoxDecoration depending on if the widget is selected or in different states
                  opacity: (!selected && (state.isHovered || state.isFocused)) ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D1FF).withOpacity(.1),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                  ),
                ),

                //!! react to user hover
                if (state.isHovered || state.isFocused) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D1FF).withOpacity(.1),
                    ),
                  ),
                ],

                /// cross-hairs (selected state) for menu buttons
                if (selected) ...[
                  CenterLeft(
                    child: Image.asset(AssetPaths.titleSelectedLeft),
                  ),
                  CenterRight(
                    child: Image.asset(AssetPaths.titleSelectedRight),
                  ),
                ],

                /// Label
                Center(
                  child: Text(label.toUpperCase(), style: TextStyles.btn),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StartBtn extends StatefulWidget {
  final VoidCallback onPressed;

  const _StartBtn({required this.onPressed});

  @override
  State<_StartBtn> createState() => _StartBtnState();
}

class _StartBtnState extends State<_StartBtn> {
  AnimationController? _btnAnim;

  bool _wasHovered = false;

  // a callback passed to the declarative flutter_animate API initializing an AnimationController
  void _initializeController(AnimationController constroller) => _btnAnim = constroller;

  @override
  Widget build(BuildContext context) {
    //!! react to user hover
    return FocusableControlBuilder(
      cursor: SystemMouseCursors.click,
      onPressed: widget.onPressed,
      builder: (_, state) {
        //!! react to user hover, play animation if user hovers or widget is focused
        if ((state.isHovered || state.isFocused) && !_wasHovered && _btnAnim?.status != AnimationStatus.forward) {
          _btnAnim?.forward(from: 0);
        }
        _wasHovered = (state.isHovered || state.isFocused);
        return SizedBox(
          width: 520,
          height: 100,
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset(AssetPaths.titleStartBtn)),
              // show over state image instead of creating an animation to fill the space
              if (state.isHovered || state.isFocused) ...[
                Positioned.fill(child: Image.asset(AssetPaths.titleStartBtnHover)),
              ],
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'START MISSION',
                      style: TextStyles.btn.copyWith(fontSize: 24, letterSpacing: 18),
                    ),
                  ],
                ),
              ),
            ],
          ).animate(autoPlay: false, onInit: _initializeController)
            ..shimmer(duration: 0.7.seconds, color: Colors.black),
        ).animate().fadeIn(delay: 2.3.seconds).slide(begin: const Offset(0, 0.2));
      },
    );
  }
}

// TODO: explore flutter_animate package

// flutter_animate package

//   - offers a declarative approach to animating widgets seemlessly

//   - wrap target widget with Animate widget

//   - initialize controllers for the ANimate widget

//   - automatically play animations

//   - fade effects

//   - slide effects

//   - shimmer effects and MORE!!!

// Animating Widgets With The flutter_animate animate extension

//   - a declarative way to add animations to a widget

//   - add animation to a widget with a chain of method calls that wrap the widget in an Animate widget

// flutter_animate: seconds Extension

//   - a concise way to add a duration using integers and doubles with a seconds property

// Hovering Shimmer Effect

//   - .shimmer() method part of the flutter_animate declarative API

//   - autoPlay should be false as to not play the animation on app start up or view loading


// FocusableControlBuilder

//   - state.isHovered || state.isFocused properties to handle if a widget is hovered or focused

// Nesting Animations With flutter_animate declarative API's
