class ClientEntity {
  final String fullName;
  final String email;
  final String password;
  final String? profilePic;
  final String? contactNumber;
  final String? clientBkashNumber;

  ClientEntity({
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePic,
    this.contactNumber,
    this.clientBkashNumber,
  });
}