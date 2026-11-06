# Production Readiness Audit & Remaining Checklist

This document contains a line-by-line, screen-by-screen audit of the **Brantro Business** Flutter application against the backend OpenAPI Swagger documentation (`https://api.syroltech.com/brantro/api-docs#/`) for production rollout.

---

## 1. Status of the Modules You Specifically Asked About

### A. Announcement Creation (`announcement_screen.dart` & `announcement_provider.dart`)
- **Backend Status:** **CONNECTED TO LIVE API** ✅
- **Endpoints Used:**
  - `POST /api/v1/announcement` (`ApiEndpoints.createAnnouncement`)
  - `GET /api/v1/announcement/list` (`ApiEndpoints.announcementsList`)
  - `GET /api/v1/announcement/search` (`ApiEndpoints.searchAnnouncements`)
  - `DELETE /api/v1/announcement/:id` (`ApiEndpoints.deleteAnnouncement`)
- **Payload Sent:**
  ```json
  {
    "title": "String",
    "audience": "ALL / CREATORS / INFLUENCERS / HOSTS",
    "category": "General",
    "description": "String",
    "actionText": "Optional String",
    "actionURL": "Optional String"
  }
  ```
- **Local Cache & Offline Recovery:** Fully implemented via `LocalStorageService` so announcements display instantly while syncing with the server.

---

### B. FAQ Creation (`faq_screen.dart` & `faq_provider.dart`)
- **Backend Status:** **CONNECTED TO LIVE API** ✅
- **Endpoints in Swagger:**
  - `POST /api/v1/faq` (`FaqDto` with `title`, `description`, `category`)
  - `GET /api/v1/faq/list`
  - `DELETE /api/v1/faq/:faqId`
- **Current App State:**
  - `fetchFaqs()` calls `GET /api/v1/faq/list` ✅
  - `addFaq()` calls `POST /api/v1/faq` via `FaqRepository.createFaq()` ✅
  - `deleteFaq()` calls `DELETE /api/v1/faq/:faqId` via `FaqRepository.deleteFaq()` ✅

---

### C. Add Bank / Withdrawal Account (`add_withdrawal_account_bottom_sheet.dart`)
- **Backend Status:** **CONNECTED TO LIVE API** ✅
- **Endpoints Used:**
  - `POST /api/v1/wallet/withdrawal-account` (`ApiEndpoints.withdrawalAccount`)
  - `GET /api/v1/wallet/withdrawal-account/list` (`ApiEndpoints.withdrawalAccountList`)
  - `DELETE /api/v1/wallet/withdrawal-account/:id` (`ApiEndpoints.deleteWithdrawalAccount`)
  - `PATCH /api/v1/wallet/withdrawal-account/:id/default` (`ApiEndpoints.defaultWithdrawalAccount`)
- **Payload Sent (`WithdrawalAccountDto`):**
  ```json
  {
    "bankName": "Guaranty Trust Bank (GTBank)",
    "accountNumber": "0123456789",
    "accountName": "John Doe",
    "isDefault": true
  }
  ```
- **Validation:** Enforces 10-digit NUBAN numbers, pre-validated against Nigerian commercial banks and fintechs.

---

### D. Wallet Withdrawal (`withdraw_screen.dart` & `wallet_repository.dart`)
- **Backend Status:** **CONNECTED TO LIVE API** ✅
- **Endpoint Used:**
  - `POST /api/v1/wallet/withdrawal-request` (`ApiEndpoints.withdrawalRequest`)
- **Payload Sent (`WithdrawalRequestDto`):**
  ```json
  {
    "amount": 25000.0,
    "withdrawalAccountId": 12,
    "narration": "Withdrawal to GTBank"
  }
  ```
- **Safety Gate:** Withdrawals are blocked unless the user has at least one verified bank account selected.

---

## 2. Upload & Form Creation Screens Audit

