import 'dart:io';
import '../entities/rfq_entity.dart';

abstract class RfqRepository {
  Future<void> submitRequest(
      Rfq rfq,
      List<File> images,
      );
}