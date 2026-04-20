import 'package:flutter/material.dart';
import '/widgets/active_spots/card.dart';
import '/models/location.dart';

class ActiveSpotsCardList extends StatelessWidget {
  final bool shrinkWrap;
  final int? count;
  final List<Location> locations;

  const ActiveSpotsCardList({
    super.key,
    this.shrinkWrap = false,
    this.count,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    var items = locations;

    if (count != null && count! > 0) {
      items = items.take(count!).toList();
    }

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return ActiveSpotCard(item: item);
      },
    );
  }
}
