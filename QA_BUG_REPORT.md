# Brantro Mobile App QA Bug Report

**Source Document:** Brantro QA findings · 22–23 Oct 2026  
**Tester:** Ezeocha Obioma (Android phone, mobile build)  
**Testing Window:** Thu 22 Oct 2026, 11:42 → Fri 23 Oct 2026, 21:02  
**Report Date:** 24 Oct 2026  

---

## Executive Summary

| Total Findings | Blockers | Major | Minor | Observations |
| :---: | :---: | :---: | :---: | :---: |
| **15** | 5 | 4 | 5 | 1 |

### Key Highlights
1. **Registration breaks on the final step:** Host and Designer sign-ups were rejected by the server with raw validation errors complaining that required fields were empty even when filled by the user.
2. **Creation flows blocked by missing category data:** *Upload Service* and *Upload Billboard* have empty/unusable categories, and *Create Ad Slot* fails across all coverage areas.
3. **Weak input validation and unhelpful error messages:** IDs, TIN, phone number, and email accept placeholder/junk values. Server failures expose raw validation messages or generic "unexpected error" banners.

---

## All Findings at a Glance

| ID | Finding / Issue Summary | Area | Reported | Severity | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **BUG-01** | Host registration fails with raw server errors | Registration | Thu 11:50 | 🔴 **BLOCKER** | [x] **Fixed** |
| **BUG-02** | Designer sign-up reports every creative field as empty | Registration | Fri 12:23 | 🔴 **BLOCKER** | [x] **Fixed** |
| **BUG-03** | ID/RC, TIN, and permit numbers accept anything | Registration | Thu 11:45, Fri 20:53 | 🟠 **MAJOR** | [x] **Fixed** |
| **BUG-04** | Phone and email accept placeholder values | Registration | Thu 11:48 | 🟡 **MINOR** | [x] **Fixed** |
| **BUG-05** | Placeholder text cut off (`"Or type cu…"`) | Registration | Thu 11:42, Fri 20:53 | 🟡 **MINOR** | [x] **Fixed** |
| **BUG-06** | OTP boxes highlight the wrong digit position | Registration | Fri 20:51 | 🟡 **MINOR** | [x] **Fixed** |
| **BUG-07** | Placeholder profile images look unprofessional | Profile | Thu 12:28 | 🟡 **MINOR** | [x] **Fixed** |
| **BUG-08** | Share Profile does nothing | Profile | Fri 21:02 | 🟠 **MAJOR** | [x] **Fixed** |
| **BUG-09** | Upload Service: categories empty, Type/Category model unclear | Services | Thu 12:32 | 🔴 **BLOCKER** | [ ] Open |
| **BUG-10** | Upload Billboard: "No categories", upload rejected | Services | Fri 20:57 | 🔴 **BLOCKER** | [ ] Open |
| **BUG-11** | Upload Billboard has no required/optional markers | Services | Fri 20:58 | 🟡 **MINOR** | [ ] Open |
| **BUG-12** | Country picker lists only Nigeria | Services | Fri 20:59 | ⚪ **OBSERVATION** | [ ] Open |
| **BUG-13** | Create Ad Slot fails for every coverage area | Ad slots | Thu 12:37 | 🔴 **BLOCKER** | [x] **Fixed** |
| **BUG-14** | Campaign approval screen visible (possible role leak) | Access | Thu 12:38 | 🟠 **MAJOR** | [x] **Fixed** |
| **BUG-15** | Support opens a number that is not on WhatsApp | Support | Thu 18:01 | 🟠 **MAJOR** | [x] **Fixed** |
| **BUG-16** | Comma thousands separator for rate & pricing inputs | Locations & Services | Thu 09:30 | 🟡 **MINOR** | [x] **Fixed** |

---

## Detailed Findings

### 1. Registration & Onboarding

#### [x] BUG-01: Host registration fails with raw server errors
* **Severity:** 🔴 **BLOCKER**
* **Area:** Registration (`Screen / Billboard host` → `Account Details`, final step)
* **Reported:** Thu 22 Oct, 11:50 (Ref: `WA0385`)
* **Status:** Fixed
* **User Feedback:** *"Issue with submission"*
* **What Happened:**
  * Pressing the final submission button shows a red banner with raw, unformatted server error text and no account is created:
    ```text
    hostInfo.operatingCities should not be empty, hostInfo.yearsOfOperation must be a number, hostInfo.idNumber should not be empty.
    ```
* **Inference:**
  * The Billboard Details step displays "Operating States" (e.g. chip: *Sokoto*) while the server expects `operatingCities`.
  * An ID number was entered earlier in the wizard, but the form values appear not to reach the final payload sent in the request.
