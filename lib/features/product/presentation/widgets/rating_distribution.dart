import 'package:flutter/material.dart';

class RatingDistribution extends StatelessWidget {
  final Map<int, int> distribution;

  const RatingDistribution({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold(0, (sum, value) => sum + value);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: List.generate(5, (index) {
        final star = 5 - index;
        final count = distribution[star] ?? 0;
        final percentage = count / total;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '$star',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 30,
                child: Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}