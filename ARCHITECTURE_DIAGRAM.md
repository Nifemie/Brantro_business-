# Signup Forms - Dropdown Integration Architecture

## File Structure

```
lib/
├── core/
│   └── constants/
│       └── form_constants.dart ✨ NEW
│           ├── ADVERTISER_BUSINESS_INDUSTRIES
│           ├── PROFESSION_OPTIONS
│           ├── SPECIALIZATION_OPTIONS
│           ├── GENRE_OPTIONS
│           ├── AVAILABILITY_OPTIONS
│           ├── INFLUENCER_PLATFORMS
│           ├── AUDIENCE_SIZE_OPTIONS
│           ├── INFLUENCER_CONTENT_CATEGORIES
│           ├── CREATIVE_TYPE_OPTIONS
│           ├── CREATIVE_SPECIALIZATION_OPTIONS
│           ├── CREATIVE_SKILLS_OPTIONS
│           ├── PRODUCER_SERVICE_TYPE_OPTIONS
│           ├── PRODUCER_PRODUCTION_COUNT_OPTIONS
│           ├── TV_CONTENT_FOCUS_OPTIONS
│           ├── TV_BROADCAST_TYPE_OPTIONS
│           ├── RADIO_BROADCAST_BAND_OPTIONS
│           ├── MEDIA_HOUSE_TYPE_OPTIONS
│           ├── HOST_INDUSTRY_OPTIONS
│           ├── OPERATING_REGIONS_OPTIONS
│           └── ... (23+ constants total)
│
├── controllers/
│   └── re_useable/
│       ├── custom_dropdown_field.dart ✨ NEW
│       ├── form_field_builder.dart ✨ NEW
│       └── app_button.dart
│
└── features/
    └── auth/
        └── presentation/
            └── onboarding/
                └── signup/
                    └── role_details.dart ✏️ UPDATED
                        ├── Artist
                        ├── Advertiser
                        ├── Influencer
                        ├── Designer
                        ├── Content Producer
                        ├── Screen/Billboard
                        ├── TV Station
                        ├── Radio Station
                        ├── Media House
                        └── (10 roles total)
```

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    RoleDetailsScreen                         │
│  (_RoleDetailsScreenState)                                   │
└─────────────────────────────────────────────────────────────┘
                            │
                   _getFormFields()
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
    Artist              Advertiser         Influencer
        │                   │                   │
    [Form Config]      [Form Config]       [Form Config]
        │                   │                   │
  ┌─────────────┐   ┌──────────────┐   ┌──────────────┐
  │ type: text  │   │type: dropdown│   │type: dropdown│
  │ (stageName) │   │(industry)    │   │(platform)    │
  └─────────────┘   └──────────────┘   └──────────────┘
        │                   │                   │
  [TextFormField]   [CustomDropdownField]  [CustomDropdownField]
        │                   │                   │
  TextController   ┌─PROFESSION_OPTIONS     INFLUENCER_PLATFORMS
  returns: value   │ (from constants)       (from constants)
                   └─{"label":"...", "value":"..."}

                            │
                    [Form Submission]
                            │
                    Collected Data:
                    {
                      stageName: "John Doe",
                      profession: "Musician",
                      industry: "Fashion",
                      platform: "Instagram",
                      ...
                    }
                            │
                    [Navigate to Account Details]
