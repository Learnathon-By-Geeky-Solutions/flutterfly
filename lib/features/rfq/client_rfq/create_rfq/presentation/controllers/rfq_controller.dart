import 'package:flutter/material.dart';
import 'package:quickdeal/common/widget/custom_snackbar.dart';
import '../../../../../../main.dart';
import '../../data/models/rfq_model.dart';
import '../../domain/entities/rfq_entity.dart';

class RfqFormController {
  final title = TextEditingController();
  final description = TextEditingController();
  final budget = TextEditingController();
  final quantity = TextEditingController();
  final location = TextEditingController();

  DateTime? biddingDeadline;
  DateTime? deliveryDeadline;
  bool isSubmitting = false;

  List<String> selectedCategories = [];
  List<Map<String, String>> specification = [];

  void dispose() {
    title.dispose();
    description.dispose();
    budget.dispose();
    quantity.dispose();
    location.dispose();
  }

  Future<void> submitForm(BuildContext context) async {
    if (biddingDeadline == null || deliveryDeadline == null || selectedCategories.isEmpty) {
      CustomSnackbar.show(context, message: 'Please complete all fields', type: SnackbarType.warning);
      return;
    }

    final parsedBudget = num.tryParse(budget.text.trim());
    if (parsedBudget == null) {
      CustomSnackbar.show(context, message: 'Invalid budget', type: SnackbarType.error);
      return;
    }

    try {
      final userId = supabase.auth.currentUser?.id ?? '';
      final clientId = await _getClientIdFromUserId(userId);

      final rfq = Rfq(
        title: title.text.trim(),
        description: description.text.trim(),
        clientId: clientId,
        categoryNames: selectedCategories,
        budget: parsedBudget,
        quantity: int.tryParse(quantity.text.trim()),
        location: location.text.trim().isEmpty ? null : location.text.trim(),
        biddingDeadline: biddingDeadline!,
        deliveryDeadline: deliveryDeadline!,
        specification: specification,
      );

      final model = RfqModel.fromEntity(rfq);
      await supabase.from('rfqs').insert(model.toJson());

      CustomSnackbar.show(context, message: 'RFQ submitted successfully!', type: SnackbarType.success);
      _resetForm();
    } catch (e) {
      CustomSnackbar.show(context, message: 'Error: $e', type: SnackbarType.error);
    }
  }

  Future<String> _getClientIdFromUserId(String userId) async {
    final response = await supabase
        .from('clients')
        .select('client_id')
        .eq('client_id', userId)
        .maybeSingle();
    if (response == null) throw Exception('Client not found');
    return response['client_id'];
  }

  void _resetForm() {
    title.clear();
    description.clear();
    budget.clear();
    quantity.clear();
    location.clear();
    selectedCategories.clear();
    biddingDeadline = null;
    deliveryDeadline = null;
    specification.clear();
  }
}
