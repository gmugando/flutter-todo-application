import 'package:flutter/foundation.dart';

// Only import ObjectBox on non-web platforms
late dynamic objectboxStore;

/// Initialize ObjectBox
Future<void> initObjectBox() async {
  if (kIsWeb) {
    throw UnsupportedError('ObjectBox is not supported on web platform');
  }

  // ObjectBox initialization handled by generated code in main.dart
  // This will only work on native platforms
  throw UnsupportedError('ObjectBox not available on this platform');
}

/// Get the Store instance
dynamic getObjectBoxStore() => objectboxStore;

/// Get the TodoItem box
dynamic getTodoBox() {
  throw UnsupportedError('ObjectBox is not supported on web platform');
}
