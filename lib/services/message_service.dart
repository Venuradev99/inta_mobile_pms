import 'package:flutter/material.dart';

class MessageService {
  MessageService._privateConstructor();
  static final MessageService _instance = MessageService._privateConstructor();

  bool _isUnauthorizedBeingHandled = false;
  factory MessageService() => _instance;

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void success(String message, {String? title}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${title ?? 'Success'}: $message',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }

  void error(String message, {String? title}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${title ?? 'Error'}: $message',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }

  void unauthorizedError(
    String message, {
    String? title,
    bool isUnauthorized = false,
  }) {
    if (isUnauthorized) {
      if (_isUnauthorizedBeingHandled) return;
      _isUnauthorizedBeingHandled = true;
    }
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${title ?? 'Error'}: $message',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
    );

    messengerKey.currentState?.showSnackBar(snackBar).closed.then((_) {
      if (isUnauthorized) _isUnauthorizedBeingHandled = false;
    });
  }
}
