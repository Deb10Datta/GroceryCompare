import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Host-side driver for the walkthrough: saves every screenshot the test
/// takes into docs/screenshots/, where the README references them.
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('docs/screenshots/$name.png');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      return true;
    },
  );
}
