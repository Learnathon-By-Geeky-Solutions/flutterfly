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
      Permission.clientBids
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

UserRole getCurrentUserRole() {
  final user = Supabase.instance.client.auth.currentUser;
  final isVendor = user?.userMetadata?['is_vendor'] ?? false;
  return isVendor ? UserRole.vendor : UserRole.client;
}
