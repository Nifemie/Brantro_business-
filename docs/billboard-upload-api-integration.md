# Billboard Upload API Integration

## API Endpoint
`POST /api/v1/location`

## Request Payload
```json
{
  "title": "Wuse Billboard",
  "type": "SCREEN",
  "categoryId": 2,
  "description": "LED screen in Wuse Zone 6",
  "features": "long lines text",
  "specifications": "Long line text",
  "thumbnail": "https://www.vistarmedia.com/hubfs/how-much-does-a-billboard-cost.jpeg",
  "videoClip": "https://uploadedVideoUrl.com/s.mp4",
  "address": "Zone 6, Wuse",
  "city": "Abuja",
  "state": "FCT",
  "country": "Nigeria",
  "rateAmount": 2500,
  "rateUnit": "DAY",
  "totalSlots": 24
}
```

## Field Specifications

### Required Fields
- `title` (string) - Billboard title
- `type` (enum) - Must be one of: BILLBOARD, SCREEN, WALL
- `categoryId` (integer) - Category ID from /api/v1/category/list
- `description` (string) - Billboard description
- `thumbnail` (string) - URL of uploaded thumbnail image
- `address` (string) - Street address
- `city` (string) - City name
- `state` (string) - State name
- `country` (string) - Country name
- `rateAmount` (number) - Price amount
- `rateUnit` (enum) - SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, HALF_YEAR, YEAR
- `totalSlots` (integer) - Number of available slots

### Optional Fields
- `features` (string) - Billboard features
- `specifications` (string) - Technical specifications
- `videoClip` (string) - URL of uploaded video clip

## Files Created

### 1. Billboard Repository
**File:** `lib/features/billboard/data/repositories/billboard_repository.dart`
- Handles API call to upload billboard
- Method: `uploadBillboard(Map<String, dynamic> data)`
- Returns uploaded billboard data

## Files Updated

### 1. Upload Billboard Form
**File:** `lib/features/billboard/presentation/widgets/upload_billboard_form.dart`
- Removed: latitude, longitude fields
- Added: specifications field, video clip upload
- Changed: category from string to categoryId (int)
- Updated: type options to BILLBOARD, SCREEN, WALL
- Updated: rate units to match API enum values
- Features and specifications are now optional

### 2. Upload Billboard Screen
**File:** `lib/features/billboard/presentation/screens/upload_billboard_screen.dart`
- Updated form data structure to match API
- Changed category validation to use categoryId
- Added video clip state management
- Removed latitude/longitude controllers

### 3. Billboard Provider
**File:** `lib/features/billboard/logic/billboard_provider.dart`
- Added repository dependency
- Added `uploadBillboard()` method
- Integrated with billboard repository

## Form Fields Summary

### Billboard Information
1. Title (required)
2. Type (required) - BILLBOARD, SCREEN, WALL
3. Category (required) - Dynamic from API
4. Description (required)
5. Features (optional)
6. Specifications (optional)

### Location
7. Country (required)
8. State (required)
9. City (required)
10. Address (required)

### Pricing
11. Rate Amount (required)
12. Rate Unit (required) - SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, HALF_YEAR, YEAR

### Media
13. Thumbnail Image (required)
14. Video Clip (optional)

### Slots
15. Total Slots (required)

## Next Steps
1. Implement file upload service for thumbnail and video
2. Upload files to server and get URLs
3. Use uploaded URLs in the API payload
4. Add progress indicator for file uploads
5. Handle upload errors gracefully
