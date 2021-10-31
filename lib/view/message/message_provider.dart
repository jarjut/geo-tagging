import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  bool isShowChat = false;

  void showChat() {
    isShowChat = true;
    notifyListeners();
  }

  void showInput() {
    isShowChat = false;
    notifyListeners();
  }
}
