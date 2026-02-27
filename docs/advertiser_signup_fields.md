# Advertiser Signup Fields

## Overview
Advertisers can sign up as either **Individual** or **Business** accounts. The signup process has two screens with different fields based on account type.

---

## INDIVIDUAL ADVERTISER

### Screen 1: Role Details (role_details.dart)
These fields are collected BEFORE the account_details screen:

1. **Full Name** (text, required)
   - Hint: "Enter your full name"

2. **Email Address** (text, required)
   - Hint: "Enter your email address"

3. **Phone Number** (text, required)
   - Hint: "+234XXXXXXXXXX"

4. **State** (dropdown, required)
   - Options: Nigerian states from OPERATING_REGIONS_OPTIONS

5. **City / Local Government** (dropdown, required)
   - Depends on state selection
   - Hint: "Select a state first" or "Select a city"

6. **Street Address** (text, required)
   - Hint: "House number and street name"

7. **Password** (password, required)
   - Hint: "Enter your password"

### Screen 2: Account Details (account_details.dart)
After role details, user proceeds to account_details screen:

#### Step 1: Personal Information
1. **Full Name** (text, required)
   - Hint: "Enter your full name"

2. **Phone Number** (text, required)
   - Hint: "+234XXXXXXXXXX"

3. **Email Address** (text, required)
   - Hint: "Enter your email"
   - Validation: Must contain '@'

#### Step 2: Location & Security
1. **Country** (dropdown via country_picker, required)
   - All countries available
   - Searchable

2. **State** (dropdown, required - only shows if Nigeria selected)
   - 37 Nigerian states from NigerianStatesAndLGA.allStates

3. **LGA** (dropdown, required - only shows if Nigeria + State selected)
   - LGAs loaded dynamically via NigerianStatesAndLGA.getStateLGAs(state)

4. **Address** (text, optional)
   - Hint: "Enter your address"
   - Multi-line (2 lines)

5. **Password** (password, required)
   - Hint: "Enter your password"
   - Validation: Minimum 6 characters

6. **Confirm Password** (password, required)
   - Hint: "Confirm your password"
   - Validation: Must match password

**NO ID fields for individual advertisers**

---

## BUSINESS ADVERTISER

### Screen 1: Role Details (role_details.dart)
These fields are collected BEFORE the account_details screen:

1. **Business Name** (text, required)
   - Hint: "Enter business name"

2. **Business Registration (RC) Number** (text, required)
   - Hint: "e.g., RC123456"

3. **TIN Number** (text, required)
   - Hint: "Enter your Tax Identification Number"

4. **Industry** (dropdown, required)
   - Options: ADVERTISER_BUSINESS_INDUSTRIES
   - Industries like: Technology, Healthcare, Finance, Retail, etc.

5. **Business Telephone Number** (text, required)
   - Hint: "+234XXXXXXXXXX"

6. **Website** (text, optional)
   - Hint: "https://yourcompany.com"

7. **Business Address** (text, required)
   - Hint: "Enter business address"

### Screen 2: Account Details (account_details.dart)
After role details, user proceeds to account_details screen:

#### Step 1: Personal Information
1. **Full Name** (text, required)
   - Contact person name
   - Hint: "Enter your full name"

2. **Phone Number** (text, required)
   - Contact person phone
   - Hint: "+234XXXXXXXXXX"

3. **Email Address** (text, required)
   - Contact person email
   - Hint: "Enter your email"
   - Validation: Must contain '@'

#### Step 2: Location & Security
1. **Country** (dropdown via country_picker, required)
   - All countries available
   - Searchable

2. **State** (dropdown, required - only shows if Nigeria selected)
   - 37 Nigerian states from NigerianStatesAndLGA.allStates

3. **LGA** (dropdown, required - only shows if Nigeria + State selected)
   - LGAs loaded dynamically via NigerianStatesAndLGA.getStateLGAs(state)

4. **Address** (text, optional)
   - Hint: "Enter your address"
   - Multi-line (2 lines)

5. **Password** (password, required)
   - Hint: "Enter your password"
   - Validation: Minimum 6 characters

6. **ID Type** (text, optional)
   - Hint: "e.g., National ID, International Passport"
   - Only shows for BUSINESS accounts

7. **ID Number** (text, required for business)
   - Hint: "Enter your ID number"
   - Only shows for BUSINESS accounts

8. **TIN Number** (text, required for business)
   - Hint: "Enter your Tax Identification Number"
   - Only shows for BUSINESS accounts

9. **Confirm Password** (password, required)
   - Hint: "Confirm your password"
   - Validation: Must match password

---

## Key Differences

| Field | Individual | Business |
|-------|-----------|----------|
| Business Name | ❌ | ✅ (role_details) |
| RC Number | ❌ | ✅ (role_details) |
| Industry | ❌ | ✅ (role_details) |
| Business Website | ❌ | ✅ (role_details) |
| Business Address | ❌ | ✅ (role_details) |
| ID Type | ❌ | ✅ (account_details) |
| ID Number | ❌ | ✅ (account_details) |
| TIN Number | ❌ | ✅ (both screens) |

---

## Data Flow

### Individual Advertiser
```
role_details.dart (7 fields)
  ↓
account_details.dart Step 1 (3 fields)
  ↓
account_details.dart Step 2 (6 fields)
  ↓
SignUpRequest with role='USER', accountType='INDIVIDUAL', advertiserInfo=null
```

### Business Advertiser
```
role_details.dart (7 fields)
  ↓
account_details.dart Step 1 (3 fields)
  ↓
account_details.dart Step 2 (9 fields)
  ↓
SignUpRequest with role='USER', accountType='BUSINESS', advertiserInfo={...}
```

---

## Current Issue: LGA Dropdown Not Showing

The LGA dropdown should appear when:
1. Country = "Nigeria" 
2. State is selected

Debug indicators added to help diagnose:
- Console logs showing state selection and LGA count
- Blue debug box showing state and LGA count

Check console output when selecting a state to see if `NigerianStatesAndLGA.getStateLGAs()` returns data.