* **Suggested Fix:**
  * Ensure values captured in the Billboard Details step are properly mapped and preserved into the registration request payload.
  * Omit or default optional fields that are empty.
  * Map backend validation errors into field-level UI error messages instead of a raw top banner.

---

#### [x] BUG-02: Designer sign-up reports every creative field as empty
* **Severity:** 🔴 **BLOCKER**
* **Area:** Registration (`Creative → Designer` · `Designer Details → Account Details`)
* **Reported:** Fri 23 Oct, 12:23–12:34 (Refs: `WA0579`, `WA0586`, `WA0587`)
* **Status:** Fixed
* **User Feedback:** *"In the designer category"*, *"Used single answer"*
* **What Happened:**
  * Submitting returns a red banner stating:
    ```text
    creativeInfo.displayName, creativeType, specialization, toolsUsed and skills "should not be empty"
    ```
  * Even when all 5 fields were filled in (and retried with single values in comma-separated inputs), the exact same error was returned.
* **Note:**
  * Follows the same pattern as BUG-01 where wizard form state fails to reach the final API payload.
  * Re-test on current build since Friday evening creative sign-ups succeeded.
* **Suggested Fix:**
  * Verify payload serialization in the multi-step signup state handler for Creative/Designer roles.

---

#### [x] BUG-03: ID/RC, TIN, and permit numbers accept anything
* **Severity:** 🟠 **MAJOR**
* **Area:** Registration (`Host registration`)
* **Reported:** Thu 22 Oct 11:45–11:46, Fri 23 Oct 20:52–20:53 (Refs: `WA0381`, `WA0382`, `WA1081`)
* **Status:** Fixed
* **User Feedback:** *"ID/RC should have a minimum/maximum values it should accept. The same goes for TIN."*, *"no verification of the tin or rc numbers"*
* **What Happened:**
  * ID/RC number accepted `a`.
  * TIN accepted `1` and `6`.
  * Permit number accepted `pp`.
  * Mall/Retail host with ID type NIN succeeded with ID `y` and TIN `6`.
* **Suggested Fix:**
  * Enforce strict client-side format and length validation per ID type before allowing step progression (e.g., NIN must be exactly 11 digits, TIN numeric, RC format).

---

#### [x] BUG-04: Phone and email accept placeholder values
* **Severity:** 🟡 **MINOR**
* **Area:** Registration (`Account Details`, step 1 of 2)
* **Reported:** Thu 22 Oct, 11:48 (Ref: `WA0384`)
* **Status:** Fixed
* **User Feedback:** *"Maybe a state machine that verifies that the input is either 080, 081, 090, 091, etc"*
* **What Happened:**
  * Dummy phone numbers such as `00000000000` passed validation.
  * Incomplete/placeholder emails like `0@gmail.com` were accepted.
* **Suggested Fix:**
  * Validate phone numbers against valid Nigerian telecommunication prefixes (070, 080, 081, 090, 091, etc.) and ensure 10–11 digits.
  * Disallow trivial repeated sequences (e.g., all zeroes) and enforce stricter regex on emails.

---

#### [x] BUG-05: Placeholder text cut off (`"Or type cu…"`)
* **Severity:** 🟡 **MINOR**
* **Area:** Registration (`Host registration`)
* **Reported:** Thu 22 Oct 11:42, Fri 23 Oct 20:53 (Refs: `WA0380`, `WA1081`)
* **Status:** Fixed
* **User Feedback:** *"Placeholder text is not complete due to insufficient space"*
* **What Happened:**
  * The custom-entry text box beside "Add more..." is too narrow for its placeholder text, resulting in truncation with ellipsis (`"Or type cu…"`).
  * Inconsistency noted: field was titled "Operating States" on Thursday and "Operating Cities" on Friday, while showing state chips (*Sokoto*).
* **Suggested Fix:**
  * Expand the text input width, adjust responsive layout, or shorten the placeholder string.
  * Clarify nomenclature between State and City consistently across forms and API fields.

---

#### [x] BUG-06: OTP boxes highlight the wrong digit position
* **Severity:** 🟡 **MINOR**
* **Area:** Registration (`Radio account sign-up, OTP step`)
* **Reported:** Fri 23 Oct, 20:51
* **Status:** Fixed
* **User Feedback:** *"When you click out, let say you are in the fourth digit. It shows like it's the second, causing confusion when typing"*
* **What Happened:**
  * When unfocusing/tapping out and tapping back into the OTP input, focus indicator highlights an incorrect cell index (e.g. 2nd digit instead of 4th).
* **Suggested Fix:**
  * Update OTP / PIN input controller to synchronize cursor position and focus state with the actual string length.

---

### 2. Profile Management

