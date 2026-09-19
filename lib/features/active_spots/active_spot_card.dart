import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/widgets/titles/title_small.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/utils/time.dart';
import 'package:be_right_bark/widgets/map_pin.dart';

class EllipsePainter extends CustomPainter {
  final Color color;
  EllipsePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ActiveSpotCard extends StatelessWidget {
  final Location item;
  final String distance;

  const ActiveSpotCard({super.key, required this.item, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BrbSpacers.sm),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outlineVariant,
            blurRadius: 0,
            offset: const Offset(0, 3),
            spreadRadius: -4,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => context.push('/active-spots/${item.key}'),
        child: Card(
          shadowColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(BrbSpacers.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const MapPin(),
                    const SizedBox(width: BrbSpacers.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.name != null
                            ? TitleSmall(text: item.name!)
                            : const SizedBox.shrink(),
                        Row(
                          children: [
                            Text(distance),
                            const Text(' - '),
                            Text('Marked ${formatTimestamp(item.createdAt)}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
