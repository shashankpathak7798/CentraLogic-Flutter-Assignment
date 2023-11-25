// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:assignment_1/home_screen/bloc/sign_in_bloc.dart';
import 'package:assignment_1/home_screen/bloc/sign_in_state.dart';
import 'package:assignment_1/home_screen/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_1/main.dart';

void main() {
  testWidgets('FormWidget should validate phone number and email', (WidgetTester tester) async {

    final signInBloc = SignInBloc();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: signInBloc, child: FormWidget(),),
      ),
    );

    /// Finding the text fields through the hint text
    final phoneNumberField = find.widgetWithText(TextField, "Enter Phone No.");
    final emailField = find.widgetWithText(TextField, "Enter Email Id");


    /// Entering the invalid values in the text fields
    await tester.enterText(phoneNumberField, "12345");
    await tester.enterText(emailField, "invalid_email");

    /// Trigger the form validation
    await tester.tap(find.text("Send OTP"));

    /// Rebuild the widget after the frame changes
    await tester.pump();

    // Verify that the Bloc state is not updated with invalid values
    expect(BlocProvider.of<SignInBloc>(tester.element(find.byType(FormWidget))).state,
        isNot(SignInValidState));

    // Enter valid values in the fields
    await tester.enterText(phoneNumberField, '9876543210');
    await tester.enterText(emailField, 'valid_email@example.com');

    // Trigger the form submission button
    await tester.tap(find.text('Send OTP'));

    // Rebuild the widget after the frame changes
    await tester.pump();

    // Verify that the Bloc state is updated with valid values
    expect(BlocProvider.of<SignInBloc>(tester.element(find.byType(FormWidget))).state,
        isNot(SignInErrorState));

  });
}
