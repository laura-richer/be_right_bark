import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/colors.dart';
import 'package:be_right_bark/widgets/animations/brb_icons.dart';

/// Success animation for marking a spot: the paw pops in, then the pin drops
/// onto it with a small squash as it lands.
///
/// Deliberately quick. Marking a spot is a "noted, carry on" moment and the
/// user wants to get back to their walk.
class SpotMarkedAnimation extends StatefulWidget {
  const SpotMarkedAnimation({super.key, this.size = 220, this.backgroundColor});

  final double size;

  /// Colour behind the icon, used for the knockout around the pin. Defaults to
  /// the theme surface colour.
  final Color? backgroundColor;

  @override
  State<SpotMarkedAnimation> createState() => _BagDroppedAnimationState();
}

class _BagDroppedAnimationState extends State<SpotMarkedAnimation>
    with SingleTickerProviderStateMixin {
  // Layout, as fractions of [BagDroppedAnimation.size].
  static const double _pawLeft = 0.116;
  static const double _pawTop = 0.146;
  static const double _pawSize = 0.768;
  static const double _pinLeft = 0.54;
  static const double _pinTop = 0.21;
  static const double _pinSize = 0.48;
  static const double _pawTilt = -15 * math.pi / 180;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final Animation<double> _pawScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.45, curve: Cubic(0.34, 1.56, 0.64, 1)),
  );

  late final Animation<double> _pin = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 1),
  );

  /// Falls from above, lands, bounces up slightly and settles. In fractions
  /// of the widget size so it scales with it.
  late final Animation<double> _pinY = _pin.drive(
    TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: -0.6,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 55,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 15),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -0.03,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.03,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
    ]),
  );

  /// Squashes wide on landing, then stretches tall on the rebound.
  late final Animation<double> _pinScaleX = _pin.drive(
    TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 0.97), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.97, end: 1.0), weight: 15),
    ]),
  );

  late final Animation<double> _pinScaleY = _pin.drive(
    TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.88), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.03), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.03, end: 1.0), weight: 15),
    ]),
  );

  late final Animation<double> _pinOpacity = _pin.drive(
    TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
    ]),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    // Respect the system "remove animations" setting.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final knockout =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

    return Semantics(
      image: true,
      label: 'Bag marked',
      child: SizedBox.square(
        dimension: s,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: s * _pawLeft,
                  top: s * _pawTop,
                  width: s * _pawSize,
                  height: s * _pawSize,
                  child: Transform.rotate(
                    angle: _pawTilt,
                    child: Transform.scale(
                      scale: _pawScale.value,
                      child: const CustomPaint(
                        painter: PawPainter(color: BrbColors.yellow),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: s * _pinLeft,
                  top: s * _pinTop,
                  width: s * _pinSize,
                  height: s * _pinSize,
                  child: Opacity(
                    opacity: _pinOpacity.value,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.diagonal3Values(
                        _pinScaleX.value,
                        _pinScaleY.value,
                        1,
                      )..setTranslationRaw(0, _pinY.value * s, 0),
                      child: CustomPaint(
                        painter: PinPainter(
                          color: BrbColors.green,
                          knockoutColor: knockout,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
