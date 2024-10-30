import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';

import '../../assets.dart';
import '../../styles.dart';

class DifficultyButton extends StatelessWidget {
  final String label;

  final bool selected;

  final VoidCallback onPressed;

  final void Function(bool hasFocus) onHover;

  const DifficultyButton({
    required this.selected,
    required this.onPressed,
    required this.onHover,
    required this.label,
    super.key,
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
