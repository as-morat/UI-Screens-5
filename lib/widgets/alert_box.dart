import 'package:flutter/material.dart';

Future<void> showAlert(
    BuildContext context, {
      required String message,
      bool success = true,
    }) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              success ? "assets/images/success.png" : "assets/images/error.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            success ? "Success" : "Error",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: success ? Colors.green.shade400 : Colors.red.shade400,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}
