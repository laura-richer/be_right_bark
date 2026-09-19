import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

bool hiveDataWasReset = false;

Future<void> openHiveBox<T>(String boxName) async {
  try {
    await Hive.openBox<T>(boxName);
  } catch (e) {
    log('Hive box "$boxName" failed to open, retrying: $e');
    try {
      await Hive.openBox<T>(boxName);
    } catch (e) {
      log('Hive box "$boxName" unrecoverable, deleting and recreating: $e');
      await Hive.deleteBoxFromDisk(boxName);
      await Hive.openBox<T>(boxName);
      hiveDataWasReset = true;
    }
  }
}
