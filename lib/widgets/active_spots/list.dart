import 'package:be_right_bark/widgets/active_spots/card.dart';
import 'package:flutter/material.dart';

class ActiveSpotsCardList extends StatelessWidget {
  final List<Map<String, String>> items;

  const ActiveSpotsCardList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return ActiveSpotCard(
          id: item['id'] ?? '',
          title: item['title'] ?? '',
          content: item['content'] ?? '',
        );
      },
    );
  }
}
