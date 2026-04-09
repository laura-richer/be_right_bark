  import 'package:flutter/material.dart';

  class NavState extends ChangeNotifier {
    int selectedId = 0;

    void select(int id) {
      selectedId = id;
      notifyListeners();
    }
  }
