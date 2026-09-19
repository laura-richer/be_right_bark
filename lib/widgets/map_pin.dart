import 'package:be_right_bark/features/active_spots/active_spot_card.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:flutter/material.dart';

class MapPin extends StatelessWidget {
  const MapPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          painter: EllipsePainter(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.3),
          ),
          child: const SizedBox(width: BrbSpacers.md, height: BrbSpacers.xs),
        ),
        Icon(
          Icons.location_pin,
          size: 30,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
