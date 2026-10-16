# BRANTRO Business App — Pending Items Punchlist (v3)

This document contains **only the pending features, workflow gaps, and enforcement rules** that remain to be completed in the Brantro Business App, with explicit categorization of what is required from the **Backend API** vs **Frontend (Flutter App)**.

---

## 1. Role-Specific Pending Features

### 1. Influencers & Artists
* [ ] **Live Audience Analytics** `[Full-Stack Integration]`
  * **Backend Needed**: Endpoint (e.g., `GET /api/v1/analytics/summary` or aggregated stats on `GET /api/v1/user/me`) returning total connected followers, impressions, reach, and profile views.
  * **Frontend Needed**: Bind the dashboard `StatCard` widgets in `HomeScreen` and `DashboardScreen` to live data from the analytics API instead of static mock numbers (`13,647`, `₦123.6k`).

* [ ] **Audio/Video Media Sample Player** `[Full-Stack Integration]`
  * **Backend Needed**: Support array fields in `artistInfo` or `service` (e.g. `sampleTracks: string[]`, `showReels: string[]`) populated via file upload (`/api/v1/file/upload`).
  * **Frontend Needed**: Integrate Flutter audio playback controls / video preview players in the Artist profile and package details screen.

* [ ] **Appearance vs Endorsement Differentiation** `[Full-Stack Integration]`
  * **Backend Needed**: Add `offeringType` enum (`PHYSICAL_APPEARANCE`, `DIGITAL_ENDORSEMENT`, `SPONSORED_CONTENT`) and optional `riderRequirements` text field in the ad-slot / service schema.
  * **Frontend Needed**: Add an Offering Type dropdown in `CreateAdSlotForm` / `UploadServiceScreen` that reveals specialized fields (e.g., venue requirement, appearance duration, hospitality rider).

---

### 2. UGC Creators & Designers
* [ ] **Revision Request State Sync** `[Full-Stack Integration]`
  * **Backend Needed**: Endpoint for buyers to trigger `REVISION_REQUESTED` with feedback text, and endpoint for sellers to patch/replace deliverables on item (`PUT /api/v1/service-order/items/:id/delivery`).
  * **Frontend Needed**: Display incoming revision feedback banner in `OrderDetailsScreen` and allow re-opening `OrderDeliveryDialog` to upload replacement files.

* [ ] **Delivery SLA Countdown** `[Frontend Task]`
  * **Backend Needed**: Existing `deliveryDays` and `createdAt` / `startedAt` timestamps.
  * **Frontend Needed**: Render an active countdown clock/badge in `OrderCard` and `OrderDetailsScreen` comparing current time against the deadline.

---

### 3. Template Sellers
* [ ] **Source Asset vs Preview Separation** `[Backend Dependency]`
  * **Backend Needed**: Server-side storage segregation: preview image URL (`publicUrl`) is publicly accessible, while the raw template archive (`sourceFileKey` / `.zip`) is gated behind confirmed paid order permissions.
  * **Frontend Needed**: Pass distinct `previewUrl` and `sourceFileUrl` in `/upload-template`.

* [ ] **Individual Template Analytics** `[Full-Stack Integration]`
  * **Backend Needed**: Template metrics endpoint (`GET /api/v1/template/:id/stats` or fields on template model: `viewsCount`, `salesCount`, `revenue`).
  * **Frontend Needed**: Display sales count and revenue badges on each card in `TemplateMarketplaceScreen`.

---

### 4. Radio & TV Stations
* [ ] **Broadcast Schedule / Time-Band Grid** `[Full-Stack Integration]`
  * **Backend Needed**: Time-band schema (e.g., `timeBand: 'MORNING_DRIVE' | 'MID_DAY' | 'PRIME_TIME' | 'LATE_NIGHT'`, `maxSlotsPerBand: number`, `bookedSlots: number`).
  * **Frontend Needed**: Time-band selector in airtime slot creation form and visual slot availability badge.

