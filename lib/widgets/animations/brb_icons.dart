import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Shapes for the app's icons, drawn in their native coordinate spaces so the
/// animations can scale them to any size without an SVG dependency.
///
/// The paw is traced from the original paw asset and lives in a 512 x 512 box.
/// The pin and check are Material Symbols paths, converted from their SVG
/// viewBox of 0 -960 960 960 into a 960 x 960 box.

const double pawBox = 512;
const double materialIconBox = 960;

/// Where the check sits on the paw's pad, in paw coordinates.
const Offset _checkOffset = Offset(145.6, 271.95);
const double _checkScale = 0.23;

/// Horizontal extent of the check path, used to wipe it on left to right.
const double _checkStartX = 154;
const double _checkWidth = 652;

final Path _pawPad = Path()
  ..moveTo(256, 226.3)
  ..cubicTo(326.3, 226.3, 396.3, 287.2, 421.4, 371.5)
  ..cubicTo(433.5, 420, 430, 454.4, 400.2, 468.6)
  ..cubicTo(358, 488.9, 303.6, 462.4, 256, 462.4)
  ..cubicTo(208.4, 462.4, 154, 488.9, 111.8, 468.6)
  ..cubicTo(82, 454.4, 78.5, 420, 90.6, 371.5)
  ..cubicTo(115.7, 287.2, 185.7, 226.3, 256, 226.3)
  ..close();

void _paintToe(
  Canvas canvas,
  Paint paint, {
  required double cx,
  required double cy,
  required double rx,
  required double ry,
  required double degrees,
}) {
  canvas
    ..save()
    ..translate(cx, cy)
    ..rotate(degrees * math.pi / 180)
    ..drawOval(
      Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
      paint,
    )
    ..restore();
}

/// Paints the paw into a 512 x 512 box.
void paintPaw(Canvas canvas, Paint paint) {
  _paintToe(canvas, paint, cx: 57.2, cy: 241.5, rx: 56, ry: 70.8, degrees: -17.5);
  _paintToe(canvas, paint, cx: 454.8, cy: 241.5, rx: 56, ry: 70.8, degrees: 17.5);
  _paintToe(canvas, paint, cx: 179.3, cy: 128.4, rx: 67.8, ry: 92.4, degrees: -3);
  _paintToe(canvas, paint, cx: 332.7, cy: 128.4, rx: 67.8, ry: 92.4, degrees: 3);
  canvas.drawPath(_pawPad, paint);
}

final Path whereToVotePinPath = Path()
  ..moveTo(480, 774.0)
  ..quadraticBezierTo(602, 662.0, 661, 570.5)
  ..quadraticBezierTo(720, 479.0, 720, 408.0)
  ..quadraticBezierTo(720, 299.0, 650.5, 229.5)
  ..quadraticBezierTo(581, 160.0, 480, 160.0)
  ..quadraticBezierTo(379, 160.0, 309.5, 229.5)
  ..quadraticBezierTo(240, 299.0, 240, 408.0)
  ..quadraticBezierTo(240, 479.0, 299, 570.5)
  ..quadraticBezierTo(358, 662.0, 480, 774.0)
  ..close()
  ..moveTo(480, 880.0)
  ..quadraticBezierTo(319, 743.0, 239.5, 625.5)
  ..quadraticBezierTo(160, 508.0, 160, 408.0)
  ..quadraticBezierTo(160, 258.0, 256.5, 169.0)
  ..quadraticBezierTo(353, 80.0, 480, 80.0)
  ..quadraticBezierTo(607, 80.0, 703.5, 169.0)
  ..quadraticBezierTo(800, 258.0, 800, 408.0)
  ..quadraticBezierTo(800, 508.0, 720.5, 625.5)
  ..quadraticBezierTo(641, 743.0, 480, 880.0)
  ..close()
  ..moveTo(480, 400.0)
  ..close();

final Path whereToVoteTickPath = Path()
  ..moveTo(438, 534.0)
  ..lineTo(636, 336.0)
  ..lineTo(579, 279.0)
  ..lineTo(438, 420.0)
  ..lineTo(382, 364.0)
  ..lineTo(325, 421.0)
  ..lineTo(438, 534.0)
  ..close();

/// The line the tick is drawn along, used to reveal it stroke first rather
/// than wiping it on.
final Path _tickStroke = Path()
  ..moveTo(353, 393)
  ..lineTo(438, 478)
  ..lineTo(607, 308);

/// A five point star in a 20 x 20 box, used by the confetti.
final Path starPath = Path()
  ..moveTo(10, 1)
  ..lineTo(12.6, 7)
  ..lineTo(19, 7.4)
  ..lineTo(14, 11.6)
  ..lineTo(15.6, 18)
  ..lineTo(10, 14.4)
  ..lineTo(4.4, 18)
  ..lineTo(6, 11.6)
  ..lineTo(1, 7.4)
  ..lineTo(7.4, 7)
  ..close();

