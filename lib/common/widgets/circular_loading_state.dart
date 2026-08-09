import 'package:flutter/material.dart';

class CircularLoadingState extends StatelessWidget {
  const CircularLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ));
  }
}
