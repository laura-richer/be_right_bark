import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:be_right_bark/styles/colors.dart';
import 'package:be_right_bark/widgets/animations/brb_icons.dart';

/// Success animation for picking a bag up: the paw pops in, a check draws on
/// its pad, and two waves of confetti burst out and drift down.
///
/// This is the payoff moment of the app, so it's allowed to linger — about
/// three and a half seconds in total, though the paw and check are done in
/// under one.
class PickedUpAnimation extends StatefulWidget {
  const PickedUpAnimation({super.key, this.size = 300});

  /// Width and height of the whole stage, confetti included. The paw takes up
  /// the middle 62% of it.
  final double size;

  @override
  State<PickedUpAnimation> createState() => _PickedUpAnimationState();
}

class _PickedUpAnimationState extends State<PickedUpAnimation>
    with SingleTickerProviderStateMixin {
  static const double _totalSeconds = 3.6;
  static const double _artFraction = 0.62;
  static const double _pawLeft = 0.116;
  static const double _pawTop = 0.146;
  static const double _pawSize = 0.768;
  static const double _pawTilt = -15 * math.pi / 180;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  late final Animation<double> _pawScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.55 / _totalSeconds, curve: Cubic(0.34, 1.7, 0.64, 1)),
  );

  late final Animation<double> _check = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.5 / _totalSeconds, 0.9 / _totalSeconds, curve: Curves.easeOut),
  );

  late final List<_Confetto> _behind;
  late final List<_Confetto> _inFront;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    // Each wave has a layer behind the paw and a layer in front, for depth.
    List<_Confetto> layer() => [
          ..._Confetto.wave(random, count: 12, spread: math.pi * 1.9, minDistance: 55, distanceRange: 45, lift: 1, baseDuration: 1.8, baseDelay: 0.4, originY: 0),
          ..._Confetto.wave(random, count: 11, spread: math.pi * 1.3, minDistance: 75, distanceRange: 55, lift: 1.15, baseDuration: 2.0, baseDelay: 0.85, originY: -0.06),
        ];
    _behind = layer();
    _inFront = layer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    // With animations off, land straight on the finished state: paw and check
    // shown, confetti already gone.
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
    final art = s * _artFraction;

    return Semantics(
      image: true,
      label: 'Bag picked up',
      child: SizedBox.square(
        dimension: s,
        // Remove this ClipRect to let confetti fall across the whole screen.
        child: ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final seconds = _controller.value * _totalSeconds;
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ConfettiPainter(_behind, seconds),
                    ),
                  ),
                  Center(
                    child: SizedBox.square(
                      dimension: art,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: art * _pawLeft,
                            top: art * _pawTop,
                            width: art * _pawSize,
                            height: art * _pawSize,
                            child: Transform.rotate(
                              angle: _pawTilt,
                              child: Transform.scale(
                                scale: _pawScale.value,
                                child: CustomPaint(
                                  painter: PawPainter(
                                    color: BrbColors.yellow,
                                    checkColor: BrbColors.green,
                                    checkProgress: _check.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ConfettiPainter(_inFront, seconds),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

enum _ConfettoShape { rect, circle, star }

/// One piece of confetti. Distances are in a 340 unit stage and scaled to the
/// real size when painted.
class _Confetto {
  const _Confetto({
    required this.dx,
    required this.dy,
    required this.rotation,
    required this.sway,
    required this.duration,
    required this.delay,
    required this.originY,
    required this.shape,
    required this.color,
    required this.width,
    required this.height,
  });

  final double dx;
  final double dy;
  final double rotation;
  final double sway;
  final double duration;
  final double delay;
  final double originY;
  final _ConfettoShape shape;
  final Color color;
  final double width;
  final double height;

  static const List<Color> _palette = [
    BrbColors.yellow,
    BrbColors.orange,
    BrbColors.green,
    BrbColors.beige,
  ];

  static List<_Confetto> wave(
    math.Random random, {
    required int count,
    required double spread,
    required double minDistance,
    required double distanceRange,
    required double lift,
    required double baseDuration,
    required double baseDelay,
    required double originY,
  }) {
    return List.generate(count, (i) {
      final angle = -math.pi / 2 + (random.nextDouble() - 0.5) * spread;
      final distance = minDistance + random.nextDouble() * distanceRange;
      final roll = random.nextDouble();

      final shape = roll < 0.12
          ? _ConfettoShape.star
          : roll < 0.4
              ? _ConfettoShape.circle
              : _ConfettoShape.rect;

      final double width;
      final double height;
      switch (shape) {
        case _ConfettoShape.star:
          width = 14;
          height = 14;
        case _ConfettoShape.circle:
          width = 6 + random.nextDouble() * 4;
          height = width;
        case _ConfettoShape.rect:
          width = 5 + random.nextDouble() * 4;
          height = width * 1.6;
      }

      return _Confetto(
        dx: math.cos(angle) * distance,
        dy: math.sin(angle) * distance * lift,
        rotation: (random.nextDouble() * 240 - 120) * math.pi / 180,
        sway: (random.nextDouble() - 0.5) * 24,
        duration: baseDuration + random.nextDouble() * 0.6,
        delay: baseDelay + random.nextDouble() * 0.12,
        originY: originY,
        shape: shape,
        color: shape == _ConfettoShape.star
            ? _palette[i % 2]
            : _palette[i % _palette.length],
        width: width,
        height: height,
      );
    });
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// Paints a layer of confetti at a given moment.
///
/// Each piece bursts out fast over the first 18% of its life, then drifts
/// down while swaying side to side, fading out over the final stretch.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.seconds);

  final List<_Confetto> pieces;
  final double seconds;

  static const double _stageUnits = 340;
  static const double _burstEnd = 0.18;
  static const double _swayOne = 0.329;
  static const double _swayTwo = 0.659;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _stageUnits;

    for (final c in pieces) {
      final life = (seconds - c.delay) / c.duration;
      if (life <= 0 || life >= 1) continue;

      double x;
      double y;
      double spin;
      double grow = 1;
      double opacity = 1;

      if (life < _burstEnd) {
        final p = Curves.easeOutQuart.transform(life / _burstEnd);
        x = c.dx * p;
        y = c.dy * p;
        spin = c.rotation * p;
        grow = p;
      } else {
        final u = (life - _burstEnd) / (1 - _burstEnd);
        if (u < _swayOne) {
          final f = Curves.easeInOut.transform(u / _swayOne);
          x = _lerp(c.dx, c.dx + c.sway, f);
          y = _lerp(c.dy, c.dy + 40, f);
          spin = _lerp(c.rotation, c.rotation * 1.6, f);
        } else if (u < _swayTwo) {
          final f = Curves.easeInOut.transform((u - _swayOne) / (_swayTwo - _swayOne));
          x = _lerp(c.dx + c.sway, c.dx - c.sway, f);
          y = _lerp(c.dy + 40, c.dy + 85, f);
          spin = _lerp(c.rotation * 1.6, c.rotation * 2.2, f);
        } else {
          final f = Curves.easeInOut.transform((u - _swayTwo) / (1 - _swayTwo));
          x = _lerp(c.dx - c.sway, c.dx + c.sway, f);
          y = _lerp(c.dy + 85, c.dy + 135, f);
          spin = _lerp(c.rotation * 2.2, c.rotation * 3, f);
          opacity = 1 - f;
        }
      }

      final paint = Paint()..color = c.color.withValues(alpha: opacity);
      final w = c.width * scale;
      final h = c.height * scale;

      canvas
        ..save()
        ..translate(
          size.width / 2 + x * scale,
          size.height * (0.5 + c.originY) + y * scale,
        )
        ..rotate(spin)
        ..scale(grow);

      switch (c.shape) {
        case _ConfettoShape.rect:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: w, height: h),
              Radius.circular(2 * scale),
            ),
            paint,
          );
        case _ConfettoShape.circle:
          canvas.drawCircle(Offset.zero, w / 2, paint);
        case _ConfettoShape.star:
          canvas
            ..translate(-w / 2, -h / 2)
            ..scale(w / 20)
            ..drawPath(starPath, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.seconds != seconds;
  }
}