#### [x] BUG-07: Placeholder profile images look unprofessional
* **Severity:** 🟡 **MINOR**
* **Area:** Profile (`Edit Profile`)
* **Reported:** Thu 22 Oct, 12:28 (Ref: `WA0432`)
* **Status:** Fixed
* **User Feedback:** *"The placeholder images don't look professional"*
* **What Happened:**
  * Default avatar displayed a collage of brand logos (Wikipedia, Pepsi, Starbucks).
  * Cover photo was a random stock photo of a person.
  * "Change Cover" button was partially obscured behind the avatar badge.
* **Fix Applied:**
  * Replaced avatar placeholder with neutral, clean icon/asset.
  * Replaced random stock cover photo with blank/neutral container featuring a centered camera upload icon (`Icons.camera_alt_outlined` + "Add Cover Photo") when no image is uploaded.
  * Moved "Change Cover" button to top-right glassmorphic badge, displayed when an image exists.

---

#### [ ] BUG-08: Share Profile does nothing
* **Severity:** 🟠 **MAJOR**
* **Area:** Profile (`Profile (Host A)`)
* **Reported:** Fri 23 Oct, 21:02 (Ref: `WA1095`)
* **User Feedback:** *"Share profile isn't working"*
* **What Happened:**
  * Tapping "Share Profile" from the profile action menu triggers no action or system share dialog.
* **Suggested Fix:**
  * Hook up the action using `share_plus` to generate and share the profile deep link or summary card.

---

### 3. Services & Uploads

#### [ ] BUG-09: Upload Service: categories empty, Type/Category model unclear
* **Severity:** 🔴 **BLOCKER**
* **Area:** Services (`Upload Service`)
* **Reported:** Thu 22 Oct, 12:32–12:34 (Refs: `WA0494`, `WA0427`, `WA0414`)
* **User Feedback:** *"Writing doesn't have its content like the other categories"*, *"Category is blank"*, *"Maybe audio is the type and what's under is the category"*, *"Can't do more tests on upload service"*
* **What Happened:**
  * Selecting a Type (e.g. *Jingle Production*) opens an empty Category sheet, blocking upload completion.
  * Type list is grouped under *Audio*, *Design*, *Writing*, but the *Writing* group had no items.
* **Suggested Fix:**
  * Realign hierarchy: Group (*Audio*, *Design*, *Writing*) should be the Type; specific items (*Voice Over*, *Jingle Production*) should be Categories.
  * Populate items for the *Writing* category.

---

#### [ ] BUG-10: Upload Billboard: "No categories", upload rejected
* **Severity:** 🔴 **BLOCKER**
* **Area:** Services (`Upload Billboard (host)`)
* **Reported:** Fri 23 Oct, 20:57–21:00 (Refs: `WA1082`, `WA1093`)
* **User Feedback:** *"No category in the host section"*
* **What Happened:**
  * Category dropdown shows "No categories".
  * Submitting anyway returns red error banner:
    ```text
    Upload failed: An unexpected error occurred: The selected category is not valid.
    ```
* **Suggested Fix:**
  * Ensure billboard categories are fetched reliably from API or provided via local fallback constants if backend returns empty.
  * Validate selection before allowing submission.

---

#### [x] BUG-11: Upload Billboard has no required/optional markers
* **Severity:** 🟡 **MINOR**
* **Area:** Services (`Upload Billboard (host)`)
* **Reported:** Fri 23 Oct, 20:58 (Ref: `WA1082`)
* **Status:** Fixed
* **User Feedback:** *"there is no sign to show what is compulsory or not"*
* **What Happened:**
  * Labels like *Title*, *Type*, *Category*, and *Description* lack visual indicators (red `*` or `(Optional)`).
