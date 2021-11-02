import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../message_provider.dart';
import 'message_form.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 8.0,
          desktop: 24.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Halo TBIGers! Apa harapan kalian bagi TBIG di umur ke-17 ini?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          const Expanded(
            child: MessageForm(),
          ),
          ResponsiveBuilder(builder: (context, size) {
            if (size.deviceScreenType == DeviceScreenType.desktop) {
              return const SizedBox(height: 8.0);
            }
            return const SizedBox.shrink();
          }),
          TextButton(
            onPressed: () => context.read<MessageProvider>().showChat(),
            child: const Text(
              'Lihat Harapan Mereka',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