* [ ] **Broadcast Compliance Proof** `[Frontend Task]`
  * **Backend Needed**: Upload endpoint already supports file keys via `/api/v1/file/upload` and proof endpoint `/api/v1/ad-proofs`.
  * **Frontend Needed**: Add dedicated audio file (`.mp3`/`.wav`) and log document (`.pdf`/`.csv`) selectors in `OrderDeliveryDialog`.

---

### 5. Out-of-Home Providers (Billboard, Digital Screen, Wall, Vehicle)
* [ ] **Interactive Availability & Blocked Dates Calendar** `[Full-Stack Integration]`
  * **Backend Needed**: Endpoints to block/unblock date ranges for a location (`POST /api/v1/location/:id/blocked-dates`, `GET /api/v1/location/:id/availability`).
  * **Frontend Needed**: Interactive calendar widget on `BillboardDetailsScreen` / `ScreenDetailsScreen` allowing hosts to tap dates and toggle maintenance/offline state.

* [ ] **Digital Screen Loop & Timeslot Configuration** `[Full-Stack Integration]`
  * **Backend Needed**: Fields in screen metadata: `loopDurationSeconds` (e.g. 60), `spotDurationSeconds` (e.g. 10), `maxSpots` (e.g. 6), `operatingHours` (e.g. `06:00-23:00`).
  * **Frontend Needed**: Add loop frequency and operating hours input fields in `UploadScreenScreen`.

---

## 2. Core Subsystem & Security Pendings

### 1. Progressive Seller KYC Gate Enforcement
* [ ] **Listing Creation Interception** `[Frontend Task]`
  * **Backend Needed**: KYC status endpoint (`GET /api/v1/kyc/status`) is already live.
  * **Frontend Needed**: Check `ref.read(kycProvider).verificationStatus` before navigating to upload screens. If not `APPROVED`, redirect to `KycGateScreen` (`/kyc/gate`).

* [ ] **Withdrawal Interception** `[Frontend Task]`
  * **Backend Needed**: Backend will reject withdrawal attempts without approved KYC.
  * **Frontend Needed**: Display KYC gate modal inside `/wallet/withdraw` if user status is unverified.

* [ ] **Rejection Feedback & Resubmission** `[Full-Stack Integration]`
  * **Backend Needed**: Ensure `GET /api/v1/kyc/status` returns the `rejectionReason` string when status is `REJECTED`.
  * **Frontend Needed**: Render rejection reason in a red alert box on `KycLandingScreen` / `KycVerificationScreen` with a direct "Resubmit Documents" CTA.

---

### 2. Multi-Role Provider Dynamic Navigation `[Frontend Task]`
* [ ] **Multi-Role Module Resolution**:
  * **Backend Needed**: User object returns array of roles or permissions (e.g., `roles: ['HOST', 'INFLUENCER']` or comma-separated string).
  * **Frontend Needed**: Refactor `isHost`, `isInfluencer`, `isCreator` boolean checks in `DashboardShell` and `QuickActionsSection` to evaluate `roles.contains(...)` so multi-role accounts see tools for all their registered personas.

---

### 3. Orders & Proof Workflow
* [ ] **Complete Status Loop & Wallet Release** `[Backend Dependency]`
  * **Backend Needed**: When buyer calls `/api/v1/ad-placements/:id/complete` or service order complete, backend automatically credits the provider's wallet balance.
  * **Frontend Needed**: Already listens to order status updates and displays corresponding buttons (`Accept`, `Update Progress`, `Submit Final Work`).

---

### 4. Wallet & Withdrawal Validations `[Frontend Task]`
* [ ] **Verified Payout Account Check**:
  * **Backend Needed**: `GET /api/v1/wallet/withdrawal-account/list` returns accounts with `isDefault` and verification status.
  * **Frontend Needed**: In `/wallet/withdraw`, disable the submit button and show a helper notice if no default verified bank account is linked.
* [ ] **Submit Button Debouncing**:
  * **Frontend Needed**: Add loading state and disable submit button during withdrawal API call to prevent double submissions.
