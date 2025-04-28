import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quickdeal/common/widget/custom_snackbar.dart';
import '../../data/models/rfq_model.dart';
import '../../domain/entities/rfq_entity.dart';

final supabase = Supabase.instance.client;

class RfqFormController {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final requirements = TextEditingController();
  final budgetMin = TextEditingController();
  final budgetMax = TextEditingController();

  String? selectedCategory;
  DateTime? biddingDeadline;
  DateTime? deliveryDeadline;
  bool isSubmitting = false;

  final productImages = <File>[];
  final documents = <File>[];

  final categories = [
    'Manufacturing',
    'Customized Design Work',
    'Electrical Work',
    'Homemade Food',
    'Interior Design',];

  void dispose() {
    title.dispose();
    requirements.dispose();
    budgetMin.dispose();
    budgetMax.dispose();
  }

  Widget dateTile(BuildContext context, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(hintText: 'mm/dd/yyyy', suffixIcon: Icon(Icons.calendar_today)),
        child: Text(date == null ? 'mm/dd/yyyy' : DateFormat('MM/dd/yyyy').format(date)),
      ),
    );
  }

  Widget attachmentPicker(
      BuildContext context, {
        required bool isImage,
        required List<File> files,
        required VoidCallback onPick,
        required void Function(int index) onRemove,
      }) {
    return InkWell(
      onTap: onPick,
      child: Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
        child: files.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isImage ? Icons.image : Icons.file_present, size: 32, color: Colors.grey),
            const SizedBox(height: 8),
            Text(isImage ? 'Add product images' : 'Add documents', style: const TextStyle(color: Colors.grey)),
            Text(isImage ? 'Max size 5MB' : 'PDF, DOC up to 10MB', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )
            : ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          itemCount: files.length,
          itemBuilder: (context, i) => Stack(
            children: [
              Container(
                width: 80,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isImage ? null : Colors.grey.shade200,
                  image: isImage ? DecorationImage(image: FileImage(files[i]), fit: BoxFit.cover) : null,
                ),
                child: isImage
                    ? null
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_present),
                    const SizedBox(height: 4),
                    Text(path.basename(files[i].path), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemove(i),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      productImages.addAll(pickedImages.map((e) => File(e.path)));
    }
  }

  Future<void> pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      type: FileType.custom,
    );
    if (result != null) {
      documents.addAll(result.files.where((e) => e.path != null).map((e) => File(e.path!)));
    }
  }

  Future<void> pickBiddingDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) biddingDeadline = picked;
  }

  Future<void> pickDeliveryDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) deliveryDeadline = picked;
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (biddingDeadline == null || deliveryDeadline == null || selectedCategory == null) {
      CustomSnackbar.show(context, message: 'Please complete all fields', type: SnackbarType.warning);
      return;
    }

    try {
      final uploadedFiles = <String>[];
      for (final file in [...productImages, ...documents]) {
        final url = await _uploadFile(file);
        if (url != null) uploadedFiles.add(url);
      }

      final userId = supabase.auth.currentUser?.id ?? '';
      final clientId = await _getClientIdFromUserId(userId);

      final rfq = Rfq(
        title: title.text,
        description: requirements.text,
        clientId: clientId,
        categoryId: await _getCategoryIdByName(selectedCategory!),
        minBudget: num.tryParse(budgetMin.text),
        maxBudget: num.tryParse(budgetMax.text),
        biddingDeadline: biddingDeadline!,
        deliveryDeadline: deliveryDeadline!,
        currentlySelectedBidId: null,
        attachments: uploadedFiles,
        specification: [],
      );

      final model = RfqModel.fromEntity(rfq);
      await supabase.from('rfqs').insert(model.toJson());

      CustomSnackbar.show(context, message: 'RFQ submitted successfully!', type: SnackbarType.success);
      _resetForm();
    } catch (e) {
      CustomSnackbar.show(context, message: 'Error: $e', type: SnackbarType.error);
    }
  }

  void _resetForm() {
    title.clear();
    requirements.clear();
    budgetMin.clear();
    budgetMax.clear();
    selectedCategory = null;
    biddingDeadline = null;
    deliveryDeadline = null;
    productImages.clear();
    documents.clear();
  }

  Future<String?> _uploadFile(File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final fileBytes = await file.readAsBytes();
    final ext = path.extension(file.path).replaceAll('.', '');
    await supabase.storage.from('rfq_attachments').uploadBinary(
      fileName,
      fileBytes,
      fileOptions: FileOptions(contentType: 'application/$ext'),
    );
    return supabase.storage.from('rfq_attachments').getPublicUrl(fileName);
  }

  Future<String> _getClientIdFromUserId(String userId) async {
    final response = await supabase.from('clients').select('client_id').eq('client_id', userId).maybeSingle();
    return response?['client_id'] ?? (throw Exception('Client not found'));
  }

  Future<String> _getCategoryIdByName(String name) async {
    final response = await supabase.from('categories').select('category_id').ilike('name', '%$name%').maybeSingle();
    return response?['category_id'] ?? (throw Exception('Category not found'));
  }
}