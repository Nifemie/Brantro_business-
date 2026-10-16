import 'package:flutter/material.dart';
import '../../../../core/constants/location_constants.dart';
import 'role_form_configs/base_role_form_config.dart';

import '../../../../core/constants/form_constants.dart';

/// Manages form state and field interactions for role details form
class RoleFormStateManager {
  final BaseRoleFormConfig formConfig;
  final Map<String, TextEditingController> controllers = {};
  String? selectedState;

  RoleFormStateManager(this.formConfig);

  /// Initialize text controllers for all fields including dropdowns and multiselects
  void initializeControllers(String accountType) {
    final fields = formConfig.getFormFields(accountType);
    for (var field in fields) {
      // Create controllers for ALL field types so collectFormData always has a value
      controllers[field['name']] = TextEditingController();
    }
  }

  /// Get form fields with updated options (e.g., city options based on state)
  List<Map<String, dynamic>> getFormFields(String accountType) {
    final fields = formConfig.getFormFields(accountType);
    
    // Update city field options if state is selected
    for (var field in fields) {
      if (field['name'] == 'city') {
        if (selectedState != null && selectedState!.isNotEmpty) {
          field['options'] = LocationHelper.getLGAsForState(selectedState!)
              .map((lga) => {'label': lga, 'value': lga})
              .toList();
          field['hint'] = 'Select City / Local Government';
        } else {
          field['options'] = <Map<String, String>>[];
          field['hint'] = 'Select a state first';
        }
      }

      // Update specialization options if profession is selected (BRT-040)
      if (field['name'] == 'specialization' && controllers.containsKey('profession')) {
        final currentProfession = controllers['profession']?.text;
        if (currentProfession != null && currentProfession.isNotEmpty) {
          field['options'] = getSpecializationsForProfession(currentProfession);
        }
      }
    }
    
    return fields;
  }

  /// Handle dropdown field changes
  void handleDropdownChange(String fieldName, String? value) {
    final textVal = value ?? '';
    if (controllers.containsKey(fieldName)) {
      controllers[fieldName]!.text = textVal;
    } else {
      controllers[fieldName] = TextEditingController(text: textVal);
    }

    // If state field changed, update selected state and clear city
    if (fieldName == 'state') {
      selectedState = value;
      if (controllers.containsKey('city')) {
        controllers['city']!.clear();
      }
    }

    // If profession field changed, clear specialization (BRT-040)
    if (fieldName == 'profession') {
      if (controllers.containsKey('specialization')) {
        controllers['specialization']!.clear();
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
