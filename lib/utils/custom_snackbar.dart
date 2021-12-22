import 'package:flutter/material.dart';

enum SnackbarType { success, warning, error }

class CustomSnackbar {
  static showSnackbar(BuildContext context, String message, SnackbarType type,
      {SnackBarAction? snackBarAction}) {
    final snackBar = SnackBar(
      action: snackBarAction,
      backgroundColor: type == SnackbarType.success
          ? Colors.green.shade600
          : type == SnackbarType.warning
              ? Colors.orange.shade700
              : Colors.red.shade700,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
              type == SnackbarType.success
                  ? Icons.check_circle
                  : type == SnackbarType.warning
                      ? Icons.info
                      : Icons.error,
              color: Colors.white),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child:
                  Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      // action: SnackBarAction(
      //   label: 'Oke',
      //   onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      // ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
