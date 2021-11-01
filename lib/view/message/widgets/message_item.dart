import 'package:flutter/material.dart';

import '../../../models/message.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      child: Text(message.message),
    );
  }
}
