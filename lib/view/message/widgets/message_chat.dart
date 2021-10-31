import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_tagging/view/bloc/message_bloc.dart';
import 'package:geo_tagging/view/message/message_provider.dart';
import 'package:geo_tagging/view/message/widgets/message_item.dart';
import 'package:provider/provider.dart';
import 'package:geo_tagging/models/message.dart';

class MessageChat extends StatelessWidget {
  const MessageChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.read<MessageProvider>().showInput(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) => MessageItem(
                message: state.messages[index],
              ),
              itemCount: state.messages.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
