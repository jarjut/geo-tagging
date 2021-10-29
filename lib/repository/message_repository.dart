import 'dart:developer';

import '../models/message.dart';

class MessageRepository {
  final _messageRef = Message.ref();

  Future<void> addMessage(Message message) async {
    try {
      await _messageRef.add(message);
    } catch (e) {
      log('Failed to add message', error: e);
    }
  }

  Stream<List<Message>> streamMessages() {
    return _messageRef
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
