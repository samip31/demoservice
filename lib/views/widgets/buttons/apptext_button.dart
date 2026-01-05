import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String name;

  final VoidCallback onPressed;

  const AppTextButton({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onPressed.call();
        },
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ));
  }
}