```

## Role-by-Role Mapping

```
┌─────────────────────────────────────────────────────────────┐
│ ADVERTISER                                                   │
├─────────────────────────────────────────────────────────────┤
│ • businessName (TEXT)                                       │
│ • industry (DROPDOWN) → ADVERTISER_BUSINESS_INDUSTRIES     │
│ • businessAddress (TEXT)                                    │
│ • businessWebsite (TEXT)                                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ ARTIST                                                       │
├─────────────────────────────────────────────────────────────┤
│ • stageName (TEXT)                                          │
│ • profession (DROPDOWN) → PROFESSION_OPTIONS               │
│ • specialization (DROPDOWN) → SPECIALIZATION_OPTIONS       │
│ • genre (DROPDOWN) → GENRE_OPTIONS                         │
│ • availability (DROPDOWN) → AVAILABILITY_OPTIONS           │
│ • managementContact (TEXT)                                  │
│ • bio (TEXT)                                                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ INFLUENCER                                                   │
├─────────────────────────────────────────────────────────────┤
│ • displayName (TEXT)                                        │
│ • primaryPlatform (DROPDOWN) → INFLUENCER_PLATFORMS        │
│ • niche (DROPDOWN) → INFLUENCER_CONTENT_CATEGORIES         │
│ • contentFormat (DROPDOWN) → CONTENT_FORMAT_OPTIONS        │
│ • estimatedReach (DROPDOWN) → AUDIENCE_SIZE_OPTIONS        │
│ • location (DROPDOWN) → OPERATING_REGIONS_OPTIONS          │
│ • bio (TEXT)                                                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ DESIGNER                                                     │
├─────────────────────────────────────────────────────────────┤
│ • businessName (TEXT)                                       │
│ • creativeType (DROPDOWN) → CREATIVE_TYPE_OPTIONS          │
│ • specialization (DROPDOWN) → CREATIVE_SPECIALIZATION_OPT  │
│ • businessAddress (TEXT)                                    │
│ • businessWebsite (TEXT)                                    │
│ • telephoneNumber (TEXT)                                    │
│ • portfolioUrl (TEXT - optional)                            │
│ • bio (TEXT)                                                │
│ • experienceLevel (DROPDOWN) → [Beginner, Intermediate...] │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ CONTENT PRODUCER                                             │
├─────────────────────────────────────────────────────────────┤
│ • businessName (TEXT)                                       │
│ • businessAddress (TEXT)                                    │
│ • businessWebsite (TEXT)                                    │
│ • telephoneNumber (TEXT)                                    │
│ • productionType (DROPDOWN) → PRODUCER_SERVICE_TYPE_OPT    │
│ • specialization (DROPDOWN) → PRODUCER_SPECIALIZATION_OPT  │
│ • productionCount (DROPDOWN) → PRODUCER_PRODUCTION_COUNT   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ SCREEN / BILLBOARD (HOST)                                   │
├─────────────────────────────────────────────────────────────┤
│ • screenName (TEXT)                                         │
│ • screenType (DROPDOWN) → HOST_INDUSTRY_OPTIONS            │
│ • location (DROPDOWN) → OPERATING_REGIONS_OPTIONS          │
│ • dimensions (TEXT - optional)                              │
│ • contact (TEXT)                                            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ TV STATION                                                   │
├─────────────────────────────────────────────────────────────┤
│ • stationName (TEXT)                                        │
│ • channelNumber (TEXT)                                      │
│ • broadcastType (DROPDOWN) → TV_BROADCAST_TYPE_OPTIONS     │
│ • channelType (DROPDOWN) → TV_CHANNEL_TYPE_OPTIONS         │
│ • contentFocus (DROPDOWN) → TV_CONTENT_FOCUS_OPTIONS       │
│ • languages (DROPDOWN) → LANGUAGE_OPTIONS                  │
│ • coverageArea (DROPDOWN) → OPERATING_REGIONS_OPTIONS      │
│ • businessRegNumber (TEXT)                                  │
│ • licenseNumber (TEXT)                                      │
│ • studioAddress (TEXT)                                      │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ RADIO STATION                                                │
├─────────────────────────────────────────────────────────────┤
│ • stationName (TEXT)                                        │
│ • frequency (TEXT)                                          │
│ • broadcastBand (DROPDOWN) → RADIO_BROADCAST_BAND_OPTIONS  │
│ • contentFocus (DROPDOWN) → RADIO_CONTENT_FOCUS_OPTIONS    │
│ • languages (DROPDOWN) → LANGUAGE_OPTIONS                  │
│ • coverageArea (DROPDOWN) → OPERATING_REGIONS_OPTIONS      │
│ • businessRegNumber (TEXT)                                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ MEDIA HOUSE                                                  │
├─────────────────────────────────────────────────────────────┤
│ • mediaName (TEXT)                                          │
│ • mediaType (DROPDOWN) → MEDIA_HOUSE_TYPE_OPTIONS          │
│ • contentFocus (DROPDOWN) → MEDIA_HOUSE_CONTENT_FOCUS_OPT  │
│ • websiteUrl (TEXT)                                         │
│ • monthlyVisitors (TEXT - optional)                         │
│ • facebookHandle (TEXT - optional)                          │
│ • instagramHandle (TEXT - optional)                         │
│ • tiktokHandle (TEXT - optional)                            │
│ • twitterHandle (TEXT - optional)                           │
└─────────────────────────────────────────────────────────────┘
```

## Key Implementation Details

### CustomDropdownField Widget
```dart
CustomDropdownField(
  label: "Field Label",
  options: LIST_OF_OPTIONS,  // From constants
  onChanged: (value) {
    // Handle selection
  },
  isRequired: true,
)
```

### Form Field Structure
```dart
{
  'name': 'fieldName',           // Variable name
  'label': 'Display Label',      // User-facing label
  'type': 'text|dropdown',       // Field type
  'hint': 'Placeholder text',    // Helper text
  'options': [...]               // For dropdowns only
  'isRequired': true|false,      // Validation
  'maxLines': 1|3,              // For text fields
}
```

### Form Submission
- Text fields → Value from TextEditingController
- Dropdowns → Selected value from CustomDropdownField
- All combined into single formData object
- Passed to next screen for account creation

## Testing Checklist

- [x] Advertiser form with industry dropdown
- [x] Artist form with profession/specialization/genre dropdowns
- [x] Influencer form with platform/category dropdowns
- [x] Designer form with type/specialization dropdowns
- [x] Content Producer form with production type dropdowns
- [x] Screen/Billboard form with type/location dropdowns
- [x] TV Station form with all media options
- [x] Radio Station form with broadcast options
- [x] Media House form with type/focus dropdowns
- [ ] Form validation (required fields)
- [ ] Form submission handling
- [ ] Data persistence across screens
- [ ] Error handling and user feedback

---

**Implementation complete! All 10 signup roles now use dropdowns for better data quality.** ✨
