import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:quickdeal/common/widget/custom_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../common/widget/custom_appbar.dart';
import '../../models/rfq.dart';
import '../widgets/section_title.dart';

final supabase = Supabase.instance.client;

class ClientAddRequestScreen extends StatefulWidget {
  const ClientAddRequestScreen({super.key});

  @override
  State<ClientAddRequestScreen> createState() => CreateRequestScreenState();
}

class CreateRequestScreenState extends State<ClientAddRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productTitleController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();

  String? _selectedCategory;
  DateTime? _deliveryDeadline;
  DateTime? _biddingDeadline;
  bool _isSubmitting = false;

  final List<File> _productImages = [];
  final List<File> _documents = [];

  final List<String> _categories = [
    'Manufacturing',
    'Design',
    'Other'
  ];

  @override
  void dispose() {
    _productTitleController.dispose();
    _requirementsController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        for (final pickedImage in pickedImages) {
          _productImages.add(File(pickedImage.path));
        }
      });
    }
  }

  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (final file in result.files) {
          if (file.path != null) {
            _documents.add(File(file.path!));
          }
        }
      });
    }
  }

  void _clearFormInputs() {
    _productTitleController.clear();
    _requirementsController.clear();
    _budgetMinController.clear();
    _budgetMaxController.clear();
    setState(() {
      _selectedCategory = null;
      _biddingDeadline = null;
      _deliveryDeadline = null;
      _productImages.clear();
      _documents.clear();
    });
  }


  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _deliveryDeadline) {
      setState(() {
        _deliveryDeadline = picked;
      });
    }
  }

  Future<void> _selectBiddingDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _biddingDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _biddingDeadline) {
      setState(() {
        _biddingDeadline = picked;
      });
    }
  }


  Future<String?> _uploadFile(File file, String bucket) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final fileBytes = await file.readAsBytes();
      final fileExt = path.extension(file.path).replaceAll('.', '');

      await supabase.storage.from(bucket).uploadBinary(
        fileName,
        fileBytes,
        fileOptions: FileOptions(contentType: 'application/$fileExt'),
      );

      final fileUrl = supabase.storage.from(bucket).getPublicUrl(fileName);
      return fileUrl;
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Error uploading file: $e',
          type: SnackbarType.error,
        );
      }
      return null;
    }
  }

  Future<void> _submitRfq() async {
    if (!_formKey.currentState!.validate()) return;

    if (_biddingDeadline == null) {
      CustomSnackbar.show(
        context,
        message: 'Please select a bidding deadline',
        type: SnackbarType.warning,
      );
      return;
    }

    if (_deliveryDeadline == null) {
      CustomSnackbar.show(
        context,
        message: 'Please select a delivery deadline',
        type: SnackbarType.warning,
      );
      return;
    }

    if (_selectedCategory == null) {
      CustomSnackbar.show(
        context,
        message: 'Please select a category',
        type: SnackbarType.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final List<String> uploadedFiles = [];

      for (final file in [..._productImages, ..._documents]) {
        final url = await _uploadFile(file, 'rfq_attachments');
        if (url != null) uploadedFiles.add(url);
      }

      final userId = supabase.auth.currentUser?.id ?? '';
      final clientId = await _getClientIdFromUserId(userId);

      final rfq = Rfq(
        title: _productTitleController.text,
        description: _requirementsController.text,
        clientId: clientId,
        categoryId: await _getCategoryIdByName(_selectedCategory!),
        minBudget: num.tryParse(_budgetMinController.text),
        maxBudget: num.tryParse(_budgetMaxController.text),
        rfqDeadline: DateTime.now().add(const Duration(days: 7)),
        deliveryDeadline: _deliveryDeadline,
        currently_selected_bid_id: null,
        attachments: uploadedFiles,
        specification: [], 
      );

      await supabase.from('rfqs').insert(rfq.toJson());

      if (mounted) {
        CustomSnackbar.show(context, message: 'RFQ created successfully!', type: SnackbarType.success);
        _clearFormInputs();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, message: 'Error creating RFQ: $e', type: SnackbarType.error);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
            // Product Title
            const SectionTitle(title: 'Product Title'),
            TextFormField(
              controller: _productTitleController,
              decoration: const InputDecoration(
                hintText: 'Enter product title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            const SectionTitle(title: 'Category'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                hintText: 'Select category',
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Budget Range
            const SectionTitle(title: 'Budget Range'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _budgetMinController,
                    decoration: const InputDecoration(
                      hintText: 'Min',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _budgetMaxController,
                    decoration: const InputDecoration(
                      hintText: 'Max',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      final min = int.tryParse(_budgetMinController.text) ?? 0;
                      final max = int.tryParse(value) ?? 0;
                      if (max < min) {
                        return 'Max must be greater than min';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bidding Deadline
            const SectionTitle(title: 'Bidding Deadline'),
            InkWell(
              onTap: _selectBiddingDeadline,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'mm/dd/yyyy',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectBiddingDeadline,
                  ),
                ),
                child: Text(
                  _biddingDeadline == null
                      ? 'mm/dd/yyyy'
                      : DateFormat('MM/dd/yyyy').format(_biddingDeadline!),
                ),
              ),
            ),
            const SizedBox(height: 16),


            // Delivery Deadline
            const SectionTitle(title: 'Delivery Deadline'),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'mm/dd/yyyy',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                child: Text(
                  _deliveryDeadline == null
                      ? 'mm/dd/yyyy'
                      : DateFormat('MM/dd/yyyy').format(_deliveryDeadline!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Requirements
            const SectionTitle(title: 'Requirements'),
            TextFormField(
              controller: _requirementsController,
              decoration: const InputDecoration(
                hintText: 'Describe your product requirements...',
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter requirements';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Attachments - Images
            const SectionTitle(title: 'Attachments'),
            InkWell(
              onTap: _pickImages,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _productImages.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Add product images',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Max size 5MB',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: _productImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _productImages.length) {
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.grey),
                      );
                    }

                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_productImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _productImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Attachments - Documents
            InkWell(
              onTap: _pickDocuments,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _documents.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.file_present, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Add documents',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'PDF, DOC up to 10MB',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: _documents.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _documents.length) {
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.grey),
                      );
                    }

                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.file_present),
                              const SizedBox(height: 4),
                              Text(
                                path.basename(_documents[index].path),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _documents.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitRfq,
              child: _isSubmitting
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text('Request for Quota'),
            ),
          ],
        ),
      ),
    );
  }
}


Future<String> _getClientIdFromUserId(String userId) async {
  final response = await supabase
      .from('clients')
      .select('client_id')
      .eq('client_id', userId)
      .maybeSingle();

  if (response != null && response['client_id'] != null) {
    return response['client_id'];
  } else {
    throw Exception('Client not found for user');
  }
}

Future<String> _getCategoryIdByName(String name) async {

  final allCategories = await supabase.from('categories').select();
  print("All categories: $allCategories");

  final response = await supabase
      .from('categories')
      .select('category_id')
      .ilike('name', '%$name%')
      .maybeSingle();

  if (response != null && response['category_id'] != null) {
    return response['category_id'];
  } else {
    throw Exception('Category not found');
  }
}
