import 'package:flutter/material.dart';

class KeypadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Widget? iconImage;
  final VoidCallback onPressed;

  const KeypadButton(
      {super.key,
      this.text,
      this.icon,
      required this.onPressed,
      this.iconImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onPressed,
      child: Center(
          child: text != null
              ? Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              : iconImage),
    );
  }
}
