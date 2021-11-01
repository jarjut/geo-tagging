import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: state.isShowChat
                    ? const MessageChat()
                    : const MessageInput(),
              ),
            );
          },
        );
      },
    );
  }
}
