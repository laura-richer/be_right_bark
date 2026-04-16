import 'package:flutter/material.dart';
import '/widgets/active_spots/card.dart';

class ActiveSpotsCardList extends StatelessWidget {
  final List<Map<String, String>> items;
  final bool shrinkWrap;

  const ActiveSpotsCardList({
    super.key,
    required this.items,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return ActiveSpotCard(
          id: item['id'] ?? '',
          title: item['title'],
          content: item['content'] ?? '',
        );
      },
    );
  }
}
