import 'package:quickdeal/features/auth/signup/client_signup/domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  ClientModel({
    required super.fullName,
    required super.email,
    required super.password,
    super.profilePic,
    super.contactNumber,
    super.clientBkashNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'profilePic': profilePic,
      'contactNumber': contactNumber,
      'clientBkashNumber': clientBkashNumber,
    };
  }
}