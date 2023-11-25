import 'package:assignment_1/dashboard/bloc/add_user/add_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_user_event.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  AddUserBloc() : super(AddUserInitialState()) {

    /// handler for email id changed event
    on<UserEmailIdChangedEvent>((event, emit) {
      /// check if email id is empty or not or is valid or not
      if (event.emailId == "" ||
          event.emailId.contains("@gmail.com") == false) {
        emit(
          AddUserErrorState(
            errorMessage: "Please enter a valid email id",
          ),
        );
      } else {
        /// if email id is valid then emit SignInValidState
        emit(AddUserErrorState(errorMessage: ""));
        emit(AddUserValidState());
      }
    });

    /// handler for phone number changed event
    on<UserPhoneNumberChangedEvent>((event, emit) {
      /// check if phone number is empty or not or is valid or not
      if (event.phoneNumber == "" || event.phoneNumber.length != 10) {
        emit(
          AddUserErrorState(
            errorMessage: "Please enter valid phone number",
          ),
        );
      } else {
        /// if phone number is valid then emit SignInValidState
        emit(AddUserErrorState(errorMessage: ""));
        emit(AddUserValidState());
      }
    });
  }
}