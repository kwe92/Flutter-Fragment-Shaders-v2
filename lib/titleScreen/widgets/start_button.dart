import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';

import '../../assets.dart';
import '../../styles.dart';

@immutable
class StartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const StartButton({required this.onPressed, super.key});

  @override
  State<StartButton> createState() => StartButtonState();
}

class StartButtonState extends State<StartButton> {
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
              Positioned.fill(child: Image.asset(AssetPaths.titleStartButton)),
              // show over state image instead of creating an animation to fill the space
              if (state.isHovered || state.isFocused) ...[
                Positioned.fill(child: Image.asset(AssetPaths.titleStartButtonHover)),
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
