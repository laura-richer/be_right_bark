import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/widgets/titles/title_medium.dart';
import 'package:be_right_bark/providers/location_provider.dart';
import 'package:be_right_bark/providers/user_position_provider.dart';
import 'package:be_right_bark/utils/distance.dart';
import 'package:be_right_bark/widgets/titles/title_small.dart';
import 'package:be_right_bark/widgets/buttons/button_small.dart';
import 'package:be_right_bark/widgets/confirmation/confirmation.dart';
import 'package:be_right_bark/features/active_spots/active_spot_screen/constants.dart';
import 'package:be_right_bark/utils/time.dart';
import 'package:be_right_bark/widgets/form_text_field.dart';
import 'package:be_right_bark/widgets/brb_dialog.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/constants/name.dart';
import 'package:be_right_bark/widgets/map_pin.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';
import 'package:be_right_bark/services/picked_up_service.dart';
import 'package:be_right_bark/services/notification_service.dart';

class ActiveSpotScreen extends ConsumerStatefulWidget {
  final int id;
  final TileProvider? tileProvider;

  const ActiveSpotScreen({super.key, required this.id, this.tileProvider});

  @override
  ConsumerState<ActiveSpotScreen> createState() => _ActiveSpotScreenState();
}

class _ActiveSpotScreenState extends ConsumerState<ActiveSpotScreen> {
  final _nameController = TextEditingController();
  // final _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showEditDialog({
    required TextEditingController controller,
    required String currentValue,
    required String label,
    required int maxLength,
    required Future<void> Function(String?) onSave,
    bool isTextArea = false,
  }) {
    controller.text = currentValue;

    showDialog(
      context: context,
      builder: (dialogContext) => BrbDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: FormTextField(
            label: label,
            maxLength: maxLength,
            controller: controller,
            isTextArea: isTextArea,
            onSave: (value) {
              onSave(value);
              Navigator.of(dialogContext).pop();
            },
            onCancel: () => Navigator.of(dialogContext).pop(),
          ),
        ),
      ),
    );
  }

  void _handleRemoveLocation(WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => BrbDialog(
        content: Confirmation(
          onConfirm: () {
            ref.read(locationProvider.notifier).deleteLocation(widget.id);
            Navigator.of(dialogContext).pop();
            context.pop();
          },
          onCancel: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  Future<void> _handlePickedUp(WidgetRef ref) async {
    final location = ref.read(locationProvider.notifier).getByKey(widget.id);
    if (location == null) return;

    await incrementPickedUpCount();
    await cancelSpotAlert(location.createdAt);
    await ref.read(locationProvider.notifier).deleteLocation(widget.id);

    final activeCount = ref.read(locationProvider).length;
    await showOutstandingSummary(activeCount: activeCount);

    if (!mounted) return;
    context.go('/picked-up');
  }

  void _handleEditName(WidgetRef ref, String? currentName) {
    _showEditDialog(
      controller: _nameController,
      currentValue: currentName ?? '',
      label: currentName != null ? editNameFieldLabel : addNameFieldLabel,
      maxLength: nameMaxLength,
      onSave: (value) =>
          ref.read(locationProvider.notifier).updateName(widget.id, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(locationProvider);
    final location = ref.read(locationProvider.notifier).getByKey(widget.id);
    final userPosition = ref.watch(userPositionProvider).valueOrNull;

    if (location == null) {
      return const Center(child: Text(spotNotFound));
    }

    return Column(
      children: [
        SingleChildScrollView(
          padding: BrbSpacers.screenPadding,
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 35),
                child: Row(
                  children: [
                    if (location.name != null)
                      TitleMedium(text: location.name!),
                    const Spacer(),
                    ButtonSmall(
                      buttonText: location.name != null
                          ? ''
                          : addNameButtonLabel,
                      icon: Icons.edit,
                      iconAlignment: IconAlignment.end,
                      onPressed: () => _handleEditName(ref, location.name),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: BrbSpacers.sm),
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      location.latitude,
                      location.longitude,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.be_right_bark',
                      tileProvider: widget.tileProvider,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(location.latitude, location.longitude),
                          alignment: Alignment.topCenter,
                          rotate: true,
                          child: const MapPin(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonMedium(
                  icon: Icons.where_to_vote,
                  buttonText: pickedUpButtonLabel,
                  onPressed: () => _handlePickedUp(ref),
                ),
                const SizedBox(height: BrbSpacers.xl),
                ButtonSmall(
                  buttonText: removeButtonLabel,
                  icon: Icons.delete,
                  iconAlignment: IconAlignment.end,
                  onPressed: () => _handleRemoveLocation(ref),
                ),
              ],
            ),
          ),
        ),
        ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(BrbSpacers.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (userPosition != null)
                  TitleSmall(
                    text: formatDistance(
                      userPosition,
                      location.latitude,
                      location.longitude,
                    ),
                  ),
                TitleSmall(
                  text: 'Marked ${formatTimestamp(location.createdAt)}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
