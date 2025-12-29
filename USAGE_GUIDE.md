# Form Integration - Usage Guide & Examples

## Quick Start

### 1. Using Dropdown Constants

Import the constants file:
```dart
import '../../../../../core/constants/form_constants.dart';
```

Use in form configuration:
```dart
{
  'name': 'industry',
  'label': 'Industry',
  'type': 'dropdown',
  'options': ADVERTISER_BUSINESS_INDUSTRIES
    .map((industry) => {'label': industry, 'value': industry})
    .toList(),
}
```

### 2. Creating a Dropdown Field

In your form widget:
```dart
CustomDropdownField(
  label: 'Platform',
  options: INFLUENCER_PLATFORMS,
  hint: 'Select your primary platform',
  isRequired: true,
  onChanged: (selectedValue) {
    print('Selected: $selectedValue');
  },
)
```

### 3. Handling Form Submission

The form automatically collects dropdown values:
```dart
final formData = <String, dynamic>{};

// Text fields from controllers
_controllers.forEach((key, controller) {
  formData[key] = controller.text;
});

// Dropdown values are collected automatically
// in _handleDropdownChange()

print(formData);
// Output: {
//   'businessName': 'Acme Corp',
//   'industry': 'Fashion',
//   'location': 'Lagos',
// }
```

---

## Field Type Examples

### TEXT FIELD
```dart
{
  'name': 'stageName',
  'label': 'Stage Name',
  'type': 'text',
  'hint': 'Enter your stage name',
  'isRequired': true,
  'maxLines': 1,
}
```

### DROPDOWN FIELD (Single Select)
```dart
{
  'name': 'profession',
  'label': 'Profession',
  'type': 'dropdown',
  'hint': 'Select your profession',
  'options': PROFESSION_OPTIONS,
  'isRequired': true,
}
```

### TEXT AREA (Multiple Lines)
```dart
{
  'name': 'bio',
  'label': 'Bio',
  'type': 'text',
  'hint': 'Tell us about yourself',
  'maxLines': 3,
  'isRequired': false,
}
```

### OPTIONAL FIELD
```dart
{
  'name': 'portfolioUrl',
  'label': 'Portfolio URL (Optional)',
  'type': 'text',
  'hint': 'https://example.com',
  'isRequired': false,
}
```

---

## Role-Specific Examples

### ARTIST FORM
```dart
List<Map<String, dynamic>> artistForm() {
  return [
    {
      'name': 'stageName',
      'label': 'Stage Name',
      'type': 'text',
      'hint': 'Enter your stage name',
    },
    {
      'name': 'profession',
      'label': 'What is your profession?',
      'type': 'dropdown',
      'options': PROFESSION_OPTIONS,
      // Options: Musician, Actor, Comedian, DJ, MC, Dancer, Filmmaker, Content Creator, Visual Artist
    },
    {
      'name': 'specialization',
      'label': 'Your specialization?',
      'type': 'dropdown',
      'options': SPECIALIZATION_OPTIONS,
      // Options: Comedy, Film Acting, Music Performance, Music Recording, Stage Acting, Skits, Voice Acting, Dance Performance
    },
    {
      'name': 'genre',
      'label': 'Genre',
      'type': 'dropdown',
      'options': GENRE_OPTIONS,
      // Options: Afrobeats, Hip Hop, Gospel, Comedy, Drama, Action, Romance, Documentary
    },
    {
      'name': 'availability',
      'label': 'Availability',
      'type': 'dropdown',
      'options': AVAILABILITY_OPTIONS,
      // Options: Full Time, Part Time, On Demand, Contract, Campaign Based
    },
  ];
}
```

