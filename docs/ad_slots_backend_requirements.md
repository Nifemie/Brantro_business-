# Ad Slots Backend Requirements

**Date:** February 9, 2026  
**Status:** ✅ Fully Implemented - Backend Working

---

## Current Implementation Status

### ✅ **Fully Implemented & Working:**

1. **Endpoints:**
   - `GET /api/v1/adslots/list` - List all ad slots
   - `GET /api/v1/adslots/search` - Search ad slots
   - `GET /api/v1/adslots/details/:id` - Get ad slot details
   - `POST /api/v1/adslots` - Create new ad slot

2. **Data Models:**
   - `AdSlot` - Complete ad slot structure
   - `Platform` - Social media platforms
   - `AdSlotsResponse` - Paginated response

3. **Features:**
   - Pagination support
   - Search functionality
   - Partner type filtering (Artist, Billboard, TV, Radio, etc.)
   - User information included
   - Coverage areas
   - Audience size

---

## Backend API Specification

### **1. List Ad Slots** ✅ Working
**Endpoint:** `GET /api/v1/adslots/list`

**Query Parameters:**
```
?page=0&size=20
```

**Current Response Format:**
```json
{
  "success": true,
  "message": "Ad slots retrieved successfully",
  "payload": {
    "page": [
      {
        "id": 123,
        "userId": 456,
        "title": "Billboard on Lekki-Epe Expressway",
        "description": "Prime billboard location with high traffic",
        "features": [
          "High visibility",
          "24/7 exposure",
          "LED lighting"
        ],
        "partnerType": "BILLBOARD",
        "platforms": [
          {
            "name": "Instagram",
            "handle": "@username"
          }
        ],
        "contentTypes": ["image", "video"],
        "price": "50000.00",
        "duration": "7 days",
        "maxRevisions": 2,
        "isActive": true,
        "coverageAreas": ["Lekki", "Victoria Island"],
        "audienceSize": "500000",
        "timeWindow": "6am - 10pm",
        "status": "ACTIVE",
        "user": {
          "id": 456,
          "name": "John Doe",
          "avatarUrl": "https://...",
          "role": "BILLBOARD_OWNER"
        },
        "createdAt": "2024-01-27T10:30:00Z",
        "updatedAt": "2024-01-27T10:30:00Z"
      }
    ],
    "currentPage": 0,
    "size": "20",
    "totalPages": 5
  }
}
```

**Partner Types:**
- `ARTIST` - Musicians, singers
- `BILLBOARD` - Billboard owners
- `TV_STATION` - TV stations
- `RADIO_STATION` - Radio stations
- `DIGITAL_SCREEN` - Digital screen owners
- `INFLUENCER` - Social media influencers
- `PRODUCER` - Content producers
- `UGC_CREATOR` - UGC creators
- `MEDIA_HOUSE` - Media houses

---

### **2. Search Ad Slots** ✅ Working
**Endpoint:** `GET /api/v1/adslots/search`

**Query Parameters:**
```
?q=billboard&page=0&size=20
```

**Response:** Same format as list endpoint

**Search Criteria:**
- Title
- Description
- Partner type
- Location (coverage areas)
- Features

---

### **3. Get Ad Slot Details** ✅ Working
**Endpoint:** `GET /api/v1/adslots/details/:id`

**Example:** `GET /api/v1/adslots/details/123`

**Response:**
```json
{
  "success": true,
  "message": "Ad slot details retrieved",
  "payload": {
    // Same structure as single ad slot above
  }
}
```

---

### **4. Create Ad Slot** ✅ Working
**Endpoint:** `POST /api/v1/adslots`

**Request Body:**
```json
{
  "title": "Billboard on Lekki-Epe Expressway",
  "description": "Prime billboard location with high traffic",
  "features": [
    "High visibility",
    "24/7 exposure",
    "LED lighting"
  ],
  "partnerType": "BILLBOARD",
  "platforms": [
    {
      "name": "Instagram",
      "handle": "@username"
    }
  ],
  "contentTypes": ["image", "video"],
  "price": "50000.00",
  "duration": "7 days",
  "maxRevisions": 2,
  "coverageAreas": ["Lekki", "Victoria Island"],
  "audienceSize": "500000",
  "timeWindow": "6am - 10pm"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Ad slot created successfully",
  "payload": {
    // Complete ad slot object
  }
}
```

---

## Data Model Details

### **AdSlot Object:**
```typescript
{
  id: number,                    // Unique identifier
  userId: number,                // Owner's user ID
  title: string,                 // Ad slot title
  description: string,           // Detailed description
  features: string[],            // List of features
  partnerType: string,           // Type of partner (BILLBOARD, ARTIST, etc.)
  platforms: Platform[],         // Social media platforms
  contentTypes: string[],        // Accepted content types
  price: string,                 // Price in Naira
  duration: string,              // Duration (e.g., "7 days")
  maxRevisions: number,          // Maximum revisions allowed
  isActive: boolean,             // Is slot active?
  coverageAreas: string[],       // Geographic coverage
  audienceSize: string,          // Estimated audience reach
  timeWindow: string | null,     // Time window for display
  status: string,                // Status (ACTIVE, INACTIVE, etc.)
  user: {                        // Owner information
    id: number,
    name: string,
    avatarUrl: string,
    role: string
  },
  createdAt: string,             // ISO 8601 datetime
  updatedAt: string              // ISO 8601 datetime
}
```