* **Fix Applied:**
  * Audited OpenAPI Swagger specification for `LocationDto` (`POST /api/v1/location`) and `ServiceDto` (`POST /api/v1/service`).
  * Cross-checked mandatory fields: `title`, `categoryId`, `description`, `features`, `specifications`, `address`, `city`, `state`, `country`, `rate`, `rateUnit`, `videoClip`, and `thumbnail`.
  * Cross-checked optional fields: `class`, `estimatedReach`, `latitude`, `longitude`, and `gallery`.
  * Implemented `_buildFieldLabel` across all location upload forms ([`upload_billboard_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/billboard/presentation/widgets/upload_billboard_form.dart), [`upload_screen_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/screen/presentation/widgets/upload_screen_form.dart), [`upload_wall_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/wall/presentation/widgets/upload_wall_form.dart), [`upload_vehicle_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/vehicle/presentation/widgets/upload_vehicle_form.dart)) and service forms ([`media_upload_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/services/presentation/screen/upload_service/widgets/media_upload_form.dart), [`attributes_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/services/presentation/screen/upload_service/widgets/attributes_form.dart)).
  * Mandatory fields clearly display a bold red asterisk (`*`), and non-mandatory fields display `(Optional)` in subtle secondary text.
  * Updated `_validateForm()` in [`upload_billboard_screen.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/billboard/presentation/screens/upload_billboard_screen.dart) to stop blocking submission on optional `class` and guarantee fallback array serialization for `coverageAreas`.

---

#### [ ] BUG-12: Country picker lists only Nigeria
* **Severity:** ⚪ **OBSERVATION**
* **Area:** Services (`Upload Billboard (host)`)
* **Reported:** Fri 23 Oct, 20:59 (Ref: `WA1090`)
* **What Happened:**
  * "Select Country" bottom sheet lists only Nigeria.
* **Context:**
  * Previous specifications mentioned international support / zip codes for non-Nigerian users.
* **Suggested Fix:**
  * Clarify product requirement: if currently Nigeria-only by design, confirm whether this is intentional or if international country list should be populated.

---

### 4. Ad Slots

#### [x] BUG-13: Create Ad Slot fails for every coverage area
* **Severity:** 🔴 **BLOCKER**
* **Area:** Ad slots (`Create Slot`)
* **Reported:** Thu 22 Oct, 12:37 (Refs: `WA0428`, `WA0417`, `WA0404`, `WA0418`)
* **Status:** Fixed
* **User Feedback:** *"Couldn't submit"*
* **What Happened:**
  * With duration, audience size, and time window filled, all 4 coverage options (*National*, *State · Ekiti*, *City · Ebonyi / Izzi*, *Online / Global*) fail with:
    ```text
    Failed to create ad slot: An unexpected error occurred. Please try again later.
    ```
* **Fix Applied:**
  * Added mandatory `contentRequirements` multiselect input (from `AdSlotConstants.contentRequirementOptions`) and guaranteed fallback requirements if left blank.
  * Added explicit `adFormat` dropdown selector.
  * Realigned `coverageAreas` to serialize as a full array `List<String>` matching Swagger `AdSlotDto` schema, alongside string `coverageArea`.
  * Added description mandatory validation to prevent 400 Bad Request rejections.
  * Updated repository to handle direct `{id: ...}` entity responses as well as wrapped `{success: true, payload: ...}` payloads.

---

### 5. Access & Support

#### [x] BUG-14: Campaign approval screen visible (possible role leak)
* **Severity:** 🟠 **MAJOR**
* **Area:** Access (`ARD Campaigns`)
* **Reported:** Thu 22 Oct, 12:38 (Ref: `WA0405`)
* **Status:** Fixed
* **User Feedback:** *"Why am I able to see this?"*
* **What Happened:**
  * A campaign screen opened showing a list of campaigns with live "Approve" and "Cancel" buttons for a ₦5,625,000 campaign.
* **Fix Applied:**
  * Removed the misplaced "Approve" and "Cancel" action buttons and approval dialog stubs from `AdCampaignCard` and `AdCampaignScreen`.
  * Campaign approval belongs to the main/admin application; in this business app, campaigns are strictly read-only with a clean "View Details" button to inspect campaign and placement details safely.

---

#### [x] BUG-16: Comma thousands separator for rate & pricing inputs
* **Severity:** 🟡 **MINOR**
* **Area:** Locations & Services (`Upload Billboard`, `Upload Screen`, `Upload Wall`, `Upload Vehicle`, `Upload Service`)
* **Reported:** Thu 29 Oct, 09:30
* **Status:** Fixed
* **User Feedback:** *"while entering amount when you want to upload a location separate it with comma, thousands"*
* **Fix Applied:**
  * Created [`ThousandsSeparatorInputFormatter`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/core/utils/thousands_separator_input_formatter.dart) to format amounts with commas dynamically in real-time as the user types (e.g. `1,000`, `50,000`, `1,000,000.50`).
  * Intelligent cursor positioning logic ensures the cursor does not jump to the end or beginning when typing or editing numbers in the middle.
  * Applied to all location rate amount inputs: [`upload_billboard_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/billboard/presentation/widgets/upload_billboard_form.dart), [`upload_screen_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/screen/presentation/widgets/upload_screen_form.dart), [`upload_wall_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/wall/presentation/widgets/upload_wall_form.dart), [`upload_vehicle_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/vehicle/presentation/widgets/upload_vehicle_form.dart), as well as service price/discount inputs in [`pricing_delivery_form.dart`](file:///c:/Users/USER/Desktop/BRANTRO%20APPS/brantro_busi_app/lib/features/services/presentation/screen/upload_service/widgets/pricing_delivery_form.dart).
  * Safely stripped commas using `ThousandsSeparatorInputFormatter.tryParseDouble` and `tryParseInt` in all upload and edit screen handlers so APIs receive clean numbers without serialization errors.

