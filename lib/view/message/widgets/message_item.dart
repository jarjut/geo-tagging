import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../models/message.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Color(0xfff1faff),
          boxShadow: [
            BoxShadow(
              color: Color(0xff679ab8),
              offset: Offset(1, 1),
              blurRadius: 0.5,
              spreadRadius: 0.25,
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          message.message,
          style: TextStyle(
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 14.0,
              desktop: 16.0,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
