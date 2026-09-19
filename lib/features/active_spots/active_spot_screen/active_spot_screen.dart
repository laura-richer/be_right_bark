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
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/constants/name.dart';
import 'package:be_right_bark/widgets/map_pin.dart';

class ActiveSpotScreen extends ConsumerStatefulWidget {
  final int id;
  final TileProvider? tileProvider;

  const ActiveSpotScreen({super.key, required this.id, this.tileProvider});

  @override
  ConsumerState<ActiveSpotScreen> createState() => _ActiveSpotScreenState();
}

class _ActiveSpotScreenState extends ConsumerState<ActiveSpotScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _removeConfirmationIsActive = false;

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
      builder: (dialogContext) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: BrbSpacers.md),
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

  void _handleShowRemoveConfirmation() {
    setState(() => _removeConfirmationIsActive = true);
  }

  void _handleCancelConfirmation() {
    setState(() => _removeConfirmationIsActive = false);
  }

  void _handleRemoveLocation(WidgetRef ref) {
    ref.read(locationProvider.notifier).deleteLocation(widget.id);
    context.pop();
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

  void _handleEditDescription(WidgetRef ref, String? currentDescription) {
    _showEditDialog(
      controller: _descriptionController,
      currentValue: currentDescription ?? '',
      label: currentDescription != null
          ? editDescriptionButtonLabel
          : addDescriptionButtonLabel,
      maxLength: descriptionMaxLength,
      isTextArea: true,
      onSave: (value) => ref
          .read(locationProvider.notifier)
          .updateDescription(widget.id, value),
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

    return Center(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 35),
            child: Row(
              children: [
                if (location.name != null) TitleMedium(text: location.name!),
                const Spacer(),
                if (!_removeConfirmationIsActive) ...[
                  ButtonSmall(
                    buttonText: removeButtonLabel,
                    icon: Icons.delete,
                    iconAlignment: IconAlignment.end,
                    onPressed: () => _handleShowRemoveConfirmation(),
                  ),
                ],
                if (_removeConfirmationIsActive) ...[
                  Confirmation(
                    onConfirm: () => _handleRemoveLocation(ref),
                    onCancel: () => _handleCancelConfirmation(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: BrbSpacers.sm),
          SizedBox(
            height: 200,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(location.latitude, location.longitude),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          const SizedBox(height: BrbSpacers.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ButtonSmall(
                    buttonText: location.name != null
                        ? editNameButtonLabel
                        : addNameButtonLabel,
                    icon: Icons.edit,
                    iconAlignment: IconAlignment.end,
                    onPressed: () => _handleEditName(ref, location.name),
                  ),
                  ButtonSmall(
                    buttonText: location.description != null
                        ? editDescriptionButtonLabel
                        : addDescriptionButtonLabel,
                    icon: Icons.article,
                    iconAlignment: IconAlignment.end,
                    onPressed: () =>
                        _handleEditDescription(ref, location.description),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: BrbSpacers.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(location.description ?? '')],
          ),
        ],
      ),
    );
  }
}
