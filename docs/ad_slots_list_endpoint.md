# Ad Slots List Endpoint - Backend Requirements

**Endpoint:** `GET /api/v1/adslots/list`  
**Purpose:** Return all available ad slots with pagination

---

## Request

### **URL:**
```
GET /api/v1/adslots/list?page=0&size=20
```

### **Query Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 0 | Page number (0-indexed) |
| `size` | integer | No | 20 | Items per page |

### **Headers:**
```
Authorization: Bearer <user_access_token>  (Optional - for personalized results)
Content-Type: application/json
```

---

## Response

### **Success Response (200 OK):**

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
        "description": "Prime billboard location with high traffic visibility",
        "features": [
          "High visibility",
          "24/7 exposure",
          "LED lighting"
        ],
        "partnerType": "BILLBOARD",
        "platforms": [
          {
            "name": "Instagram",
            "handle": "@billboard_owner"
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
          "avatarUrl": "https://cdn.example.com/avatar.jpg",
          "role": "BILLBOARD_OWNER"
        },
        "createdAt": "2024-01-27T10:30:00Z",
        "updatedAt": "2024-01-27T10:30:00Z"
      },
      {
        "id": 124,
        "userId": 457,
        "title": "Radio Jingle on Cool FM",
        "description": "30-second radio spot during prime time",
        "features": [
          "Prime time slot",
          "High listenership",
          "Professional voice-over"
        ],
        "partnerType": "RADIO_STATION",
        "platforms": [
          {
            "name": "Twitter",
            "handle": "@coolfm"
          }
        ],
        "contentTypes": ["audio"],
        "price": "75000.00",
        "duration": "30 seconds",
        "maxRevisions": 3,
        "isActive": true,
        "coverageAreas": ["Lagos", "Abuja"],
        "audienceSize": "2000000",
        "timeWindow": "7am - 9am, 5pm - 7pm",
        "status": "ACTIVE",
        "user": {
          "id": 457,
          "name": "Cool FM",
          "avatarUrl": "https://cdn.example.com/coolfm.jpg",
          "role": "RADIO_STATION"
        },
        "createdAt": "2024-01-26T14:20:00Z",
        "updatedAt": "2024-01-26T14:20:00Z"
      }
    ],
    "currentPage": 0,
    "size": "20",
    "totalPages": 5
  }
}
```

### **Empty Result (200 OK):**
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

### **Error Response (400/500):**
```json
{
  "success": false,
  "message": "Error message here",
  "payload": null
}
```

---

## Field Descriptions

### **Root Level:**
| Field | Type | Description |
|-------|------|-------------|
| `success` | boolean | Whether request was successful |
| `message` | string | Human-readable message |
| `payload` | object | Response data |

### **Payload Object:**
| Field | Type | Description |
|-------|------|-------------|
| `page` | array | Array of ad slot objects |
| `currentPage` | integer | Current page number (0-indexed) |
| `size` | string | Items per page |
| `totalPages` | integer | Total number of pages |

### **Ad Slot Object:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | ✅ | Unique ad slot ID |
| `userId` | integer | ✅ | Owner's user ID |
| `title` | string | ✅ | Ad slot title |
| `description` | string | ✅ | Detailed description |
| `features` | string[] | ✅ | List of features |
| `partnerType` | string | ✅ | Type of partner (see below) |
| `platforms` | Platform[] | ✅ | Social media platforms |
| `contentTypes` | string[] | ✅ | Accepted content types |
| `price` | string | ✅ | Price in Naira (e.g., "50000.00") |
| `duration` | string | ✅ | Duration (e.g., "7 days") |
| `maxRevisions` | integer | ✅ | Maximum revisions allowed |
| `isActive` | boolean | ✅ | Is slot active? |
| `coverageAreas` | string[] | ✅ | Geographic coverage |
| `audienceSize` | string | ✅ | Estimated audience reach |
| `timeWindow` | string | ❌ | Time window for display (optional) |
| `status` | string | ✅ | Status (ACTIVE, INACTIVE, etc.) |
| `user` | object | ✅ | Owner information |
| `createdAt` | string | ✅ | ISO 8601 datetime |
| `updatedAt` | string | ✅ | ISO 8601 datetime |

### **Platform Object:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | ✅ | Platform name (Instagram, Twitter, etc.) |
| `handle` | string | ✅ | User handle (@username) |

### **User Object:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | ✅ | User ID |
| `name` | string | ✅ | User's full name |
| `avatarUrl` | string | ❌ | Profile picture URL (optional) |
| `role` | string | ✅ | User role |

---

## Partner Types

Valid values for `partnerType`:
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

## Status Values

Valid values for `status`:
- `ACTIVE` - Available for booking
- `INACTIVE` - Not available
- `PENDING` - Awaiting approval
- `SUSPENDED` - Temporarily suspended

---

## Content Types

Valid values for `contentTypes`:
- `image` - Static images
- `video` - Video content
- `audio` - Audio content
- `text` - Text content

---

## Example Requests

### **Get First Page:**
```bash
GET /api/v1/adslots/list?page=0&size=20
```

### **Get Second Page:**
```bash
GET /api/v1/adslots/list?page=1&size=20
```

### **Get 50 Items:**
```bash
GET /api/v1/adslots/list?page=0&size=50
```

---

## Pagination Logic

**How Frontend Uses It:**

1. **Initial Load:**
   - Frontend calls: `GET /api/v1/adslots/list?page=0&size=20`
   - Backend returns first 20 items + pagination info

2. **Load More:**
   - User scrolls to bottom
   - Frontend calls: `GET /api/v1/adslots/list?page=1&size=20`
   - Backend returns next 20 items
   - Frontend appends to existing list

3. **Check if More:**
   - Frontend calculates: `hasMore = currentPage < totalPages - 1`
   - If `hasMore = true`, show "Load More" button
   - If `hasMore = false`, hide button

**Example:**
- Total items: 87
- Size: 20
- Total pages: 5 (pages 0, 1, 2, 3, 4)
- Page 0: items 1-20
- Page 1: items 21-40
- Page 2: items 41-60
- Page 3: items 61-80
- Page 4: items 81-87

---

## Backend Implementation Notes

### **Database Query:**
```sql
SELECT * FROM ad_slots 
WHERE status = 'ACTIVE' 
  AND isActive = true
