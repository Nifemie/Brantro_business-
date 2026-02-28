/// Base class for role form configurations
/// Each role extends this to define its specific form fields
abstract class BaseRoleFormConfig {
  /// Get form fields for the role
  /// Returns list of field definitions with type, name, label, options, etc.
  List<Map<String, dynamic>> getFormFields(String accountType);
  
  /// Get the role name
  String get roleName;
  
  /// Whether this role supports account type switching (Individual/Business)
  bool get supportsAccountTypes => false;
}
