import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../assets.dart';
import '../orb_shader/orb_shader_config.dart';
import 'particle_overlay.dart';
import '../orb_shader/orb_shader_widget.dart';
import '../styles.dart';
import 'title_screen_ui.dart';

// TODO: Move widgets to a widgets folder

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with SingleTickerProviderStateMixin {
  final _orbKey = GlobalKey<OrbShaderWidgetState>();

  /// Editable Settings
  /// 0-1, receive lighting strength
  final _minReceiveLightAmt = .35;
  final _maxReceiveLightAmt = .7;

  /// 0-1, emit lighting strength
  final _minEmitLightAmt = .5;
  final _maxEmitLightAmt = 1;

  /// Internal
  var _mousePos = Offset.zero;

  // adding getters to a Widget Class derived from mutable variables, i guess you would handle this in the View Model though if using M-V-VM architecture
  Color get _emitColor => AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get _orbColor => AppColors.orbColors[_difficultyOverride ?? _difficulty];

  /// Currently selected difficulty
  int _difficulty = 0;

  /// Currently focused difficulty (if any)
  int? _difficultyOverride;

  double _orbEnergy = 0;
  double _minOrbEnergy = 0;

  double get _finalReceiveLightAmt {
    final light = lerpDouble(_minReceiveLightAmt, _maxReceiveLightAmt, _orbEnergy) ?? 0;
    return light + _pulseEffect.value * .05 * _orbEnergy;
  }

  double get _finalEmitLightAmt {
    return lerpDouble(_minEmitLightAmt, _maxEmitLightAmt, _orbEnergy) ?? 0;
  }

  late final _pulseEffect = AnimationController(
    vsync: this,
    duration: _getRndPulseDuration(),
    lowerBound: -1,
    upperBound: 1,
  );

  Duration _getRndPulseDuration() => 100.ms + 200.ms * Random().nextDouble();

  double _getMinEnergyForDifficulty(int difficulty) => switch (difficulty) {
        1 => 0.3,
        2 => 0.6,
        _ => 0,
      };

  @override
  void initState() {
    super.initState();
    _pulseEffect.forward();
    _pulseEffect.addListener(_handlePulseEffectUpdate);
  }

  void _handlePulseEffectUpdate() {
    if (_pulseEffect.status == AnimationStatus.completed) {
      _pulseEffect.reverse();
      _pulseEffect.duration = _getRndPulseDuration();
    } else if (_pulseEffect.status == AnimationStatus.dismissed) {
      _pulseEffect.duration = _getRndPulseDuration();
      _pulseEffect.forward();
    }
  }

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
    _bumpMinEnergy();
  }

  Future<void> _bumpMinEnergy([double amount = 0.1]) async {
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty) + amount;
    });
    await Future<void>.delayed(.2.seconds);
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    });
  }

  void _handleStartPressed() => _bumpMinEnergy(0.3);

  void _handleDifficultyFocused(int? value) {
    setState(() {
      _difficultyOverride = value;
      if (value == null) {
        _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
      } else {
        _minOrbEnergy = _getMinEnergyForDifficulty(value);
      }
    });
  }

  /// Update mouse position so the orbWidget can use it, doing it here prevents
  /// btns from blocking the mouse-move events in the widget itself.
  void _handleMouseMove(PointerHoverEvent e) {
    setState(() {
      _mousePos = e.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    const finalReceiveLightAmt = 0.7;

    const finalEmitLightAmt = 0.5;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        //!! using custom _AnimatedColors widget to transition between colors instead of jump cutting
        child: _AnimatedColors(
            orbColor: _orbColor,
            emitColor: _emitColor,
            builder: (_, orbColor, emitColor) {
              return Stack(
                children: [
                  /// Bg-Base
                  Image.asset(AssetPaths.titleBgBase),

                  /// Bg-Receive
                  _LitImage(
                    pulseEffect: _pulseEffect,
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
                          key: _orbKey,
                          mousePos: _mousePos,
                          minEnergy: _minOrbEnergy,
                          config: OrbShaderConfig(
                            ambientLightColor: orbColor,
                            materialColor: orbColor,
                            lightColor: orbColor,
                          ),
                          onUpdate: (energy) => setState(() {
                            _orbEnergy = energy;
                          }),
                        ),
                      ],
                    ),
                  ),

                  /// Mg-Base
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: orbColor,
                    imgSrc: AssetPaths.titleMgBase,
                    lightAmt: finalReceiveLightAmt,
                  ),

                  /// Mg-Receive
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: orbColor,
                    imgSrc: AssetPaths.titleMgReceive,
                    lightAmt: finalReceiveLightAmt,
                  ),

                  /// Mg-Emit
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: emitColor,
                    imgSrc: AssetPaths.titleMgEmit,
                    lightAmt: finalEmitLightAmt,
                  ),

                  Positioned.fill(
                    child: IgnorePointer(
                      child: ParticleOverlay(
                        color: orbColor,
                        energy: _orbEnergy,
                      ),
                    ),
                  ),

                  /// Fg-Rocks
                  Image.asset(AssetPaths.titleFgBase),

                  /// Fg-Receive
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: orbColor,
                    imgSrc: AssetPaths.titleFgReceive,
                    lightAmt: finalReceiveLightAmt,
                  ),

                  /// Fg-Emit
                  _LitImage(
                    pulseEffect: _pulseEffect,
                    color: emitColor,
                    imgSrc: AssetPaths.titleFgEmit,
                    lightAmt: finalEmitLightAmt,
                  ),
                  TitleScreenUi(
                    difficulty: _difficulty,
                    onDifficultyPressed: _handleDifficultyPressed,
                    onDifficultyFocused: _handleDifficultyFocused,
                    onStartPressed: _handleStartPressed,
                  )

                  //?? why use Positioned.fill here? | maybe later in the lesson it will be needed | as of step 4 it seems useless
                  // const Positioned.fill(child: TitleScreenUi())
                ],
              ).animate().fadeIn(duration: 1.seconds, delay: 0.3.seconds);
            }),
      ),
    );
  }
}

class _LitImage extends StatelessWidget {
  final Color color;

  final String imgSrc;

  final double lightAmt;

  final AnimationController pulseEffect;

  const _LitImage({
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
    required this.pulseEffect,
  });

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return ListenableBuilder(
        listenable: pulseEffect,
        builder: (context, _) {
          return Image.asset(
            imgSrc,
            //?? Adding color and light amount to an image
            //!! TODO: research why an HSL color scheme is used over RGB
            color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
            colorBlendMode: BlendMode.modulate,
          );
        });
  }
}

typedef AnimationBuilderCallback = Widget Function(BuildContext context, Color orbColor, Color emitColor);

//!! animate between colors: TweenAnimationBuilder
class _AnimatedColors extends StatelessWidget {
  final Color emitColor;

  final Color orbColor;

  final AnimationBuilderCallback builder;

  const _AnimatedColors({
    required this.emitColor,
    required this.orbColor,
    required this.builder,
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

//!! TODO: How to Change State and React to User Hovering on Widgets (Slightly Different then just using a hover css property)

//!! TODO: Understanding Effects of Coloring Mono-chromatic images

//!! TODO: Understanding Effects of Coloring Layered Gray-Scaled Images

//!! TODO: Understanding the withLightness abount | Seems similar to opacity or color alpha



// Major Goals

//   - reduce jump cutting by offering smoother transitions

//   - ad animation to every element on a screen
