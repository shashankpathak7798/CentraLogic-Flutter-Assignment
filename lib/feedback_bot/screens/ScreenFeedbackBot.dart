import 'package:assignment_1/feedback_bot/bloc/feedback_bot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dashboard/models/MessageModel.dart';
import '../../utils/ThemeColors.dart';
import '../bloc/feedback_bot_bloc.dart';
import '../bloc/feedback_bot_event.dart';
import '../widgets/chat_item_widget.dart';

class ScreenFeedbackBot extends StatefulWidget {
  const ScreenFeedbackBot({super.key});

  @override
  State<ScreenFeedbackBot> createState() => _ScreenFeedbackBotState();
}

class _ScreenFeedbackBotState extends State<ScreenFeedbackBot> {
  dynamic mediaQuery;

  final TextEditingController _inputController = TextEditingController();

  final List<MessageModel> _messages = [
    MessageModel(prompt: "Hi Welcome to CentraLogic Feedback Agent! Thank you for your interest in CentraLogic!", isBot: true,),
  ];

  int step = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FeedbackBotBloc>(context).add(FeedbackBotInitialEvent(step: step,),);
  }



  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Function to build body
  _buildBody() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      /// Displaying the intro text and image of the bot
      _buildIntroWidget(),

      /// Padding
      const SizedBox(height: 24.0,),

      /// Displaying the chat between the user and the bot
      _buildChatWidget(),

    ],
  );

  _buildBottomNavigationBar() => SizedBox(
    height: 55.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.7,
          height: 40.0,
          child: TextField(
            /// set controller to get the value
            controller: _inputController,
            /// set decoration to add the prefixIcon and the hint text
            decoration: InputDecoration(
              hintText: 'Type a message',
              fillColor: ThemeColors.secondary100,
              filled: true,
              /// set hintStyle to adjust the spacing
              hintStyle: TextStyle(
                fontSize: 16.0,
                color: ThemeColors.secondary500,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
              /// set border to remove the underline
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              /// set contentPadding to adjust the spacing
              contentPadding: const EdgeInsets.all(10.0),
              /// set prefixIcon to add the attachment icon
              prefixIcon: Image.asset("assets/attachment.png"),
            ),
          ),
        ),

        /// Padding
        const SizedBox(width: 8.0,),

        /// set IconButton to add the send icon
        ElevatedButton(onPressed: _messages.contains(MessageModel(prompt: "Thank you for your feedback!", isBot: true,)) ? null : () {
          /// add the event to the bloc
          step++;
          BlocProvider.of<FeedbackBotBloc>(context).add(FeedbackBotNextEvent(step: step,));
          /// add the message to the list
          _messages.add(MessageModel(prompt: _inputController.text, isBot: false,));

          /// clear the input
          _inputController.clear();
        }, style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primary500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ), child: const Text('Send', style: TextStyle(color: Colors.white,),),),

      ],
    ),
  );

  /// Function to build the Widget to display the chat between the user and the bot
  _buildChatWidget() => SizedBox(
    width: mediaQuery.size.width * 0.6,
    height: mediaQuery.size.height * 0.578,
    child: Column(
      children: [
        Text(
          'Today',
          style: TextStyle(
            fontSize: 16.0,
            backgroundColor: ThemeColors.secondary100,
            color: ThemeColors.secondary500,
            height: 1.5,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
          ),
        ),

        /// Padding
        const SizedBox(height: 10.0,),

        /// Expanded to make the ListView scrollable
        SizedBox(
          height: mediaQuery.size.height * 0.5,
          child: BlocBuilder<FeedbackBotBloc, FeedbackBotState>(
            builder: (context, state) {

              if(state is FeedbackBotLoadedState) {
                _messages.add(state.message);

                return ListView.separated(
                  itemCount: _messages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10.0,),
                  itemBuilder: (context, index) => ChatItemWidget(message: _messages[index],),
                );
              }

              return ListView.separated(
                itemCount: _messages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10.0,),
                itemBuilder: (context, index) => ChatItemWidget(message: _messages[index],),
              );
            }
          ),
        ),
      ],
    ),
  );

  /// Function to build the intro text and image of the bot
  _buildIntroWidget() => SizedBox(
    width: double.infinity / 2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Displaying the logo of the chatBot
        buildBotLogo(),
        /// Padding
        const SizedBox(height: 12.0,),
        /// Displaying the intro text
        _buildTextWidget(text: 'CentraLogic Bot', fontWeight: FontWeight.w600, fontSize: 24.0, color: ThemeColors.secondary500,),
        /// Displaying the intro text
        _buildTextWidget(text: 'Hi! I am CentraLogic Bot, your onboarding agent', fontWeight: FontWeight.w400, fontSize: 24.0, color: ThemeColors.secondary500,),

        /// Padding
        const SizedBox(height: 16.0,),
        /// Divider
        Divider(
          indent: mediaQuery.size.width / 4,
          endIndent: mediaQuery.size.width / 4,
          height: 1.0,
          color: Colors.grey,
        ),

      ],
    ),
  );

  /// App Bar
  _buildAppBar() => AppBar(
    /// set automaticallyImplyLeading to false to remove back button
    automaticallyImplyLeading: false,
    /// ListTile to display title and subtitle
    title: ListTile(
      /// set contentPadding to adjust the spacing
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0,),
      /// title and subtitle
      title: _buildTextWidget(text: 'Welcome to CentraLogic', fontWeight: FontWeight.w600, fontSize: 24.0, color: ThemeColors.secondary500,),
      subtitle: _buildTextWidget(text: 'Hi Charles!', fontWeight: FontWeight.w400, fontSize: 16.0, color: ThemeColors.secondary500,),
    ),
  );

  /// common text widget
  _buildTextWidget({required String text, required double fontSize, required Color color, required FontWeight fontWeight,}) => Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: ThemeColors.secondary500,
      fontFamily: 'Roboto',
      fontWeight: fontWeight,
    ),
  );

  /// Function to build the Widget to display the bot's logo
  buildBotLogo() => Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(32.0),
      image: const DecorationImage(
        image: NetworkImage('https://s3-alpha-sig.figma.com/img/1265/0d52/4f9aab712102d859514da6baad9acefa?Expires=1704067200&Signature=JSGcEXY8tCZNcCFDO6b3phgYvRXxEvwagc5G1RxyX4P6w~EDAuzQJ1BnHNyaQPtx5mt5vWbW9Gp7r-~pLwqkHfmrfLzSe1ekUamdTmvkpx~Kg7gjsFl0uJ9HtjS2b765r1G8mhyUeTYyqG7YzzHb5TD4HOXY-1~086Mgp4Oyv2EGWZYJb487qF9wMv9DIweYOCoSKL8MqmLaI1zHKP2KrXr8qgXTSd6FpwKPmHH0in~CRkunWzONl8bqQ7bwufCRBSEQZB7Vj7ZjM8Ftmxl-SQHQKSaWNHOgZxMvj327uMP2KBktDOjwMlR0~~xkoYdXuTqsR8erp-kgi-HVz0wTfg__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
