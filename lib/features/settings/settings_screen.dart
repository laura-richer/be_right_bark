import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:be_right_bark/domain/spot_machine.dart';
import 'package:be_right_bark/models/location.dart';
import 'package:be_right_bark/services/notification_service.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';
import 'package:be_right_bark/widgets/titles/title_medium.dart';
import 'package:be_right_bark/widgets/titles/title_small.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _permissionGranted;

  Box<Location> get _box => Hive.box<Location>('locations');

  /// The most recently marked spot, used as the subject of every test
  /// notification. Null when nothing has been marked yet.
  int? get _testSpotKey {
    if (_box.isEmpty) return null;
    return _box.keys.last as int;
  }

  Future<void> _requestPermission() async {
    final granted = await requestNotificationPermission();
    if (!mounted) return;
    setState(() => _permissionGranted = granted);
  }

  Future<void> _showAlert(NotifyKind kind) async {
    final key = _testSpotKey;
    if (key == null) return;

    final spot = _box.get(key);
    if (spot == null) return;

    await showSpotAlert(
      kind: kind,
      spotCreatedAt: spot.createdAt,
      spotKey: key,
      spotName: spot.name,
    );
  }

  Future<void> _showSummary(int count) async {
    final key = _testSpotKey;
    await showOutstandingSummary(
      activeCount: count,
      soleSpotCreatedAt: key == null ? null : _box.get(key)?.createdAt,
      soleSpotKey: key,
    );
  }

  String get _permissionLabel {
    return switch (_permissionGranted) {
      null => 'Request notification permission',
      true => 'Permission granted - request again',
      false => 'Permission denied - try again',
    };
  }

  @override
  Widget build(BuildContext context) {
    final key = _testSpotKey;
    final hasSpot = key != null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const TitleMedium(text: 'Notification testing'),
          const SizedBox(height: BrbSpacers.sm),
          TitleSmall(
            text: hasSpot
                ? 'Testing against spot $key'
                : 'Mark a spot first - nothing to test against',
          ),
          const SizedBox(height: BrbSpacers.md),
          ButtonMedium(
            buttonText: _permissionLabel,
            onPressed: _requestPermission,
          ),
          const SizedBox(height: BrbSpacers.lg),
          ButtonMedium(
            buttonText: 'Alert: approaching (200m)',
            onPressed: hasSpot
                ? () => _showAlert(NotifyKind.approaching)
                : null,
          ),
          const SizedBox(height: BrbSpacers.sm),
          ButtonMedium(
            buttonText: 'Alert: arrived (100m)',
            onPressed: hasSpot ? () => _showAlert(NotifyKind.arrived) : null,
          ),
          const SizedBox(height: BrbSpacers.lg),
          ButtonMedium(
            buttonText: 'Summary: one bag',
            onPressed: () => _showSummary(1),
          ),
          const SizedBox(height: BrbSpacers.sm),
          ButtonMedium(
            buttonText: 'Summary: three bags',
            onPressed: () => _showSummary(3),
          ),
          const SizedBox(height: BrbSpacers.sm),
          ButtonMedium(
            buttonText: 'Summary: clear',
            onPressed: () => _showSummary(0),
          ),
          const SizedBox(height: BrbSpacers.xxl),
        ],
      ),
    );
  }
}
