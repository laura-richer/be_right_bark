import 'package:flutter/material.dart';
import '/widgets/active_spots/card.dart';
class ActiveSpotsCardList extends StatelessWidget {
  final bool shrinkWrap;
  final int? count;

  const ActiveSpotsCardList({
    super.key,
    this.shrinkWrap = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      {'title': 'Woodland', 'content': '200m away - Dropped 15mins ago', 'id': '0'},
      {'title': 'Grassland', 'content': '50m away - Dropped 94mins ago', 'id': '1'},
      {'content': '100m away - Dropped 30mins ago', 'id': '2'},
    ];

    var mappedItems = items.map((item) => item).toList();

    if (count != null && count! > 0) {
      mappedItems = mappedItems.take(count!).toList();
    }

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      itemCount: mappedItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = mappedItems[index];
        return ActiveSpotCard(
          id: item['id'] ?? '',
          title: item['title'],
          content: item['content'] ?? '',
        );
      },
    );
  }
}
