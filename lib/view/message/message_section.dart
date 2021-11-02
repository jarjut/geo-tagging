import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'message_provider.dart';
import 'widgets/message_chat.dart';
import 'widgets/message_input.dart';

class MessageSection extends StatelessWidget {
  const MessageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      builder: (context, _) {
        return Consumer<MessageProvider>(
          builder: (context, state, _) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: getValueForScreenType<double>(
                  context: context,
                  mobile: 12.0,
                  desktop: 24.0,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo-tbighut-17.png',
                    height: getValueForScreenType<double>(
                      context: context,
                      mobile: 64.0,
                      desktop: 140.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: state.isShowChat
                          ? const MessageChat()
                          : const MessageInput(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
