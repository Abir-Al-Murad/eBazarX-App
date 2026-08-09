import 'package:flutter/material.dart';
import 'loading_state.dart';

class LoadingContainer extends StatelessWidget {
  final String? message;
  final double animationSize;

  const LoadingContainer({
    super.key,
    this.message,
    this.animationSize = 90,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoadingAnimation(size: animationSize),

          if (message != null) ...[
            const SizedBox(height: 10),
            Text(
              message!,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}