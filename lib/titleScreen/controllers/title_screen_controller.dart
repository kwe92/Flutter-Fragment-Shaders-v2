import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../../orb_shader/orb_shader_widget.dart';
import '../../styles.dart';

class TitleScreenController extends TickerProvider with ChangeNotifier {
  final orbKey = GlobalKey<OrbShaderWidgetState>();

  /// Editable Settings
  /// 0-1, receive lighting strength
  final _minReceiveLightAmt = .35;
  final _maxReceiveLightAmt = .7;

  /// 0-1, emit lighting strength
  final _minEmitLightAmt = .5;
  final _maxEmitLightAmt = 1;

  late final _pulseEffect = AnimationController(
    vsync: this,
    duration: _getRndPulseDuration(),
    lowerBound: -1,
    upperBound: 1,
  );

  /// Currently selected difficulty
  int _difficulty = 0;

  /// Currently focused difficulty (if any)
  int? _difficultyOverride;

  double _orbEnergy = 0;

  double _minOrbEnergy = 0;

  /// Internal
  var _mousePos = Offset.zero;

  AnimationController get pulseEffect => _pulseEffect;

  double get minOrbEnergy => _minOrbEnergy;

  /// Internal
  Offset get mousePos => _mousePos;

  int get difficulty => _difficulty;

  double get orbEnergy => _orbEnergy;

  // adding getters to a Widget Class derived from mutable variables, i guess you would handle this in the View Model though if using M-V-VM architecture
  Color get emitColor => AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get orbColor => AppColors.orbColors[_difficultyOverride ?? _difficulty];

  double get _finalReceiveLightAmt {
    final light = lerpDouble(_minReceiveLightAmt, _maxReceiveLightAmt, _orbEnergy) ?? 0;
    return light + _pulseEffect.value * .05 * _orbEnergy;
  }

  double get _finalEmitLightAmt {
    return lerpDouble(_minEmitLightAmt, _maxEmitLightAmt, _orbEnergy) ?? 0;
  }

  // function start

  TitleScreenController() {
    initialize();
  }

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  void initialize() {
    _pulseEffect.forward();

    _pulseEffect.addListener(_handlePulseEffectUpdate);
  }

  void setOrbEnergy(double energy) {
    _orbEnergy = energy;
    notifyListeners();
  }

  void handleDifficultyPressed(int value) {
    _difficulty = value;

    notifyListeners();

    _bumpMinEnergy();
  }

  void handleStartPressed() => _bumpMinEnergy(0.3);

  void handleDifficultyFocused(int? value) {
    _difficultyOverride = value;
    if (value == null) {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    } else {
      _minOrbEnergy = _getMinEnergyForDifficulty(value);
    }

    notifyListeners();
  }

  Duration _getRndPulseDuration() => 100.ms + 200.ms * Random().nextDouble();

  double _getMinEnergyForDifficulty(int difficulty) => switch (difficulty) {
        1 => 0.3,
        2 => 0.6,
        _ => 0,
      };

  void _handlePulseEffectUpdate() {
    if (_pulseEffect.status == AnimationStatus.completed) {
      _pulseEffect.reverse();
      _pulseEffect.duration = _getRndPulseDuration();
    } else if (_pulseEffect.status == AnimationStatus.dismissed) {
      _pulseEffect.duration = _getRndPulseDuration();
      _pulseEffect.forward();
    }
  }

  Future<void> _bumpMinEnergy([double amount = 0.1]) async {
    _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty) + amount;

    await Future<void>.delayed(.2.seconds);

    _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    notifyListeners();
  }

  /// Update mouse position so the orbWidget can use it, doing it here prevents
  /// btns from blocking the mouse-move events in the widget itself.
  void _handleMouseMove(PointerHoverEvent e) {
    _mousePos = e.localPosition;

    notifyListeners();
  }
}
