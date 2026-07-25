import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrimind/core/di/injection_container.dart';
import 'package:nutrimind/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  tearDown(() => getIt.reset());

  testWidgets('Splash screen shows app name and tagline', (WidgetTester tester) async {
    // Use a phone-sized viewport so ScreenUtil-scaled layouts don't overflow
    // the default 800x600 test surface.
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NutriMindApp());

    expect(find.text('NutriMind AI'), findsOneWidget);
    expect(find.text('Your AI Nutrition Assistant'), findsOneWidget);

    // Let the splash screen's navigation timer fire before the test ends.
    await tester.pump(const Duration(seconds: 3));
  });
}