### INFLUENCER FORM
```dart
List<Map<String, dynamic>> influencerForm() {
  return [
    {
      'name': 'displayName',
      'label': 'Display Name',
      'type': 'text',
    },
    {
      'name': 'primaryPlatform',
      'label': 'Primary Platform',
      'type': 'dropdown',
      'options': INFLUENCER_PLATFORMS,
      // Options: Instagram, TikTok, YouTube, Facebook, Twitter/X, Snapchat, Mixed Platforms
    },
    {
      'name': 'niche',
      'label': 'Content Category',
      'type': 'dropdown',
      'options': INFLUENCER_CONTENT_CATEGORIES,
      // 18 categories like Lifestyle, Comedy, Fashion, Beauty, Tech, etc.
    },
    {
      'name': 'estimatedReach',
      'label': 'Audience Size',
      'type': 'dropdown',
      'options': AUDIENCE_SIZE_OPTIONS,
      // Options: Below 10k, 10k-50k, 50k-200k, 200k-1M, Above 1M
    },
    {
      'name': 'location',
      'label': 'State',
      'type': 'dropdown',
      'options': OPERATING_REGIONS_OPTIONS,
      // All 37 Nigerian states
    },
  ];
}
```

### DESIGNER FORM
```dart
List<Map<String, dynamic>> designerForm() {
  return [
    {
      'name': 'creativeType',
      'label': 'What type of designer are you?',
      'type': 'dropdown',
      'options': CREATIVE_TYPE_OPTIONS,
      // Options: Graphic Designer, Video Editor, Motion Designer, Animator, Illustrator, UI/UX Designer, Photographer, Mixed Creative
    },
    {
      'name': 'specialization',
      'label': 'Your specialization',
      'type': 'dropdown',
      'options': CREATIVE_SPECIALIZATION_OPTIONS,
      // Options: Brand Identity, Social Media Content, Advertising & Marketing, Product Design, Film & Video Production, etc.
    },
    {
      'name': 'experienceLevel',
      'label': 'Experience Level',
      'type': 'dropdown',
      'options': [
        {'label': 'Beginner', 'value': 'Beginner'},
        {'label': 'Intermediate', 'value': 'Intermediate'},
        {'label': 'Advanced', 'value': 'Advanced'},
        {'label': 'Expert', 'value': 'Expert'},
      ],
    },
  ];
}
```

### TV STATION FORM
```dart
List<Map<String, dynamic>> tvStationForm() {
  return [
    {
      'name': 'broadcastType',
      'label': 'Broadcast Type',
      'type': 'dropdown',
      'options': TV_BROADCAST_TYPE_OPTIONS,
      // Options: Terrestrial, Cable, Satellite, Digital, Mixed
    },
    {
      'name': 'channelType',
      'label': 'Channel Type',
      'type': 'dropdown',
      'options': TV_CHANNEL_TYPE_OPTIONS,
      // Options: Free To Air, Paid, Subscription
    },
    {
      'name': 'contentFocus',
      'label': 'Content Focus',
      'type': 'dropdown',
      'options': TV_CONTENT_FOCUS_OPTIONS,
      // Options: News, Entertainment, Sports, Movies, Music, Kids, Education, Religion, General
    },
    {
      'name': 'languages',
      'label': 'Broadcast Languages',
      'type': 'dropdown',
      'options': LANGUAGE_OPTIONS,
      // Options: English, Hausa, Yoruba, Igbo, Pidgin, French, Arabic
    },
    {
      'name': 'coverageArea',
      'label': 'Operating States',
      'type': 'dropdown',
      'options': OPERATING_REGIONS_OPTIONS,
      // All 37 Nigerian states
    },
  ];
}
```

---

## Advanced Usage

### Adding Custom Options

If you need to add options beyond the constants:

```dart
// Extend existing options
final customOptions = [
  ...PROFESSION_OPTIONS,
  {'label': 'Podcaster', 'value': 'Podcaster'},
  {'label': 'Blogger', 'value': 'Blogger'},
];
```

### Form Validation

