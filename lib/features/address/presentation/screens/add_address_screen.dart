import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/presentation/providers/address_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  final AddressEntity? address;

  const AddAddressScreen({
    super.key,
    this.address,
  });

  bool get isEdit => address != null;

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController divisionController;
  late final TextEditingController districtController;
  late final TextEditingController upazilaController;
  late final TextEditingController areaController;
  late final TextEditingController addressController;
  late final TextEditingController postalCodeController;

  String label = "Home";
  bool isDefault = false;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    fullNameController =
        TextEditingController(text: address?.fullName ?? "");

    phoneController =
        TextEditingController(text: address?.phone ?? "");

    divisionController =
        TextEditingController(text: address?.division ?? "");

    districtController =
        TextEditingController(text: address?.district ?? "");

    upazilaController =
        TextEditingController(text: address?.upazila ?? "");

    areaController =
        TextEditingController(text: address?.area ?? "");

    addressController =
        TextEditingController(text: address?.addressLine ?? "");

    postalCodeController =
        TextEditingController(text: address?.postalCode ?? "");

    label = address?.label ?? "Home";
    isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    divisionController.dispose();
    districtController.dispose();
    upazilaController.dispose();
    areaController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(addressProvider.notifier);

    if (widget.isEdit) {
      await notifier.updateAddress(
        addressId: widget.address!.id,
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        division: divisionController.text.trim(),
        district: districtController.text.trim(),
        upazila: upazilaController.text.trim(),
        area: areaController.text.trim(),
        addressLine: addressController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        label: label,
        isDefault: isDefault,
      );
    } else {
      await notifier.createAddress(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        division: divisionController.text.trim(),
        district: districtController.text.trim(),
        upazila: upazilaController.text.trim(),
        area: areaController.text.trim(),
        addressLine: addressController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        label: label,
        isDefault: isDefault,
      );
    }

    final state = ref.read(addressProvider);

    if (state.error == null) {
      ref.read(addressListProvider.notifier).loadAddresses();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Address" : "Add Address"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(
              controller: fullNameController,
              label: "Full Name",
            ),
            _field(
              controller: phoneController,
              label: "Phone",
            ),
            _field(
              controller: divisionController,
              label: "Division",
            ),
            _field(
              controller: districtController,
              label: "District",
            ),
            _field(
              controller: upazilaController,
              label: "Upazila",
            ),
            _field(
              controller: areaController,
              label: "Area",
            ),
            _field(
              controller: addressController,
              label: "Address",
              maxLines: 3,
            ),
            _field(
              controller: postalCodeController,
              label: "Postal Code",
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: label,
              decoration: const InputDecoration(
                labelText: "Label",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Home",
                  child: Text("Home"),
                ),
                DropdownMenuItem(
                  value: "Office",
                  child: Text("Office"),
                ),
                DropdownMenuItem(
                  value: "Other",
                  child: Text("Other"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  label = value!;
                });
              },
            ),
            SwitchListTile(
              value: isDefault,
              title: const Text("Set as default"),
              onChanged: (value) {
                setState(() {
                  isDefault = value;
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isLoading ? null : _submit,
              child: state.isLoading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : Text(
                widget.isEdit
                    ? "Update Address"
                    : "Save Address",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}