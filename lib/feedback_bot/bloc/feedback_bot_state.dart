import 'package:assignment_1/dashboard/models/MessageModel.dart';

abstract class FeedbackBotState {}

class FeedbackBotInitialState extends FeedbackBotState {}

class FeedbackBotLoadingState extends FeedbackBotState {}

class FeedbackBotLoadedState extends FeedbackBotState {
  final MessageModel message;

  FeedbackBotLoadedState({required this.message});
}