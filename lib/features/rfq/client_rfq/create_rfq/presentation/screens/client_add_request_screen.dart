import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickdeal/common/widget/custom_appbar.dart';
import 'dart:io';

import '../../../../../../core/utils/constants/color_palette.dart';
import '../../domain/entities/category.dart';
import '../controllers/rfq_controller.dart';

class ClientAddRequestScreen extends StatefulWidget {
  const ClientAddRequestScreen({super.key});

  @override
  State<ClientAddRequestScreen> createState() => _ClientAddRequestScreenState();
}

class _ClientAddRequestScreenState extends State<ClientAddRequestScreen> {
  final controller = RfqFormController();
  final _formKey = GlobalKey<FormState>();

  DateTime? biddingDeadline;
  DateTime? deliveryDeadline;
  List<String> selectedCategories = [];
  List<Map<String, String>> specifications = [];
  final categories = Category.values.map((e) => e.name).toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLabel('Product Title'),
            TextFormField(
              controller: controller.title,
              decoration: const InputDecoration(hintText: 'Enter product title'),
              maxLength: 100,
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            _buildLabel('Select Category (Multiple Allowed)'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = selectedCategories.contains(category);
                return FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.primaryAccent,
                    ),
                  ),
                  selected: isSelected,
                  checkmarkColor: Colors.white,
                  backgroundColor: AppColors.primaryAccent.withAlpha(25),
                  selectedColor: AppColors.primaryAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryAccent
                          : AppColors.primaryAccent.withAlpha(125),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            _buildLabel('Estimated Budget and Quantity'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.budget,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.grey),
                          hintText: 'Estd. Budget',
                          hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          final amount = int.tryParse(value);
                          if (amount == null) return 'Invalid number';
                          if (amount > 1000000) return 'Max budget is ১০,০০,০০০৳';
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Max budget: ১০,০০,০০০৳',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _buildQuantityField(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildLabel('Delivery Location'),
            _buildLocationField(),
            const SizedBox(height: 16),

            _buildLabel('Bidding Deadline'),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => biddingDeadline = date);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Select Bidding Deadline',
                    hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                  controller: TextEditingController(
                    text: biddingDeadline != null
                        ? "${biddingDeadline!.day}/${biddingDeadline!.month}/${biddingDeadline!.year}"
                        : '',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildLabel('Delivery Deadline'),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => deliveryDeadline = date);
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Select Delivery Deadline',
                    hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                  controller: TextEditingController(
                    text: deliveryDeadline != null
                        ? "${deliveryDeadline!.day}/${deliveryDeadline!.month}/${deliveryDeadline!.year}"
                        : '',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildLabel('Specifications'),
            ...specifications.map((spec) {
              final keyController = TextEditingController(text: spec['key']);
              final valueController = TextEditingController(text: spec['value']);
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: keyController,
                      decoration: const InputDecoration(
                          hintText: 'Specification Name',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey)),
                      onChanged: (value) => spec['key'] = value,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: valueController,
                      decoration: const InputDecoration(
                          hintText: 'Specification Value',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey)),
                      onChanged: (value) => spec['value'] = value,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => specifications.remove(spec));
                    },
                  ),
                ],
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  specifications.add({'key': '', 'value': ''});
                });
              },
              icon: const Icon(Icons.add, color: AppColors.primaryAccent),
              label: const Text('Add Specification', style: TextStyle(color: AppColors.primaryAccent)),
            ),
            const SizedBox(height: 16),

            _buildLabel('Product Description'),
            TextFormField(
              controller: controller.description,
              maxLines: 5,
              maxLength: 250,
              decoration: const InputDecoration(
                hintText: 'Describe your product requirements within 250 characters...',
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
/*
            _buildLabel('Attachments'),
            controller.attachmentPicker(
              context,
              isImage: true,
              files: controller.productImages,
              onPick: () => controller.pickImages().then((_) => setState(() {})),
              onRemove: (i) => setState(() => controller.productImages.removeAt(i)),
            ),
            const SizedBox(height: 16),

 */

            ElevatedButton(
              onPressed: controller.isSubmitting
                  ? null
                  : () async {

                if (!_formKey.currentState!.validate()) return;

                if (biddingDeadline == null || deliveryDeadline == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select both deadlines.')),
                  );
                  setState(() => controller.isSubmitting = false);
                  return;
                }

                setState(() {
                  controller.isSubmitting = true;
                  controller.biddingDeadline = biddingDeadline;
                  controller.deliveryDeadline = deliveryDeadline;
                  controller.selectedCategories = selectedCategories;
                  controller.specification = specifications;
                });
                
                await controller.submitForm(context);

                if (mounted) {
                  setState(() {
                    controller.isSubmitting = false;
                  });
                }
              },
              child: controller.isSubmitting
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : const Text('Request for Quote'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600,
          fontSize: 14)),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: controller.location,
      decoration: InputDecoration(
        hintText: 'Enter location',
        hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
        prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: controller.quantity,
      decoration: InputDecoration(
        hintText: 'Enter quantity',
        hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
        prefixIcon: const Icon(Icons.production_quantity_limits_rounded, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 11),
      maxLength: 5,
    );
  }
}
