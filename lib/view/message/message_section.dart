import 'package:flutter/material.dart';
import 'package:geo_tagging/view/message/message_provider.dart';
import 'package:geo_tagging/view/message/widgets/message_chat.dart';
import 'package:geo_tagging/view/message/widgets/message_input.dart';
import 'package:provider/provider.dart';

class MessageSection extends StatelessWidget {
  const MessageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      builder: (context, _) {
        return Consumer<MessageProvider>(
          builder: (context, state, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child:
                  state.isShowChat ? const MessageChat() : const MessageInput(),
            );
          },
        );
      },
    );
  }
}
