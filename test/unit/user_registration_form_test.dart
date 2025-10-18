import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('FormValidators Unit Tests', () {
    group('Email Validation', () {
      test('isValidEmail returns true for valid email', () {
        expect(FormValidators.isValidEmail('test@example.com'), true);
        expect(FormValidators.isValidEmail('user.name@domain.co.uk'), true);
        expect(FormValidators.isValidEmail('user+tag@example.com'), true);
      });

      test('isValidEmail returns false for invalid email', () {
        expect(FormValidators.isValidEmail('invalid-email'), false);
        expect(FormValidators.isValidEmail('@example.com'), false);
        expect(FormValidators.isValidEmail('user@'), false);
        expect(FormValidators.isValidEmail('user@domain'), false);
        expect(FormValidators.isValidEmail(''), false);
      });
    });

    group('Password Validation', () {
      test('isValidPassword returns true for strong password', () {
        // يجب أن يحتوي على: حرف كبير، حرف صغير، رقم، رمز خاص، 8 أحرف على الأقل
        expect(FormValidators.isValidPassword('Test@1234'), true);
        expect(FormValidators.isValidPassword('SecurePass1!'), true);
        expect(FormValidators.isValidPassword('MyP@ssw0rd'), true);
      });

      test('isValidPassword returns false for weak password', () {
        expect(FormValidators.isValidPassword('short'), false); // قصير جداً
        expect(
          FormValidators.isValidPassword('NoSpecialChar1'),
          false,
        ); // لا يحتوي رمز خاص
        expect(
          FormValidators.isValidPassword('noupppercase1!'),
          false,
        ); // لا يحتوي حرف كبير
        expect(
          FormValidators.isValidPassword('NOLOWERCASE1!'),
          false,
        ); // لا يحتوي حرف صغير
        expect(
          FormValidators.isValidPassword('NoNumbers!'),
          false,
        ); // لا يحتوي أرقام
        expect(FormValidators.isValidPassword(''), false); // فارغ
      });
    });
  });
}
