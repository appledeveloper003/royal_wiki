import 'dart:async';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return prepareGoldenTests(testMain);
}

void prepareGoldenTests(FutureOr<void> Function() testMain) {
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        renderShadows: true,
        obscureText: false,
      ),
    ),
    run: testMain,
  );
}
