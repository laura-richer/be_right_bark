import 'package:flutter/widgets.dart';
import 'package:be_right_bark/router.dart';

void dismissDialogs() {
  final navigator = router.routerDelegate.navigatorKey.currentState;
  navigator?.popUntil((route) => route is! PopupRoute || route.isFirst);
}
