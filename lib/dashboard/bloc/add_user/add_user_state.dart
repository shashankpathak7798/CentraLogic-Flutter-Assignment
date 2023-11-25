abstract class AddUserState {}

/// class to handle initial state
class AddUserInitialState extends AddUserState {}

/// class to handle valid state
class AddUserValidState extends AddUserState {}

/// class to handle error state
class AddUserErrorState extends AddUserState {
  final String errorMessage;

  AddUserErrorState({required this.errorMessage});
}

/// class to handle loading state
class AddUserLoadingState extends AddUserState {}