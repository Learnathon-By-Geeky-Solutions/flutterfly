import 'package:supabase_flutter/supabase_flutter.dart';

class RoleManager {
  static final Map<UserRole, List<Permission>> rolePermissions = {
    UserRole.vendor: [
      Permission.vendorHome,
      Permission.vendorRfq,
      Permission.vendorProfile,
      Permission.vendorBids,
    ],
    UserRole.client: [
      Permission.clientHome,
      Permission.clientRfq,
      Permission.clientCreateRequest,
      Permission.clientProfile,
      Permission.clientBids,
    ],
  };

  static bool hasPermission(UserRole role, Permission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }

  static List<Permission> getPermissionsForRole(UserRole role) {
    return rolePermissions[role] ?? [];
  }
}

enum Permission {
  vendorHome,
  vendorRfq,
  vendorProfile,
  vendorBids,
  clientHome,
  clientRfq,
  clientCreateRequest,
  clientProfile,
  clientBids,
}

enum UserRole {
  vendor,
  client,
}

Future<UserRole> getCurrentUserRole() async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) {
    throw Exception("User is not logged in");
  }

  final userMetadata = user.userMetadata;

  if (userMetadata != null && userMetadata['is_vendor'] == true) {
    return UserRole.vendor;
  }

  return UserRole.client;
}