import 'package:flutter/material.dart';
import '/widgets/common/locations_builder.dart';
import '/widgets/common/user_position_builder.dart';
import '/utils/distance.dart';

class ActiveSpotScreen extends StatelessWidget {
  final String id;

  const ActiveSpotScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserPositionBuilder(
        builder: (context, userPosition) => LocationBuilder(
          locationKey: int.parse(id),
          builder: (context, location) {
            if (location == null) {
              return Center(child: Text('Spot not found'));
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(location.latitude.toString()),
                  if (userPosition != null)
                    Text(formatDistance(
                      userPosition,
                      location.latitude,
                      location.longitude,
                    )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
