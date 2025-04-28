import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ClientAddRequestScreen extends StatefulWidget {
  const ClientAddRequestScreen({super.key});

  @override
  State<ClientAddRequestScreen> createState() => _ClientAddRequestScreenState();
}

class _ClientAddRequestScreenState extends State<ClientAddRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController minBudgetController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? biddingDeadline;
  DateTime? deliveryDeadline;

  List<String> allCategories = ['Category A', 'Category B', 'Category C'];
  List<String> selectedCategories = [];

  List<Map<String, String>> specifications = [];

  List<File> uploadedPDFs = [];
  List<File> uploadedImages = [];
  bool isUploadingPDF = false;
  bool isUploadingImage = false;

  @override
  void dispose() {
    titleController.dispose();
    minBudgetController.dispose();
    locationController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPDFs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        isUploadingPDF = true;
      });
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload
      setState(() {
        uploadedPDFs.add(File(result.files.single.path!));
        isUploadingPDF = false;
      });
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isUploadingImage = true;
      });
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload
      setState(() {
        uploadedImages.add(File(image.path));
        isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Request')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLabel('Product Title'),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter product title'),
              maxLength: 100,  // Set character limit
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            _buildLabel('Category (Multiple)'),
            Wrap(
              spacing: 8,
              children: allCategories.map((category) {
                final isSelected = selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
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

            _buildLabel('Budget Range and Quantity'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: minBudgetController,
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      hintText: 'Min Budget',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,  // Limit characters for budget
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuantityField(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildLabel('Location (Optional)'),
            _buildLocationField(),
            const SizedBox(height: 16),

            _buildLabel('Bidding Deadline'),
            ListTile(
              title: Text(biddingDeadline == null
                  ? 'Select Bidding Deadline'
                  : biddingDeadline.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    biddingDeadline = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('Delivery Deadline (Optional)'),
            ListTile(
              title: Text(deliveryDeadline == null
                  ? 'Select Delivery Deadline'
                  : deliveryDeadline.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    deliveryDeadline = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('Specifications (key-value pairs)'),
            ...specifications.map((spec) {
              final keyController = TextEditingController(text: spec['key']);
              final valueController = TextEditingController(text: spec['value']);
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: keyController,
                      decoration: const InputDecoration(hintText: 'Spec Name'),
                      onChanged: (value) {
                        spec['key'] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: valueController,
                      decoration: const InputDecoration(hintText: 'Spec Value'),
                      onChanged: (value) {
                        spec['value'] = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        specifications.remove(spec);
                      });
                    },
                  ),
                ],
              );
            }).toList(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  specifications.add({'key': '', 'value': ''});
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Specification'),
            ),
            const SizedBox(height: 16),

            _buildLabel('Product Description / Requirements'),
            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              maxLength: 250,  // Limit characters for description
              decoration: const InputDecoration(hintText: 'Describe your product requirements...'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            // Modern Upload Section for PDFs
            _buildLabel('Upload Necessary PDFs'),
            GestureDetector(
              onTap: _pickPDFs,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.picture_as_pdf, size: 40, color: Colors.blueAccent),
                    const SizedBox(height: 8),
                    const Text('Tap to Upload PDFs', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                    if (uploadedPDFs.isNotEmpty)
                      Text('Uploaded: ${uploadedPDFs.length} PDF(s)', style: TextStyle(fontSize: 14, color: Colors.green)),
                    if (isUploadingPDF)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Modern Upload Section for Images
            _buildLabel('Upload Images'),
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.image, size: 40, color: Colors.greenAccent),
                    const SizedBox(height: 8),
                    const Text('Tap to Upload Images', style: TextStyle(fontSize: 16, color: Colors.greenAccent)),
                    if (uploadedImages.isNotEmpty)
                      Text('Uploaded: ${uploadedImages.length} Image(s)', style: TextStyle(fontSize: 14, color: Colors.green)),
                    if (isUploadingImage)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Submit logic here
                }
              },
              child: const Text('Request for Quotation'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: locationController,
      decoration: InputDecoration(
        hintText: 'Enter location',
        prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: quantityController,
      decoration: InputDecoration(
        hintText: 'Enter quantity',
        prefixIcon: const Icon(Icons.add_box, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 16),
      maxLength: 5,  // Limit characters for quantity
    );
  }
}
