import 'dart:developer';

import '../models/message.dart';

class MessageRepository {
  final _messageRef = Message.ref();

  Future<void> addMessage(Message message) async {
    try {
      final newMessageRef = _messageRef.doc();
      final id = newMessageRef.id;
      newMessageRef.set(message.copyWith(id: id));
    } catch (e) {
      log('Failed to add message', error: e);
    }
  }

  Stream<List<Message>> streamMessages() {
    return _messageRef
        .orderBy('created', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