ORDER BY createdAt DESC
LIMIT 20 OFFSET 0;
```

### **Include User Data:**
Join with users table to include owner information in single query (avoid N+1 problem).

### **Calculate Total Pages:**
```
totalPages = CEIL(totalCount / size)
```

### **Performance:**
- Index `status` and `isActive` columns
- Index `createdAt` for sorting
- Cache popular results
- Use database pagination (LIMIT/OFFSET)

---

## Testing

### **Test Cases:**

1. **✅ Normal Request:**
   - Request: `?page=0&size=20`
   - Expected: 20 items, pagination info

2. **✅ Empty Result:**
   - Request: `?page=0&size=20` (no data)
   - Expected: Empty array, totalPages = 0

3. **✅ Last Page:**
   - Request: `?page=4&size=20` (87 total items)
   - Expected: 7 items, currentPage = 4

4. **✅ Out of Range:**
   - Request: `?page=10&size=20` (only 5 pages)
   - Expected: Empty array or error

5. **✅ Large Size:**
   - Request: `?page=0&size=100`
   - Expected: Up to 100 items

---

## Summary

### **What Backend Must Return:**

✅ **Success Response:**
```json
{
  "success": true,
  "message": "Ad slots retrieved successfully",
  "payload": {
    "page": [ /* array of ad slots */ ],
    "currentPage": 0,
    "size": "20",
    "totalPages": 5
  }
}
```

✅ **Each Ad Slot Must Have:**
- Basic info (id, title, description)
- Pricing (price, duration)
- Features array
- Partner type
- Platforms array
- Content types array
- Coverage areas array
- Audience size
- Status
- Owner information (user object)
- Timestamps

✅ **Pagination Info:**
- currentPage (0-indexed)
- size (items per page)
- totalPages (total number of pages)

---

**That's it!** This is everything backend needs to implement for the List Ad Slots endpoint.
