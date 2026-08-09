import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/presentation/providers/flash_sale_providers.dart';
import 'package:ebazarx/features/flash_sale/presentation/widgets/flash_sale_horizontal_list_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashSaleHorizontalListView extends ConsumerStatefulWidget {
  const FlashSaleHorizontalListView({super.key,this.flashSales});
  final List<FlashSale>? flashSales;
  @override
  ConsumerState<FlashSaleHorizontalListView> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends ConsumerState<FlashSaleHorizontalListView> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   ref.read(flashSaleListNotifierProvider.notifier).fetchFlashSales();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashSaleListNotifierProvider);

    if (state.isLoading) {
      return const FlashSaleHorizontalListShimmer();
    }

    if (state.failure != null) {
      return SizedBox(
        height: 220,
        child: Center(
          child: TextButton(
            onPressed: () {
              ref
                  .read(flashSaleListNotifierProvider.notifier)
                  .fetchFlashSales();
            },
            child: const Text("Retry"),
          ),
        ),
      );
    }

    if (state.flashSales.isEmpty && widget.flashSales == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              "Flash Sales",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text("See All"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 185,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.flashSales != null ? widget.flashSales!.length : state.flashSales.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final sale = widget.flashSales != null ? widget.flashSales![index] : state.flashSales[index];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // TODO
                },
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: Colors.orange.shade700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          sale.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sale.description ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${sale.products.length} Products",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 1,
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}