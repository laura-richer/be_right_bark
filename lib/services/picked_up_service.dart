import 'package:shared_preferences/shared_preferences.dart';

const String _pickedUpCountKey = 'picked_up_count';

Future<int> getPickedUpCount() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_pickedUpCountKey) ?? 0;
}

Future<int> incrementPickedUpCount() async {
  final prefs = await SharedPreferences.getInstance();
  final count = (prefs.getInt(_pickedUpCountKey) ?? 0) + 1;
  await prefs.setInt(_pickedUpCountKey, count);
  return count;
}
