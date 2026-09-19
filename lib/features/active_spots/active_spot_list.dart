import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/features/active_spots/active_spot_card.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/utils/distance.dart';

class ActiveSpotsCardList extends StatelessWidget {
  final bool shrinkWrap;
  final int? count;
  final List<Location> locations;
  final Position? userPosition;

  const ActiveSpotsCardList({
    super.key,
    this.shrinkWrap = false,
    this.count,
    this.userPosition,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    var items = [...locations];

    if (userPosition != null) {
      items.sort((a, b) {
        final distA = Geolocator.distanceBetween(
          userPosition!.latitude, userPosition!.longitude,
          a.latitude, a.longitude,
        );
        final distB = Geolocator.distanceBetween(
          userPosition!.latitude, userPosition!.longitude,
          b.latitude, b.longitude,
        );
        return distA.compareTo(distB);
      });
    }

    if (count != null && count! > 0) {
      items = items.take(count!).toList();
    }

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: BrbSpacers.xs),
      itemBuilder: (context, index) {
        final item = items[index];
        return ActiveSpotCard(
          item: item,
          distance: formatDistance(userPosition, item.latitude, item.longitude),
        );
      },
    );
  }
}
