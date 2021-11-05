import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
  final _nameController = TextEditingController();
  bool _isLoading = false;
  int _textLength = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _messageController.addListener(
        () => setState(() => _textLength = _messageController.text.length));
    void _onSubmit() async {
      if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);
        final message = _messageController.text.trim();
        final name = _nameController.text.trim();
        LocationData? location;
        try {
          location = await Location().getLocation();
        } catch (e) {
          location = null;
        }

        await context.read<MessageRepository>().addMessage(
              Message(
                name: name == '' ? null : name,
                message: message,
                latitude: location?.latitude ?? 0,
                longitude: location?.longitude ?? 0,
              ),
            );

        setState(() => _isLoading = false);

        context.read<MessageProvider>().submit();
      }
    }

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.75,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null || value.trim() == '') {
                          return "Tulis Harapan Kamu";
                        }
                        return null;
                      },
                      maxLines: null,
                      maxLength: 160,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_textLength.toString()}/160',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ScreenTypeLayout(
            mobile: const SizedBox(height: 8.0),
            desktop: const SizedBox(height: 16.0),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.75,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                counterText: '',
                hintText: 'Tulis nama kamu',
              ),
              maxLength: 20,
            ),
          ),
          ScreenTypeLayout(
            mobile: const SizedBox(height: 8.0),
            desktop: const SizedBox(height: 16.0),
          ),
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
