import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../assets.dart';
import '../../common/shader_effect.dart';
import '../../common/ticking_builder.dart';
import '../../styles.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key});

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
