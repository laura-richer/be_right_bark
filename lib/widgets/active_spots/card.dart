import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/location.dart';

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

  const ActiveSpotCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryContainer,
            blurRadius: 0,
            offset: const Offset(0, 3),
            spreadRadius: -4,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => context.push('/active-spots/${item.id}'),
        child: Card(
          color: Theme.of(context).colorScheme.onSecondary,
          shadowColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustomPaint(
                          painter: EllipsePainter(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiary.withOpacity(0.3),
                          ),
                          child: const SizedBox(width: 20, height: 8),
                        ),
                        Icon(
                          Icons.location_pin,
                          size: 30,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.name != null
                            ? Text(
                                item.name!,
                                style: Theme.of(context).textTheme.titleSmall,
                              )
                            : Container(),
                        Text(
                          item.latitude.toStringAsFixed(2) +
                              item.longitude.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