### **Platform Object:**
```typescript
{
  name: string,      // Platform name (Instagram, Twitter, etc.)
  handle: string     // User handle (@username)
}
```

---

## Frontend Usage

### **Fetching Ad Slots:**
```dart
// Auto-loads on app start
final adSlotState = ref.watch(adSlotProvider);

// Manual refresh
ref.read(adSlotProvider.notifier).loadAdSlots(refresh: true);

// Load more (pagination)
ref.read(adSlotProvider.notifier).loadMore();

// Search
ref.read(adSlotProvider.notifier).searchAdSlots(query: 'billboard');

// Filter by partner type
final billboards = ref.read(adSlotProvider.notifier)
    .getAdSlotsByPartnerType('BILLBOARD');
```

### **State Properties:**
```dart
adSlotState.data              // List<AdSlot>
adSlotState.isInitialLoading  // bool
adSlotState.isPaginating      // bool
adSlotState.isDataAvailable   // bool
adSlotState.message           // String? (error message)
adSlotState.currentPage       // int
adSlotState.totalPages        // int
```

---

## Error Handling

### **Backend Should Return:**

**Success Response:**
```json
{
  "success": true,
  "message": "Success message",
  "payload": { /* data */ }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error message",
  "payload": null
}
```

**Empty Result:**
```json
{
  "success": true,
  "message": "No ad slots available",
  "payload": {
    "page": [],
    "currentPage": 0,
    "size": "20",
    "totalPages": 0
  }
}
```

### **Frontend Error Handling:**
Frontend converts technical errors to user-friendly messages:
- Network errors → "No internet connection"
- Timeout → "Request timed out"
- 401 → "Session expired. Please log in again"
- 404 → "Resource not found"
- 500/502/503 → "Server error. Please try again later"

---

## Pagination

**How it works:**
1. Frontend requests page 0 with size 20
2. Backend returns 20 items + pagination info
3. User scrolls to bottom
4. Frontend requests page 1
5. Backend returns next 20 items
6. Frontend appends to existing list

**Pagination Info:**
- `currentPage`: Current page number (0-indexed)
- `size`: Items per page
- `totalPages`: Total number of pages
- `hasMore`: Calculated as `currentPage < totalPages - 1`

---

## Search Functionality

**Search Query Parameter:** `q`

**Example:**
```
GET /api/v1/adslots/search?q=billboard&page=0&size=20
```

**Backend Should Search:**
- Title (case-insensitive)
- Description (case-insensitive)
- Partner type
- Coverage areas
- Features

---

## Status Values

**Ad Slot Status:**
- `ACTIVE` - Available for booking
- `INACTIVE` - Not available
- `PENDING` - Awaiting approval
- `SUSPENDED` - Temporarily suspended
- `DELETED` - Soft deleted

---

## Security Requirements

Backend MUST:
- ✅ Authenticate users with Bearer token
- ✅ Only allow owners to edit/delete their ad slots
- ✅ Validate all input data
- ✅ Sanitize search queries
- ✅ Rate limit API calls
- ✅ Log all create/update/delete operations

---

## Performance Considerations

**Backend Should:**
- ✅ Index frequently searched fields (title, partnerType, coverageAreas)
- ✅ Cache popular ad slots
- ✅ Optimize pagination queries
- ✅ Include user data in single query (avoid N+1)
- ✅ Compress large responses

---

## Testing Checklist

### **Backend:**
- [ ] List endpoint returns paginated results
- [ ] Search endpoint filters correctly
- [ ] Details endpoint returns single ad slot
- [ ] Create endpoint validates input
- [ ] Empty results return proper structure
- [ ] Pagination works correctly
- [ ] User information is included
- [ ] Bearer token authentication works

### **Frontend:**
- [x] Ad slots display on home screen
- [x] Pagination loads more items
- [x] Search filters results
- [x] Partner type filtering works
- [x] Error messages display correctly
- [x] Empty state shows friendly message
- [x] Loading states display
- [x] Details screen shows full info

---

## Summary

### **✅ What's Working:**
All ad slot endpoints are implemented and working:
- List ad slots with pagination
- Search ad slots
- Get ad slot details
- Create new ad slots

### **✅ What Frontend Has:**
- Complete data models
- State management with Riverpod
- Pagination support
- Search functionality
- Error handling
- Loading states
- Empty states

### **No Action Needed:**
Backend is fully functional for ad slots. All endpoints are working as expected.

---

## Contact

**Frontend Lead:** [Your Name]  
**Backend Lead:** [Backend Team Lead]  
**Status:** ✅ Fully Implemented  
**Last Updated:** February 9, 2026
