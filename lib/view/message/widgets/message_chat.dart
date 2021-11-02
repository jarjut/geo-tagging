import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/message_bloc.dart';
import '../message_provider.dart';
import 'message_item.dart';

class MessageChat extends StatelessWidget {
  const MessageChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoaded) {
                return ListView.builder(
                  itemBuilder: (context, index) => MessageItem(
                    message: state.messages[index],
                  ),
                  reverse: true,
                  itemCount: state.messages.length,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        const SizedBox(height: 4.0),
        TextButton(
          onPressed: () => context.read<MessageProvider>().showInput(),
          child: const Text(
            'Kembali',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
