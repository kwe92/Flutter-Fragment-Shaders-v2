import 'package:flutter/material.dart';

@immutable
class IlluminatedImage extends StatelessWidget {
  final Color color;

  final String imgSrc;

  final double lightAmt;

  final AnimationController pulseEffect;

  const IlluminatedImage({
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
    required this.pulseEffect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);

    return ListenableBuilder(
        listenable: pulseEffect,
        builder: (context, _) {
          return Image.asset(
            imgSrc,
            color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
            colorBlendMode: BlendMode.modulate,
          );
        });
  }
}


// HSL: Hue - Saturation - Lightness

//   - a color model defining its colors with the followingthree properties:

//       - Hue: Represents the pure color (red, green, blue, etc.)

//       - Saturation: Determines the color's intensity or purity

//       - Lightness: Controls the brightness or darkness of the color

//   - canbe viewed as a more intuitive way to work with colors
//     especially for manipulating brightness and adding lighting effects

// Adding Color and Light Amount to an Image

//   - using the HSL (hue, saturation, and lightness) color model over RGB (red, green, and blue) color model
//     is generally preferred 

//   - HSL allows you to control the aspects of a colors on a more granular level than RGB

//   - you can manipulate individual components (hue, saturation, or lightness) of a color while perserving the rest

//   - with RGB manipulating properties like opacity can affect all three colors giving you unexpected results