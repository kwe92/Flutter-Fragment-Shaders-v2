import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

typedef AnimationBuilderCallback = Widget Function(BuildContext context, Color orbColor, Color emitColor);

class AnimatedColors extends StatelessWidget {
  final Color emitColor;

  final Color orbColor;

  final AnimationBuilderCallback builder;

  const AnimatedColors({
    required this.emitColor,
    required this.orbColor,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final duration = .5.seconds;

    //?? nested TweenAnimationBuilder to animate between two colors fully
    return TweenAnimationBuilder(
      tween: ColorTween(begin: emitColor, end: emitColor),
      duration: duration,
      builder: (_, emitColor, __) {
        return TweenAnimationBuilder(
          tween: ColorTween(begin: orbColor, end: orbColor),
          duration: duration,
          builder: (context, orbColor, __) {
            return builder.call(context, orbColor!, emitColor!);
          },
        );
      },
    );
  }
}

//  TODO: explain animating between colors

//!! using custom _AnimatedColors widget to transition between colors instead of jump cutting

//!! animate between colors: TweenAnimationBuilder