```dart
CustomDropdownField(
  label: 'Industry',
  options: ADVERTISER_BUSINESS_INDUSTRIES
    .map((e) => {'label': e, 'value': e})
    .toList(),
  isRequired: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select an industry';
    }
    return null;
  },
  onChanged: (value) {
    setState(() {
      selectedIndustry = value;
    });
  },
)
```

### Conditional Dropdowns

```dart
if (selectedRole == 'Influencer') {
  return CustomDropdownField(
    label: 'Primary Platform',
    options: INFLUENCER_PLATFORMS,
    onChanged: (value) {
      setState(() {
        primaryPlatform = value;
      });
    },
  );
}
```

---

## Common Patterns

### Pattern 1: Text + Dropdown Combination
```dart
// Name (text) + Type (dropdown)
{
  'name': 'businessName',
  'label': 'Business Name',
  'type': 'text',
},
{
  'name': 'businessType',
  'label': 'Business Type',
  'type': 'dropdown',
  'options': [...],
}
```

### Pattern 2: Multiple Dropdowns
```dart
// Category → Subcategory → Specific Type
{
  'name': 'contentCategory',
  'type': 'dropdown',
  'options': INFLUENCER_CONTENT_CATEGORIES,
},
{
  'name': 'niche',
  'type': 'dropdown',
  'options': INFLUENCER_NICHES,
},
```

### Pattern 3: Required + Optional
```dart
{
  'name': 'requiredField',
  'type': 'dropdown',
  'isRequired': true,
  'options': [...],
},
{
  'name': 'optionalField',
  'type': 'text',
  'isRequired': false,
  'hint': 'Optional field',
}
```

---

## Data Validation

### Collecting Form Data
```dart
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // All dropdowns and text fields have been validated
    final formData = <String, dynamic>{};
    
    // Get text field values
    _controllers.forEach((key, controller) {
      formData[key] = controller.text;
    });
    
    // Dropdown values are collected in _handleDropdownChange()
    
    // Send to backend
    _submitToBackend(formData);
  }
}
```

### Validation Rules
- **Text fields**: Non-empty if `isRequired: true`
- **Dropdowns**: Selection required if `isRequired: true`
- **Optional fields**: Validation skipped if `isRequired: false`

---

## Troubleshooting

### Issue: Dropdown not showing options
**Solution**: Ensure options are in the correct format:
```dart
List<Map<String, String>> options = [
  {'label': 'Display Text', 'value': 'stored_value'},
]
```

### Issue: Form values not submitting
**Solution**: Make sure to collect values in `_handleDropdownChange()`:
```dart
void _handleDropdownChange(String fieldName, String? value) {
  if (value != null && value.isNotEmpty) {
    _controllers[fieldName] = TextEditingController(text: value);
  }
}
```

### Issue: Validation not working
**Solution**: Ensure `_formKey.currentState!.validate()` is called before submission:
```dart
if (_formKey.currentState!.validate()) {
  // Proceed with submission
}
```

---

## Testing

### Test Case 1: Artist Signup with Dropdowns
```
1. Fill "Stage Name" → "John Doe" (text)
2. Select "Profession" → "Musician" (dropdown)
3. Select "Specialization" → "Music Performance" (dropdown)
4. Select "Genre" → "Afrobeats" (dropdown)
5. Select "Availability" → "Full Time" (dropdown)
6. Fill "Bio" → "Professional musician" (text)
7. Submit form
8. Verify all data captured correctly
```

### Test Case 2: Influencer Signup with Multiple Dropdowns
```
1. Fill "Display Name" → "SophiaCreates" (text)
2. Select "Platform" → "TikTok" (dropdown)
3. Select "Category" → "Beauty" (dropdown)
4. Select "Content Format" → "Short Videos" (dropdown)
5. Select "Audience Size" → "200k - 1M" (dropdown)
6. Select "State" → "Lagos" (dropdown)
7. Submit form
8. Verify Instagram, TikTok, etc. saved correctly
```

---

**All signup forms are now powered by standardized dropdowns!** 🚀
