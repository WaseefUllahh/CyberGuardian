import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/profile/widgets/password_strength_widget.dart';

void main() {
  group('Password Strength Scoring', () {
    test('Empty password scores 0', () {
      expect(passwordStrengthScore(''), 0);
    });

    test('Short lowercase password scores 0', () {
      expect(passwordStrengthScore('abcd'), 0);
    });

    test('8+ characters but no other requirements scores 1', () {
      expect(passwordStrengthScore('abcdefgh'), 1);
      expect(passwordStrengthScore('longpassword'), 1);
    });

    test('Contains uppercase but short scores 1', () {
      expect(passwordStrengthScore('aBc'), 1);
    });

    test('Contains number but short scores 1', () {
      expect(passwordStrengthScore('a1b'), 1);
    });

    test('Contains special char but short scores 1', () {
      expect(passwordStrengthScore('a!b'), 1);
    });

    test('Length and uppercase scores 2', () {
      expect(passwordStrengthScore('Abcdefgh'), 2);
    });

    test('Length, uppercase, and number scores 3', () {
      expect(passwordStrengthScore('Abcdefg1'), 3);
    });

    test('Length, uppercase, number, and special character scores 4', () {
      expect(passwordStrengthScore('Abcdefg1!'), 4);
    });

    test('Very strong password scores 4', () {
      expect(passwordStrengthScore('SuperS3cr3tP@ssw0rd!'), 4);
    });
  });
}
