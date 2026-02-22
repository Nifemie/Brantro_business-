# Location Selection Implementation

## Overview
The account details screen uses a cascading dropdown system for location selection: Country → State → LGA (Local Government Area).

## Packages Used
- `country_picker: ^2.0.23` - For country selection (all countries, searchable)
- `nigerian_states_and_lga: ^1.0.0` - For Nigerian states and LGAs

## Implementation Details

### 1. Country Selection
```dart
// Uses country_picker package
showCountryPicker(
  context: context,
  showPhoneCode: false,
  onSelect: (Country country) {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _selectedLGA = null;
      _availableLGAs = [];
    });
  },
);
```

### 2. State Selection (Nigeria Only)
```dart
// Only shows when Nigeria is selected
if (_selectedCountry?.name == 'Nigeria')
  DropdownButtonFormField<String>(
    value: _selectedState,
    items: NigerianStatesAndLGA.allStates.map((state) {
      return DropdownMenuItem<String>(
        value: state,
        child: Text(state),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedState = value;
        _selectedLGA = null;
        if (value != null) {
          _availableLGAs = NigerianStatesAndLGA.getStateLGAs(value);
        }
      });
    },
  )
```

### 3. LGA Selection (Nigeria + State Selected)
```dart
// Only shows when both Nigeria and state are selected
if (_selectedCountry?.name == 'Nigeria' && _selectedState != null)
  DropdownButtonFormField<String>(
    value: _selectedLGA,
    items: _availableLGAs.map((lga) {
      return DropdownMenuItem<String>(
        value: lga,
        child: Text(lga),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedLGA = value;
      });
    },
  )
```

## State Variables
- `Country? _selectedCountry` - Selected country object
- `String? _selectedState` - Selected state name
- `String? _selectedLGA` - Selected LGA name
- `List<String> _availableLGAs` - List of LGAs for selected state

## Data Flow
1. User selects country → Resets state and LGA
2. If Nigeria selected → State dropdown appears with 37 states
3. User selects state → Loads LGAs for that state
4. LGA dropdown appears with loaded LGAs
5. User selects LGA → Complete

## Package API
- `NigerianStatesAndLGA.allStates` - Returns List<String> of all 37 Nigerian states
- `NigerianStatesAndLGA.getStateLGAs(String state)` - Returns List<String> of LGAs for the given state

## Troubleshooting
If LGA dropdown is not enabling:
1. Verify Nigeria is selected (check `_selectedCountry?.name == 'Nigeria'`)
2. Verify state is selected (check `_selectedState != null`)
3. Check if `getStateLGAs()` returns data (check `_availableLGAs.length`)
4. Ensure hot reload after state selection
5. Verify package is installed: `flutter pub get`

## File Location
`lib/features/auth/presentation/onboarding/signup/account_details.dart` (lines 307-540)
