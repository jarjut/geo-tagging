import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  bool isShowChat = false;
  bool alreadySubmitted = false;

  void showChat() {
    isShowChat = true;
    notifyListeners();
  }

  void showInput() {
    isShowChat = false;
    notifyListeners();
  }

  void submit() {
    isShowChat = true;
    alreadySubmitted = true;
    notifyListeners();
  }
}
