import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/presentation/providers/address_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(addressListProvider.notifier).loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // TODO:
          context.pushNamed(AppRoutesName.addAddress);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(addressListProvider.notifier).refresh();
        },
        child: Builder(
          builder: (_) {
            if (state.isLoading && state.addresses.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.error != null && state.addresses.isEmpty) {
              return Center(
                child: Text(state.error!),
              );
            }

            if (state.addresses.isEmpty) {
              return const Center(
                child: Text("No Address Found"),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                return _AddressCard(
                  address: state.addresses[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  final AddressEntity address;

  const _AddressCard({
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    address.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                if (address.isDefault)
                  const Chip(
                    label: Text("DEFAULT"),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(address.phone),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                [
                  address.addressLine,
                  address.area,
                  address.upazila,
                  address.district,
                  address.division,
                  address.postalCode,
                ].where((e) => e != null && e.isNotEmpty).join(", "),
              ),
            ),

            const Divider(height: 24),

            Row(
              children: [

                TextButton.icon(
                  onPressed: () {
                    context.pushNamed(AppRoutesName.addAddress,extra: address);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),

                const Spacer(),

                if (!address.isDefault)
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(addressProvider.notifier)
                          .setDefaultAddress(address.id);

                      ref
                          .read(addressListProvider.notifier)
                          .loadAddresses();
                    },
                    child: const Text("Set Default"),
                  ),

                IconButton(
                  onPressed: () async {

                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Delete Address"),
                          content: const Text(
                            "Are you sure?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancel"),
                            ),
                            FilledButton(
                              onPressed: () {
                                ref.read(addressProvider.notifier).deleteAddress(address.id);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await ref
                          .read(addressProvider.notifier)
                          .deleteAddress(address.id);

                      ref
                          .read(addressListProvider.notifier)
                          .loadAddresses();
                    }
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}