final Path locationPinPath = Path()
    ..moveTo(536.5, 456.5)
    ..quadraticBezierTo(560, 433, 560, 400)
    ..quadraticBezierTo(560, 367, 536.5, 343.5)
    ..quadraticBezierTo(513, 320, 480, 320)
    ..quadraticBezierTo(447, 320, 423.5, 343.5)
    ..quadraticBezierTo(400, 367, 400, 400)
    ..quadraticBezierTo(400, 433, 423.5, 456.5)
    ..quadraticBezierTo(447, 480, 480, 480)
    ..quadraticBezierTo(513, 480, 536.5, 456.5)
    ..close()
    ..moveTo(480, 774)
    ..quadraticBezierTo(602, 662, 661, 570.5)
    ..quadraticBezierTo(720, 479, 720, 408)
    ..quadraticBezierTo(720, 299, 650.5, 229.5)
    ..quadraticBezierTo(581, 160, 480, 160)
    ..quadraticBezierTo(379, 160, 309.5, 229.5)
    ..quadraticBezierTo(240, 299, 240, 408)
    ..quadraticBezierTo(240, 479, 299, 570.5)
    ..quadraticBezierTo(358, 662, 480, 774)
    ..close()
    ..moveTo(480, 880)
    ..quadraticBezierTo(319, 743, 239.5, 625.5)
    ..quadraticBezierTo(160, 508, 160, 408)
    ..quadraticBezierTo(160, 258, 256.5, 169)
    ..quadraticBezierTo(353, 80, 480, 80)
    ..quadraticBezierTo(607, 80, 703.5, 169)
    ..quadraticBezierTo(800, 258, 800, 408)
    ..quadraticBezierTo(800, 508, 720.5, 625.5)
    ..quadraticBezierTo(641, 743, 480, 880)
    ..close()
    ..moveTo(480, 400)
    ..close();

final Path locationPinOutlinePath = Path()
    ..moveTo(480, 880)
    ..quadraticBezierTo(319, 743, 239.5, 625.5)
    ..quadraticBezierTo(160, 508, 160, 408)
    ..quadraticBezierTo(160, 258, 256.5, 169)
    ..quadraticBezierTo(353, 80, 480, 80)
    ..quadraticBezierTo(607, 80, 703.5, 169)
    ..quadraticBezierTo(800, 258, 800, 408)
    ..quadraticBezierTo(800, 508, 720.5, 625.5)
    ..quadraticBezierTo(641, 743, 480, 880)
    ..close();

final Path checkPath = Path()
    ..moveTo(382, 720)
    ..lineTo(154, 492)
    ..lineTo(211, 435)
    ..lineTo(382, 606)
    ..lineTo(749, 239)
    ..lineTo(806, 296)
    ..lineTo(382, 720)
    ..close();

/// Draws the paw.
class PawPainter extends CustomPainter {
  const PawPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / pawBox);
    paintPaw(canvas, Paint()..color = color);
  }

  @override
  bool shouldRepaint(PawPainter oldDelegate) => oldDelegate.color != color;
}

/// Draws the location pin with a knockout halo, so it sits cleanly on top of
/// the paw the way it does on the Mark spot button.
///
/// [knockoutColor] should match whatever is behind the icon.
class PinPainter extends CustomPainter {
  const PinPainter({required this.color, required this.knockoutColor});

  final Color color;
  final Color knockoutColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / materialIconBox);

    final knockout = Paint()..color = knockoutColor;
    canvas
      ..drawPath(locationPinOutlinePath, knockout)
      ..drawPath(
        locationPinOutlinePath,
        Paint()
          ..color = knockoutColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 80
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawPath(locationPinPath, Paint()..color = color);
  }

  @override
  bool shouldRepaint(PinPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.knockoutColor != knockoutColor;
  }
}

/// Draws the where_to_vote badge: a pin with a tick in it, with the same
/// knockout halo as [PinPainter] so it sits cleanly on the paw.
///
/// [tickProgress] runs 0 to 1 and draws the tick along its stroke.
class WhereToVotePainter extends CustomPainter {
  const WhereToVotePainter({
    required this.color,
    required this.knockoutColor,
    this.tickProgress = 1,
  });

  final Color color;
  final Color knockoutColor;
  final double tickProgress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / materialIconBox);

    canvas
      ..drawPath(locationPinOutlinePath, Paint()..color = knockoutColor)
      ..drawPath(
        locationPinOutlinePath,
        Paint()
          ..color = knockoutColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 80
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawPath(whereToVotePinPath, Paint()..color = color);

    if (tickProgress <= 0) return;
    if (tickProgress >= 1) {
      canvas.drawPath(whereToVoteTickPath, Paint()..color = color);
      return;
    }

    // Keep only the part of the tick the stroke has reached so far.
    final metric = _tickStroke.computeMetrics().first;
    final drawn = metric.extractPath(0, metric.length * tickProgress);

    canvas
      ..saveLayer(const Rect.fromLTWH(0, 0, materialIconBox, materialIconBox),
          Paint())
      ..drawPath(whereToVoteTickPath, Paint()..color = color)
      ..drawPath(
        drawn,
        Paint()
          ..blendMode = BlendMode.dstIn
          ..style = PaintingStyle.stroke
          ..strokeWidth = 150,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(WhereToVotePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.knockoutColor != knockoutColor ||
        oldDelegate.tickProgress != tickProgress;
  }
}
