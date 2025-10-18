import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    // Helper function لإنشاء الـ widget في بيئة اختبار
    Widget createTestWidget() {
      return const MaterialApp(home: Scaffold(body: UserRegistrationForm()));
    }

    testWidgets('Form renders all fields correctly', (
      WidgetTester tester,
    ) async {
      // Build the widget
      await tester.pumpWidget(createTestWidget());

      // التحقق من وجود جميع الحقول
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Shows error when submitting empty form', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // اضغط على زر Register بدون ملء البيانات
      await tester.tap(find.text('Register'));
      await tester.pump(); // تحديث الواجهة

      // التحقق من ظهور رسائل الخطأ
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Shows error for short name', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // أدخل اسم قصير (حرف واحد)
      final nameField = find.widgetWithText(TextFormField, 'Full Name');
      await tester.enterText(nameField, 'A');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('Shows error for invalid email format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'invalid-email');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Shows error for weak password', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final passwordField = find.widgetWithText(TextFormField, 'Password');
      await tester.enterText(passwordField, 'weak');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('Shows error when passwords do not match', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // أدخل كلمتي مرور مختلفتين
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final confirmPasswordField = find.widgetWithText(
        TextFormField,
        'Confirm Password',
      );

      await tester.enterText(passwordField, 'Test@1234');
      await tester.enterText(confirmPasswordField, 'Different@1234');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Successfully submits form with valid data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // املأ جميع الحقول ببيانات صحيحة
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Ahmed Mohamed',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'ahmed@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Test@1234',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Test@1234',
      );

      // اضغط على زر Register
      await tester.tap(find.text('Register'));
      await tester.pump(); // ابدأ الـ animation

      // التحقق من ظهور الـ loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // انتظر حتى ينتهي الـ API call (2 ثانية)
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(); // تحديث نهائي

      // التحقق من ظهور رسالة النجاح
      expect(find.text('Registration successful!'), findsOneWidget);
    });

    testWidgets('Button is disabled during loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // املأ البيانات
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Ahmed Mohamed',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'ahmed@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Test@1234',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Test@1234',
      );

      // اضغط على الزر
      await tester.tap(find.text('Register'));
      await tester.pump();

      // تحقق من أن الزر معطل (onPressed = null)
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);

      // انتظر حتى ينتهي الـ timer
      await tester.pumpAndSettle();
    });
  });
}
