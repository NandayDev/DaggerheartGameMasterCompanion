import 'package:flutter/material.dart';

class DaggerheartButton extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const DaggerheartButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      color: theme.primaryColorLight,
      // textColor: Theme.of(context).primaryColorLight,
      onPressed: onPressed,
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
