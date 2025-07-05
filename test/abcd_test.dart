import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:royal_wiki/content_screen.dart';
import 'package:royal_wiki/detail_screen.dart';
import 'package:royal_wiki/post_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'new_pst_service_test.mocks.dart';

void main() {
  runGoldenTestsForScreen(
      testName: "abcddd",
      widgetunderTest: DetailScreen(
        postService: PostService(client: MockClient()),
      ),
      fileNmae: "abcd_sd_test");
  // goldenTest(
  //   'abcd game',
  //   fileName: 'some_scsss',
  //   constraints: const BoxConstraints(
  //     maxWidth: 375,
  //   ),
  //   builder: () => MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: const ContentScreen(),
  //   ),
  // );
  // group('ListTile Golden Testssss', () {

  //   goldenTest(
  //     'renders correctlyyyy',
  //     fileName: 'listttt_tile',
  //     builder: () => GoldenTestGroup(
  //       // scenarioConstraints: const BoxConstraints(maxWidth: 440),
  //       children: [
  //         GoldenTestScenario(
  //             constraints: BoxConstraints(maxWidth: 375),
  //             name: 'with title',
  //             child: const DetailScreen()),
  //         // GoldenTestScenario(
  //         //   name: 'with title and subtitle',
  //         //   child: const ListTile(
  //         //     title: Text('ListTile.title'),
  //         //     subtitle: Text('ListTile.subtitle'),
  //         //   ),
  //         // ),
  //         // GoldenTestScenario(
  //         //   name: 'with trailing icon',
  //         //   child: const ListTile(
  //         //     title: Text('ListTile.title'),
  //         //     trailing: Icon(Icons.chevron_right_rounded),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );

  // });
}

class MockDeviceWrapper extends StatelessWidget {
  final ScreenGoldenTestScenario scenario;
  final Widget child;

  const MockDeviceWrapper(
      {super.key, required this.scenario, required this.child});

  @override
  Widget build(BuildContext context) {
    final scaleForiPad = scenario.device == Devices.ios.iPad12InchesGen4;
    final showHomeIndicator = scenario.device != Devices.android.smallPhone &&
        scenario.device != Devices.ios.iPhoneSE;
    return Stack(
      children: [
        child,

        // Mock status bar
        Positioned(
          top: scenario.topOffset,
          left: scaleForiPad ? -150 : 40,
          right: scaleForiPad ? -150 : 40,
          child: Transform.scale(
            scale: scaleForiPad ? 0.55 : 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.signal_cellular_alt, size: 16),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.battery_full, size: 16),
                ),
              ],
            ),
          ),
        ),

        // Mock Home indicator

        if (showHomeIndicator)
          Positioned(
            bottom: scenario.bottomOffset,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: scaleForiPad ? 0.55 : 1,
              child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100.0,
                    height: 5.0,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(2.5)),
                  )),
            ),
          ),
      ],
    );
  }
}

class ScreenGoldenTestScenario {
  final String name;
  final double textScaleFactor;
  final ThemeData theme;
  final DeviceInfo device;
  final Orientation orientation;
  final double topOffset;
  final double bottomOffset;

  ScreenGoldenTestScenario({
    required this.name,
    this.textScaleFactor = 1,
    required this.theme,
    required this.device,
    this.orientation = Orientation.portrait,
    this.topOffset = 35,
    this.bottomOffset = 35,
  });
}

typedef GoldenFeatureFlagWrapper = Widget Function(Widget child);
Future<void> runGoldenTestsForScreen({
  required String testName,
  required Widget widgetunderTest,
  required String fileNmae,
  //  List<Override>? providerOverrides,
  Future<Future<void> Function()?> Function(WidgetTester)? whilePerforming,
  Map<String, Map<String, String>>? contentOverrides,
  GoldenFeatureFlagWrapper? featureFlagWrapper,
}) async {
  final theme =
      ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.iOS);
  final List<ScreenGoldenTestScenario> scenarios = [
    ScreenGoldenTestScenario(
      name: 'iOS - light - 1x',
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.iOS),
      device: Devices.ios.iPhone13,
    ),
    ScreenGoldenTestScenario(
      name: 'iOS - dark - 1x',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ).copyWith(platform: TargetPlatform.iOS),
      device: Devices.ios.iPhone13,
    ),
    ScreenGoldenTestScenario(
      name: 'iOS - light - small - 1x',
      topOffset: 115,
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.iOS),
      device: Devices.ios.iPhoneSE,
    ),
    ScreenGoldenTestScenario(
      name: 'Android - light - small - 1x',
      topOffset: 90,
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.android),
      device: Devices.ios.iPhoneSE,
    ),
    ScreenGoldenTestScenario(
      name: 'iOS - light - 0.8x',
      textScaleFactor: 0.8,
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.iOS),
      device: Devices.ios.iPhone13,
    ),
    ScreenGoldenTestScenario(
      name: 'iOS - light - 1.35x',
      textScaleFactor: 1.35,
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.iOS),
      device: Devices.ios.iPhone13,
    ),
    ScreenGoldenTestScenario(
      name: 'iPad - vertical - 1x',
      topOffset: 25,
      bottomOffset: 25,
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
          .copyWith(platform: TargetPlatform.iOS),
      device: Devices.ios.iPad12InchesGen4,
    ),
    ScreenGoldenTestScenario(
        name: 'Pad - horizontal - 1x',
        topOffset: 18,
        bottomOffset: 20,
        theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
            .copyWith(platform: TargetPlatform.macOS),
        device: Devices.ios.iPad12InchesGen4,
        orientation: Orientation.landscape),
  ];

  final mappedScenarios = scenarios.map(
    (scenario) {
      return MaterialApp(
        supportedLocales: [Locale("en", "GB")],
        localizationsDelegates: [],
        debugShowCheckedModeBanner: false,
        theme: scenario.theme,
        home: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                scenario.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topCenter,
                child: MediaQuery(
                    data: MediaQueryData(
                        textScaler:
                            TextScaler.linear(scenario.textScaleFactor)),
                    child: MockDeviceWrapper(
                        scenario: scenario,
                        child: DeviceFrame(
                          device: scenario.device,
                          screen: widgetunderTest,
                          orientation: scenario.orientation,
                        ))),
              ),
            )
          ],
        ),
      );
    },
  ).toList();

  AlchemistConfig.runWithConfig(
      config: AlchemistConfig(
          goldenTestTheme: GoldenTestTheme(
              backgroundColor: Colors.white,
              borderColor: Colors.grey,
              nameTextStyle: TextStyle(fontSize: 18),
              padding: EdgeInsets.all(15)),
          forceUpdateGoldenFiles: false,
          theme: theme,
          ciGoldensConfig: CiGoldensConfig(obscureText: false, theme: theme),
          platformGoldensConfig:
              PlatformGoldensConfig(platforms: {}, theme: theme)),
      run: () {
        TestWidgetsFlutterBinding.ensureInitialized();

        HttpOverrides.global = null;

        goldenTest(
          testName,
          fileName: fileNmae,
          whilePerforming: whilePerforming,
          pumpWidget: (tester, widget) async {
            await tester.pumpWidget(widget);
            await tester.pumpAndSettle();
          },
          // pumpBeforeTest: (tester) {},
          builder: () {
            VisibilityDetectorController.instance.updateInterval =
                Duration.zero;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testName,
                ),
                GoldenTestGroup(
                    columns: 4,
                    columnWidthBuilder: (columns) => FixedColumnWidth(500),
                    children: mappedScenarios)
              ],
            );
          },
        );
      });
}