| Form Screen | Swagger DTO & Required Fields | Current State | Production Action Needed |
| :--- | :--- | :---: | :--- |
| **Billboard Upload**<br>`upload_billboard_screen.dart` | **`LocationDto`**<br>Required: `title`, `categoryId`, `description`, `videoClip`, `coverageAreas`, `features`, `specifications`, `address`, `city`, `state`, `country`, `rate`, `rateUnit` | Live | Completed ✅ (videoClip defaults to `""`) |
| **Screen Upload**<br>`upload_screen_screen.dart` | **`LocationDto`** | Live | Completed ✅ (videoClip defaults to `""`) |
| **Wall Upload**<br>`upload_wall_screen.dart` | **`LocationDto`** | Live | Completed ✅ (videoClip defaults to `""`) |
| **Vehicle Upload**<br>`upload_vehicle_screen.dart` | **`LocationDto`** | Live | Completed ✅ (videoClip defaults to `""`) |
| **Service Upload**<br>`upload_service_screen.dart` | **`ServiceDto`**<br>Required: `title`, `categoryId`, `description`, `specifications`, `coverageAreas`, `type`, `price`, `deliveryTime`, `deliveryTimeUnit`, `thumbnail` | Live | Fully complete. Matches `ServiceDto`. ✅ |
| **Creative Upload**<br>`upload_creative_screen.dart` | **`CreativeDto`**<br>Required: `title`, `categoryId`, `type`, `fileUrl` | Live | Fully complete. Matches `CreativeDto`. ✅ |
| **Template Upload**<br>`upload_template_screen.dart` | **`TemplateDto`**<br>Required: `title`, `specifications`, `categoryId` | Live | Completed ✅ (`features` list included in payload) |
| **Ad Slot Creation**<br>`create_ad_slot_form.dart` | **`AdSlotDto`**<br>Required: `title`, `description`, `features`, `platforms`, `contentTypes`, `price`, `duration`, `adFormat`, `contentRequirements` | Live | Fully complete. Matches `AdSlotDto`. ✅ |

---

## 3. Marketplace Screen CRUD Audit (Edit & Delete Operations)

| Feature | Details Screen | Edit Action | Delete Action |
| :--- | :---: | :---: | :---: |
| **Billboards** | Live API ✅ | Live Pre-fill (`isUpdate: true`) ✅ | Live API (`deleteLocation`) ✅ |
| **Screens** | Live API ✅ | Live Pre-fill (`isUpdate: true`) ✅ | Live API (`deleteLocation`) ✅ |
| **Walls** | Live API ✅ | Live Pre-fill (`isUpdate: true`) ✅ | Live API (`deleteLocation`) ✅ |
| **Vehicles** | Live API ✅ | Live Pre-fill (`isUpdate: true`) ✅ | Live API (`deleteLocation`) ✅ |
| **Creatives** | Live API ✅ | Live API ✅ | Live API (`deleteCreative`) ✅ |
| **Templates** | Live API ✅ | Live API ✅ | Live API (`deleteTemplate`) ✅ |
| **Services** | Live API ✅ | Live API ✅ | Live API (`deleteService`) ✅ |

---

## 4. Orders & Ad Placements Execution

- **Orders Management (`OrdersScreen` & `OrderDetailsScreen`):**
  - Live API fetch for Service Orders, Creative Orders, Template Orders.
  - Live API actions: Accept, Reject, Update Progress, Deliver Work, Request Revision.
- **Ad Placements (`ad_placement_screen.dart`):**
  - Live API actions: Accept, Reject, In Progress, Complete, Upload Proof (`/api/v1/ad-proofs`).

---

## 5. Security, Routing & Dead Code Checklist

- [ ] **1. Enable KYC Verification Gate for Production:**
  - In `lib/routes/app_routes.dart` (lines 149–158), uncomment the KYC gate so unverified users are guided to verify identity.
- [x] **2. Connect Missing Delete Endpoints:**
  - Wire `deleteCreative(id)` to `CreativeRepository` (`DELETE /api/v1/creative/:id`) ✅
  - Wire `deleteTemplate(id)` to `TemplateRepository` (`DELETE /api/v1/template/:id`) ✅
  - Wire `deleteService(id)` to `ServiceRepository` (`DELETE /api/v1/service/:id`) ✅
  - Wire `createFaq()` and `deleteFaq()` to `FaqRepository` (`POST /api/v1/faq`, `DELETE /api/v1/faq/:id`) ✅
- [x] **3. Add `features` to Template Upload:**
  - Send `'features': featuresList` in `upload_template_screen.dart` ✅
- [ ] **4. Clean Up Unreferenced Duplicate Files:**
  - Delete `lib/features/manage_billboard/` (unused legacy folder with TODO placeholders; the real working screens are in `lib/features/billboard/`).
  - Delete unreferenced mock dashboard screens: `dashboard_screen.dart`, `profile_screen.dart`, `wallet_screen.dart` under `lib/features/dashboard/presentation/screens/`.
  - Wire `createFaq()` and `deleteFaq()` to `FaqRepository` (`POST /api/v1/faq`, `DELETE /api/v1/faq/:id`).
- [ ] **3. Add `features` to Template Upload:**
  - Send `'features': _featuresController.text.split(',')...` in `upload_template_screen.dart`.
- [ ] **4. Clean Up Unreferenced Duplicate Files:**
  - Delete `lib/features/manage_billboard/` (unused legacy folder with TODO placeholders; the real working screens are in `lib/features/billboard/`).
  - Delete unreferenced mock dashboard screens: `dashboard_screen.dart`, `profile_screen.dart`, `wallet_screen.dart` under `lib/features/dashboard/presentation/screens/`.
