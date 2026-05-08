# Category API Integration Summary

## Overview
Integrated the category API endpoint `/api/v1/category/list` to dynamically fetch categories from the backend instead of using hardcoded values.

## Files Created

### 1. Category Model
**File:** `lib/core/data/models/category_model.dart`
- Represents category data from API
- Fields: id, name, type, description, status, createdById, createdAt, updatedAt
- Includes fromJson and toJson methods

### 2. Category Repository
**File:** `lib/core/data/repositories/category_repository.dart`
- Handles API calls for categories
- Methods:
  - `getCategories()` - Fetch all categories with pagination
  - `getLocationCategories()` - Filter by type='LOCATION'
  - `getTemplateCategories()` - Filter by type='TEMPLATE'

### 3. Category Provider
**File:** `lib/core/logic/category_provider.dart`
- Riverpod state management for categories
- CategoryState holds:
  - All categories
  - Location categories (Billboard, Digital Screen, Wall Location, Keke Napep)
  - Template categories (Canva Templates, Radio & TV Creatives, etc.)
  - Loading state
  - Error state
- Auto-loads categories on initialization

## Files Updated

### Upload Billboard Form
**File:** `lib/features/billboard/presentation/widgets/upload_billboard_form.dart`
- Changed from StatelessWidget to ConsumerWidget
- Integrated categoryProvider
- Updated category picker to use API data
- Shows loading state while fetching
- Displays location categories dynamically

## API Response Structure
```json
{
  "success": true,
  "message": "Request successful",
  "payload": {
    "page": [
      {
        "id": 26,
        "name": "Keke Napep",
        "type": "LOCATION",
        "description": "",
        "status": "ACTIVE",
        "createdById": 9,
        "createdAt": "2026-04-01T11:52:34.575Z",
        "updatedAt": "2026-04-01T11:52:34.575Z"
      }
    ],
    "size": "10",
    "currentPage": 0,
    "totalPages": 3
  }
}
```

## Category Types
- **LOCATION**: Billboard, Digital Screen, Wall Location, Keke Napep
- **TEMPLATE**: Canva Templates, Radio & TV Creatives, Brand Kits, Flyers & Posters, Media Proposals, Pitch Decks

## Usage in Other Forms
The same category provider can be used in:
- Upload Screen Form
- Upload Wall Form
- Any other form that needs location or template categories

## Next Steps
1. Update upload screen form to use category API
2. Update upload wall form to use category API
3. Add error handling UI for failed category loads
4. Add refresh capability for categories
