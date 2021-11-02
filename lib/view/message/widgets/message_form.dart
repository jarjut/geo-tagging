import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import '../../../models/message.dart';
import '../../../repository/message_repository.dart';
import '../message_provider.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({Key? key}) : super(key: key);

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onSubmit() async {
      if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);
        final location = await Location().getLocation();
        final message = _messageController.text.trim();

        await context.read<MessageRepository>().addMessage(
              Message(
                message: message,
                latitude: location.latitude!,
                longitude: location.longitude!,
              ),
            );

        setState(() => _isLoading = true);

        context.read<MessageProvider>().showChat();
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.75,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                ),
                validator: (value) {
                  if (value == null || value.trim() == '') {
                    return "Tulis Harapan Kamu";
                  }
                  return null;
                },
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 32.0,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return const Color(0xff173a90);
                }),
              ),
              onPressed: _isLoading ? null : _onSubmit,
              child: const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}
