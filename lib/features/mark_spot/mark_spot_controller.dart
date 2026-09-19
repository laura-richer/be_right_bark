import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/services/geolocator_service.dart';
import 'package:be_right_bark/utils/permissions.dart';

enum MarkSpotStatus { idle, loading, success, permissionDenied, error }

class MarkSpotState {
  final MarkSpotStatus status;
  final int? spotKey;
  final String? errorMessage;

  const MarkSpotState({
    this.status = MarkSpotStatus.idle,
    this.spotKey,
    this.errorMessage,
  });
}

class MarkSpotController extends Notifier<MarkSpotState> {
  @override
  MarkSpotState build() => const MarkSpotState();

  Future<void> markSpot() async {
    if (ref.read(locationPermissionProvider) != LocationPermissionStatus.granted) {
      state = const MarkSpotState(status: MarkSpotStatus.permissionDenied);
      return;
    }

    state = const MarkSpotState(status: MarkSpotStatus.loading);

    try {
      final cachedPosition = ref.read(userPositionProvider).valueOrNull;
      final position =
          cachedPosition ??
          await ref.read(geolocatorServiceProvider).getCurrentPosition();
      if (state.status != MarkSpotStatus.loading) return;
      final spotKey = await ref
          .read(locationProvider.notifier)
          .saveFromPosition(position);
      state = MarkSpotState(status: MarkSpotStatus.success, spotKey: spotKey);
    } catch (e) {
      state = MarkSpotState(
        status: MarkSpotStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const MarkSpotState();
  }
}

final markSpotControllerProvider =
    NotifierProvider<MarkSpotController, MarkSpotState>(MarkSpotController.new);
