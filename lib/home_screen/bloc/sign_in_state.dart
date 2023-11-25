import 'package:flutter/material.dart';

abstract class SignInState {}

/// class to handle initial state
class SignInInitialState extends SignInState {}

//class SignInInvalidState extends SignInState {}

/// class to handle valid state
class SignInValidState extends SignInState {

  SignInValidState() {
    debugPrint("SignInValidState");
  }

}

/// class to handle error state
class SignInErrorState extends SignInState {
  final String errorMessage;

  SignInErrorState({required this.errorMessage});
}

/// class to handle loading state
class SignInLoadingState extends SignInState {}

/// class to handle email valid state
class SignInEmailValidState extends SignInState {}

/// class to handle phone number valid state
class SignInPhoneNumberValidState extends SignInState {}