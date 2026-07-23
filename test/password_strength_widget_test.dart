import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/profile/widgets/password_strength_widget.dart';

void main() {
  Widget createWidgetUnderTest(String password) {
    return MaterialApp(
      home: Scaffold(
        body: PasswordStrengthIndicator(password: password),
      ),
    );
  }

  testWidgets('PasswordStrengthIndicator renders empty shrink when password is empty', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(''));

    // Should return a SizedBox.shrink() meaning nothing is rendered inside the scaffold body
    expect(find.byType(AnimatedSize), findsNothing);
  });

  testWidgets('PasswordStrengthIndicator renders text and requirements when password is provided', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('Abcd123!'));
    
    // Wait for animations to finish
    await tester.pumpAndSettle();

    expect(find.byType(AnimatedSize), findsOneWidget);
    
    // Check for the presence of the strength label (Strong)
    expect(find.text('Strong'), findsOneWidget);

    // Check that requirement texts are present
    expect(find.textContaining('At least 8 characters'), findsOneWidget);
    expect(find.textContaining('1 uppercase letter'), findsOneWidget);
    expect(find.textContaining('1 number'), findsOneWidget);
    expect(find.textContaining('1 special character'), findsOneWidget);
  });
}
