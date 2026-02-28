import 'package:flutter/material.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'role_form_configs/base_role_form_config.dart';

/// Manages form state and field interactions for role details form
class RoleFormStateManager {
  final BaseRoleFormConfig formConfig;
  final Map<String, TextEditingController> controllers = {};
  String? selectedState;

  RoleFormStateManager(this.formConfig);

  /// Initialize text controllers for all text fields
  void initializeControllers(String accountType) {
    final fields = formConfig.getFormFields(accountType);
    for (var field in fields) {
      // Only create text controllers for text fields, not for dropdowns
      if (field['type'] != 'dropdown' && field['type'] != 'multiselect') {
        controllers[field['name']] = TextEditingController();
      }
    }
  }

  /// Get form fields with updated options (e.g., city options based on state)
  List<Map<String, dynamic>> getFormFields(String accountType) {
    final fields = formConfig.getFormFields(accountType);
    
    // Update city field options if state is selected
    for (var field in fields) {
      if (field['name'] == 'city' && selectedState != null) {
        field['options'] = NigerianStatesAndLGA.getStateLGAs(selectedState!)
            .map((lga) => {'label': lga, 'value': lga})
            .toList();
        field['hint'] = 'Select a city';
      }
    }
    
    return fields;
  }

  /// Handle dropdown field changes
  void handleDropdownChange(String fieldName, String? value) {
    if (value != null && value.isNotEmpty) {
      // Store dropdown values in controllers
      controllers[fieldName] = TextEditingController(text: value);

      // If state field changed, update selected state and clear city
      if (fieldName == 'state') {
        selectedState = value;
        // Clear city selection when state changes
        if (controllers.containsKey('city')) {
          controllers['city']?.clear();
        }
      }
    }
  }

  /// Handle multiselect field changes
  void handleMultiselectChange(String fieldName, List<String> values) {
    // Store multiselect values as comma-separated string
    controllers[fieldName] = TextEditingController(text: values.join(', '));
  }

  /// Clear all controllers when account type changes
  void clearControllers() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    controllers.clear();
    selectedState = null;
  }

  /// Dispose all controllers
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    controllers.clear();
  }
}
