// This is a basic Flutter widget test for CyberGuardian.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('CyberGuardian boot smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CyberGuardianApp());

    // Verify that our Splash Screen displays the title and subtitle.
    expect(find.text('CyberGuardian'), findsOneWidget);
    expect(find.text('Your Cybersecurity Companion'), findsOneWidget);

    // Pump the animation and delay timer (3 seconds) to completion
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    // Verify we have transitioned to the Login screen
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Log in to access your security dashboard'), findsOneWidget);
  });
}

