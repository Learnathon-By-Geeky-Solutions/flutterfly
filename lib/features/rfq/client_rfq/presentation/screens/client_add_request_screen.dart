import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../common/widget/custom_appbar.dart';
import '../controllers/rfq_controller.dart';

class ClientAddRequestScreen extends StatefulWidget {
  const ClientAddRequestScreen({super.key});

  @override
  State<ClientAddRequestScreen> createState() => _ClientAddRequestScreenState();
}

class _ClientAddRequestScreenState extends State<ClientAddRequestScreen> {
  final controller = RfqFormController();

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
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Product Title',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            TextFormField(
              controller: controller.title,
              decoration: const InputDecoration(hintText: 'Enter product title'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a product title' : null,
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Category',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              value: controller.selectedCategory,
              items: controller.categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => controller.selectedCategory = val),
              decoration: const InputDecoration(hintText: 'Select category'),
              validator: (val) => val == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Budget Range',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.budgetMin,
                    decoration: const InputDecoration(prefixText: '\$ ', hintText: 'Min'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: controller.budgetMax,
                    decoration: const InputDecoration(prefixText: '\$ ', hintText: 'Max'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      final min = int.tryParse(controller.budgetMin.text) ?? 0;
                      final max = int.tryParse(val) ?? 0;
                      return max < min ? 'Max must be >= Min' : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Bidding Deadline',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            controller.dateTile(
              context,
              controller.biddingDeadline,
                  () => controller.pickBiddingDeadline(context).then((_) => setState(() {})),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Delivery Deadline',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            controller.dateTile(
              context,
              controller.deliveryDeadline,
                  () => controller.pickDeliveryDeadline(context).then((_) => setState(() {})),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Requirements',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            TextFormField(
              controller: controller.requirements,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Describe your product requirements...'),
              validator: (val) => val == null || val.isEmpty ? 'Please enter requirements' : null,
            ),
            const SizedBox(height: 16),
            /*
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Attachments',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            controller.attachmentPicker(
              context,
              isImage: true,
              files: controller.productImages,
              onPick: () => controller.pickImages().then((_) => setState(() {})),
              onRemove: (i) => setState(() => controller.productImages.removeAt(i)),
            ),
            const SizedBox(height: 16),

            controller.attachmentPicker(
              context,
              isImage: false,
              files: controller.documents,
              onPick: () => controller.pickDocuments().then((_) => setState(() {})),
              onRemove: (i) => setState(() => controller.documents.removeAt(i)),
            ),
            const SizedBox(height: 24),
             */

            ElevatedButton(
              onPressed: controller.isSubmitting
                  ? null
                  : () async {
                setState(() => controller.isSubmitting = true);
                await controller.submitForm(context);
                if (mounted) setState(() => controller.isSubmitting = false);
              },
              child: controller.isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text('Request for Quote'),
            ),
          ],
        ),
      ),
    );
  }
}
