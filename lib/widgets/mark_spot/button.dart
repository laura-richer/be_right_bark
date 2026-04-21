import 'package:be_right_bark/widgets/common/buttons/button_medium.dart';
import 'package:be_right_bark/widgets/common/buttons/button_small.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/widgets/common/buttons/button_large.dart';
import '/utils/location.dart';
import '/utils/permissions.dart';

class MarkSpotButton extends StatefulWidget implements PreferredSizeWidget {
  const MarkSpotButton({super.key});

  @override
  State<MarkSpotButton> createState() => _MarkSpotButtonState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MarkSpotButtonState extends State<MarkSpotButton> {
  bool _saving = false;

  Future<void> _handlePress() async {
    if (!hasLocationPermission) {
      _showSettingsDialog();
      return;
    }

    setState(() => _saving = true);
    await _showLoadingOverlay();
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _showLoadingOverlay() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        saveLocation().then((_) {
          navigator.pop();
        });

        return PopScope(
          canPop: true,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Getting current location'),
                    SizedBox(height: 16),
                    ButtonSmall(
                      buttonText: 'Cancel',
                      icon: Icons.close,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location access needed', style: Theme.of(context).textTheme.titleMedium,),
        content: Text(
          'Be Right Bark needs your location to mark spots.'
          'Please enable location access in your device settings.',
        ),
        actions: [
          ButtonSmall(
            buttonText: 'Cancel',
            icon: Icons.close,
            onPressed: () => Navigator.pop(context)
          ),
          SizedBox(width: 16),
          ButtonMedium(
            buttonText: 'Open settings',
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            }
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonLarge(
      buttonText: 'Mark spot',
      image: 'lib/assets/mark_spot_icon.png',
      onPressed: _saving ? null : _handlePress,
    );
  }
}
