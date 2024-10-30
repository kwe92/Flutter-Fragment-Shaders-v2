import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../assets.dart';
import '../orb_shader/orb_shader_config.dart';

import '../orb_shader/orb_shader_widget.dart';

import 'controllers/title_screen_controller.dart';
import 'title_screen_ui.dart';

import 'widgets/animated_colors.dart';
import 'widgets/illuminated_image.dart';
import 'widgets/particle_overlay.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const finalReceiveLightAmt = 0.7;

    const finalEmitLightAmt = 0.5;

    return ChangeNotifierProvider(
        create: (context) => TitleScreenController(),
        builder: (context, _) {
          final screenController = context.watch<TitleScreenController>();
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: AnimatedColors(
                  orbColor: screenController.orbColor,
                  emitColor: screenController.emitColor,
                  builder: (_, orbColor, emitColor) {
                    return Stack(
                      children: [
                        /// Bg-Base
                        Image.asset(AssetPaths.titleBgBase),

                        /// Bg-Receive
                        IlluminatedImage(
                          pulseEffect: screenController.pulseEffect,
                          color: orbColor,
                          imgSrc: AssetPaths.titleBgReceive,
                          lightAmt: finalReceiveLightAmt,
                        ),

                        /// Orb
                        Positioned.fill(
                          child: Stack(
                            children: [
                              // Orb
                              OrbShaderWidget(
                                  key: screenController.orbKey,
                                  mousePos: screenController.mousePos,
                                  minEnergy: screenController.minOrbEnergy,
                                  config: OrbShaderConfig(
                                    ambientLightColor: orbColor,
                                    materialColor: orbColor,
                                    lightColor: orbColor,
                                  ),
                                  onUpdate: screenController.setOrbEnergy),
                            ],
                          ),
                        ),

                        /// Mg-Base
                        IlluminatedImage(
                          pulseEffect: screenController.pulseEffect,
                          color: orbColor,
                          imgSrc: AssetPaths.titleMgBase,
                          lightAmt: finalReceiveLightAmt,
                        ),

                        /// Mg-Receive
                        IlluminatedImage(
                          pulseEffect: screenController.pulseEffect,
                          color: orbColor,
                          imgSrc: AssetPaths.titleMgReceive,
                          lightAmt: finalReceiveLightAmt,
                        ),

                        /// Mg-Emit
                        IlluminatedImage(
                          pulseEffect: screenController.pulseEffect,
                          color: emitColor,
                          imgSrc: AssetPaths.titleMgEmit,
                          lightAmt: finalEmitLightAmt,
                        ),

                        Positioned.fill(
                          child: IgnorePointer(
                            child: ParticleOverlay(
                              color: orbColor,
                              energy: screenController.orbEnergy,
                            ),
                          ),
                        ),

                        /// Fg-Rocks
                        Image.asset(AssetPaths.titleFgBase),

                        /// Fg-Receive
                        IlluminatedImage(
                          pulseEffect: screenController.pulseEffect,
                          color: orbColor,
                          imgSrc: AssetPaths.titleFgReceive,
                          lightAmt: finalReceiveLightAmt,
                        ),

                        /// Fg-Emit
                        IlluminatedImage(
                          pulseEffect: screenController.pulseEffect,
                          color: emitColor,
                          imgSrc: AssetPaths.titleFgEmit,
                          lightAmt: finalEmitLightAmt,
                        ),
                        TitleScreenUi(
                          difficulty: screenController.difficulty,
                          onDifficultyPressed: screenController.handleDifficultyPressed,
                          onDifficultyFocused: screenController.handleDifficultyFocused,
                          onStartPressed: screenController.handleStartPressed,
                        )
                      ],
                    ).animate().fadeIn(duration: 1.seconds, delay: 0.3.seconds);
                  }),
            ),
          );
        });
  }
}

// Major Goals

//   - reduce jump cutting by offering smoother transitions

//   - add animation to every element on a screen

//   - how to change mutable state and react to user hovering over widgets (slightly different then just using a hover css property)

//   - understanding the affects of coloring Mono-chromatic images

//   - Understanding the need to express light with HSL color model over RGB color model

