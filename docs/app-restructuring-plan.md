# Brantro Business App - Restructuring Plan

## Overview
Complete restructuring of the Brantro Business mobile app to improve navigation, user experience, and consistency across all features.

---

## 1. Navigation System Changes

### 1.1 Bottom Navigation Bar (NEW)
Replace sidebar drawer with bottom navigation bar for primary navigation.

**Bottom Nav Items (4 Main Tabs):**
- **Home** - Main dashboard with wallet card, quick action services, filter tabs, and analytics
- **Orders** - Unified orders page with filter tabs for all service types
- **Wallet** - Wallet balance, transactions, withdrawals, and bank accounts
- **Profile** - User profile, settings, and account management

**Navigation Philosophy:**
- Major actions accessible from bottom nav (max 1 tap)
- Secondary features accessible from Home quick actions or Profile menu
- Consistent navigation pattern throughout the app

### 1.2 Remove Sidebar Drawer
- Remove the current sidebar menu completely
- Move all navigation to bottom nav bar and in-page navigation

---

## 2. Home/Dashboard Page Redesign

### 2.1 Page Structure (Top to Bottom)

```
┌─────────────────────────────────────┐
│ Hi, [Name]  [Notifications] [Menu]  │ ← App Bar
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 💰 Available Balance            │ │
│ │ ₦0                              │ │ ← Wallet Card
│ │ Transaction History >           │ │
│ │              [+ Add Money]      │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Quick Actions                       │ ← Section Label
│ ┌─────────────────────────────────┐ │
│ │ [Billboards] [Screens] [Walls]  │ │
│ │ [Templates] [Creatives]         │ │ ← Major Services
│ │ [Services] [Vettings]           │ │   (Quick Action Grid)
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [All] [Billboards] [Screens]... │ │ ← Filter Tabs
│ └─────────────────────────────────┘ │
│                                     │
│ Performance Chart                   │
│ Conversions Chart                   │ ← Charts & Analytics
│ Top Pages Table                     │
│ Recent Orders                       │
│                                     │
│ ─────────────────────────────────── │
│                                     │
│ [Home] [Orders] [Wallet] [Profile]  │ ← Bottom Nav Bar
└─────────────────────────────────────┘
```

### 2.2 Home Page Components

#### 2.2.1 Wallet Card (Top Section)
**Design:**
- Green/teal gradient background
- Shield icon + "Available Balance" label
- Large balance amount display (₦0)
- "Transaction History >" link (right side)
- "+ Add Money" button (bottom right, dark button)

**Actions:**
- Tap card → Navigate to Wallet tab
- Tap "Transaction History" → Navigate to transactions page in Wallet tab
- Tap "+ Add Money" → Open add money modal

#### 2.2.2 Quick Actions Section
**Section Label:** "Quick Actions" (above the grid)

**7 Major Service Buttons in Grid Layout:**

**Row 1 (3 items):**
1. **Billboards** - Manage billboards (icon: map/billboard)
2. **Digital Screens** - Manage digital screens (icon: tv/screen)
3. **Advertisement Walls** - Manage ad walls (icon: wallpaper)

**Row 2 (2 items):**
4. **Templates** - Design templates marketplace (icon: style/palette)
5. **Creatives** - Creative content marketplace (icon: brush/art)

**Row 3 (2 items):**
6. **Services** - Professional services (icon: business/briefcase)
7. **Vettings** - Vetting plans (icon: verified/shield)

**Design:**
- Card background matching theme
- Large icon at top
- Service name below icon
- Optional badge (e.g., "3 Active" or "NEW")
- Tap to navigate to respective marketplace
- Equal size grid items with proper spacing

**Navigation:**
- Each button navigates directly to its marketplace page
- Marketplace pages have Search, Filter, and Add buttons at top

#### 2.2.3 Filter Tabs Section
**Horizontal scrollable tabs for filtering analytics content:**
- All (default)
- Billboards
- Digital Screens
- Advertisement Walls
- Templates
- Creatives
- Services
- Vettings

**Design:**
- Horizontal scrollable tab bar
- Active tab highlighted with accent color
- Smooth scroll animation
- Positioned between quick actions and charts

**Purpose:**
- Filter the charts and analytics data below
- Show performance metrics for specific service category
- Quick way to see category-specific insights

#### 2.2.4 Charts & Analytics Section
After the filter tabs, display analytics (filtered by selected tab):
- Performance chart
- Conversions chart
- Top pages table
- Recent orders list

**Note:** Charts content dynamically updates based on selected filter tab.

### 2.3 Updated Home Page Layout

**Complete Structure:**
```
1. App Bar (Hi [Name], Notifications, Menu)
2. Wallet Card (Balance, Transaction History, Add Money)
3. Quick Actions Section
   - Section Label: "Quick Actions"
   - 7 Service Buttons Grid:
     * Billboards
     * Digital Screens
     * Advertisement Walls
     * Templates
     * Creatives
     * Services
     * Vettings
4. Filter Tabs (All, Billboards, Screens, Walls, Templates, Creatives, Services, Vettings)
5. Charts & Analytics Section (filtered by selected tab)
   - Performance Chart
   - Conversions Chart
   - Top Pages Table
   - Recent Orders
6. Bottom Navigation Bar (Home, Orders, Wallet, Profile)
```

### 2.4 Home Page Widgets Needed

**New Widgets:**
- `WalletBalanceCard` - Wallet card with balance and actions
- `QuickActionsGrid` - 7 major service buttons grid
- `ServiceQuickActionButton` - Individual service button with icon, label, and optional badge
- `FilterTabBar` - Horizontal scrollable filter tabs
- `BottomNavBar` - Bottom navigation bar (4 tabs: Home, Orders, Wallet, Profile)

**Existing Widgets to Keep:**
- `PerformanceChart`
- `ConversionsChart`
- `TopPagesTable`
- `RecentOrdersTable`

**Widgets to Remove:**
- `AlertBanner` (status message)
- Quick transfer actions (To OPay, To Bank, Withdraw)
- Old service buttons (Airtime, Data, Betting, TV, Safelox, Loan, Pla4aChild)

---

## 2. Marketplace Structure Redesign

### 2.1 Main Marketplace Hub
**REMOVED** - No central marketplace hub needed.

**Direct Navigation:**
- Users navigate directly to individual marketplaces from:
  - Bottom nav "More" menu
  - Quick action services grid on home page
  - Filter tabs on home page

### 2.2 Individual Marketplace Pages
Each marketplace follows the same pattern:

**Page Structure:**
```
┌─────────────────────────────────────┐
│ [Back] Category Name                │
├─────────────────────────────────────┤
│ Search Bar          [Filter] [Add]  │
├─────────────────────────────────────┤
│                                     │
│  Item Card 1                        │
│  Item Card 2                        │
│  Item Card 3                        │
│  ...                                │
│                                     │
└─────────────────────────────────────┘
```

**Top Actions:**
- **Search Bar** - Search within category
- **Filter Button** - Filter by status, price, date, etc.
- **Add Button** - "Add New [Category]" (e.g., "Add New Billboard")

**Marketplace Categories:**
1. **Billboards** → "Add New Billboard" button
2. **Digital Screens** → "Add New Screen" button
3. **Advertisement Walls** → "Add New Wall" button
4. **Templates** → "Add New Template" button
5. **Creatives** → "Add New Creative" button
6. **Services** → "Add New Service" button
7. **Vettings** → "Add Vetting Plan" button

**Navigation Flow:**
- User clicks on a category from home filter tabs or More menu
- Opens the marketplace page for that category
- At the top: Search bar, Filter button, and Add button
- Below: List of items in that category
- Clicking an item opens its detail page
- Clicking Add button opens the upload/create form

---

## 3. Unified Orders Page

### 3.1 Single Orders Screen
Replace individual "Orders" under each category with ONE unified orders page accessible from the More menu or bottom nav.

**Page Structure:**
```
┌─────────────────────────────────────┐
│ Orders                              │
├─────────────────────────────────────┤
│ [All] [Billboards] [Screens] ...   │ ← Filter Tabs
├─────────────────────────────────────┤
│                                     │
│  Order Card 1 (Billboard)           │
│  Order Card 2 (Template)            │
│  Order Card 3 (Creative)            │
│  ...                                │
│                                     │
└─────────────────────────────────────┘
```

**Filter Tabs (Horizontal Scrollable):**
- All Orders (default)
- Billboard Orders
- Screen Orders
- Wall Orders
- Template Orders
- Creative Orders
- Service Orders
- Vetting Orders

**Order Card Design:**
- Use same design as admin panel
- Show: Order ID, Service Type, Customer, Amount, Status, Date
- Service type badge/icon to identify category
- Status indicator (Pending, Active, Completed, Cancelled)
- Tap to view order details

**Key Features:**
- Swipe to refresh
- Pull to load more
- Empty state when no orders
- Search functionality
- Date range filter

### 3.2 Order Details Page
- Use same form/layout design as admin panel
- Show full order information
- Customer details
- Service/item details
- Payment information
- Timeline/history
- Action buttons: Accept/Decline, Mark as Delivered, Contact Customer, etc.

**Actions Available:**
- Accept order
- Decline order
- Mark as in progress
- Mark as completed
- Upload proof/deliverables
- Message customer
- Request revision
- Cancel order (with reason)

---

## 4. Feature-Specific Changes

### 4.1 Billboards
**Marketplace Page:**
- List of all billboards
- "Add New Billboard" button at top
- Each billboard card shows: Image, Location, Size, Price, Status

**Add/Edit Billboard Form:**
- Billboard details (name, location, size, type)
- Pricing information
- Availability calendar
- Photos upload
- Map location picker

**Billboard Sub-Pages:**
- Ad Slots management
- Campaign orders for this billboard
- Ads proof submissions

### 4.2 Digital Screens
**Marketplace Page:**
- List of all digital screens
- "Add New Screen" button at top
- Each screen card shows: Image, Venue, Specs, Price, Status

**Add/Edit Screen Form:**
- Screen details (name, venue, specs, resolution)
- Pricing information
- Play schedule
- Photos upload
- Impressions data (if available)

**Screen Sub-Pages:**
- Ad Slots management
- Campaign orders for this screen
- Placement schedule
- Ads proof submissions

### 4.3 Advertisement Walls
**Marketplace Page:**
- List of all advertisement walls
- "Add New Wall" button at top
- Each wall card shows: Image, Location, Size, Price, Status

**Add/Edit Wall Form:**
- Wall details (name, location, dimensions)
- Pricing information
- Availability calendar
- Photos upload
- Map location picker

**Wall Sub-Pages:**
- Ad Slots management
- Campaign orders for this wall
- Placement schedule
- Ads proof submissions

### 4.4 Templates
**Marketplace Page:**
- List of all templates (EXISTING - UPDATE)
- "Add New Template" button at top (move from separate page)
- Each template card shows: Preview, Title, Category, Price, Downloads

**Changes:**
- Keep existing template card design
- Move "Upload Template" button to marketplace page top
- Keep existing upload form

### 4.5 Creatives
**Marketplace Page:**
- List of all creatives (EXISTING - UPDATE)
- "Add New Creative" button at top (move from separate page)
- Each creative card shows: Banner, Title, Type, Duration, Status

**Changes:**
- Keep existing creative card design
- Move "Upload Creative" button to marketplace page top
- Keep existing upload form

### 4.6 Services
**Marketplace Page:**
- List of all services
- "Add New Service" button at top
- Each service card shows: Icon, Service Name, Category, Price, Status

**Add/Edit Service Form:**
- Service details (name, category, description)
- Pricing (packages, deliverables)
- Turnaround time
- Portfolio/samples upload

### 4.7 Vettings
**Marketplace Page:**
- List of all vetting plans
- "Add Vetting Plan" button at top (NOT inside the page, but in the top action bar)
- Each vetting card shows: Plan Name, Price, Duration, Features

**Add/Edit Vetting Plan Form:**
- Plan details (name, description)
- Pricing
- Duration/validity
- Features/benefits list
- Terms and conditions

**Important Note:**
- The "Add Vetting Plan" button is positioned at the top of the page alongside Search and Filter
- NOT as a floating action button or inside the content area
- Follows the same pattern as all other marketplaces

---

## 5. Wallet & Transactions

### 5.1 Wallet Tab (Bottom Nav)
Accessible from bottom nav "Wallet" tab.

**Page Structure:**
```
┌─────────────────────────────────────┐
│ Wallet                              │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 💰 Available Balance            │ │
│ │ ₦0                              │ │ ← Balance Card
│ │                                 │ │   (Larger version)
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Pending Earnings: ₦0            │ │ ← Pending Card
│ └─────────────────────────────────┘ │
│                                     │
│ Quick Actions                       │
│ [Withdraw] [Add Money] [Bank Acct]  │ ← Action Buttons
│                                     │
│ Recent Transactions                 │ ← Section Label
│ • Transaction 1                     │
│ • Transaction 2                     │
│ • Transaction 3                     │
│ [View All Transactions]             │
│                                     │
│ Withdrawal History                  │ ← Section Label
│ • Withdrawal 1                      │
│ • Withdrawal 2                      │
│ [View All Withdrawals]              │
│                                     │
└─────────────────────────────────────┘
```

**Sections:**
- **Balance Card** - Current available balance (large display)
- **Pending Earnings** - Earnings pending clearance
- **Quick Actions:**
  - Withdraw - Initiate withdrawal
  - Add Money - Add funds to wallet
  - Bank Accounts - Manage bank accounts
- **Recent Transactions** - Last 5 transactions with "View All" button
- **Withdrawal History** - Last 3 withdrawals with "View All" button

### 5.2 Transactions Page
Full transaction history page (accessed from "View All Transactions" button).

**Features:**
- Complete transaction list
- Filter by: Date range, Type (Credit/Debit), Status, Service category
- Search by transaction ID or description
- Sort by date, amount
- Export functionality (CSV/PDF)
- Transaction details on tap

**Transaction Card Shows:**
- Transaction type icon
- Description
- Date and time
- Amount (+ for credit, - for debit)
- Status badge
- Service category

### 5.3 Withdrawal Page
Withdrawal management page (accessed from "Withdraw" button).

**Sections:**
- **Initiate Withdrawal:**
  - Enter amount
  - Select bank account
  - Withdrawal fee display
  - Net amount display
  - Confirm button
  
- **Withdrawal History:**
  - List of all withdrawals
  - Status: Pending, Processing, Completed, Failed
  - Date, amount, bank account
  - Reference number
  - Tap to view details

### 5.4 Bank Account Management
Manage bank accounts for withdrawals (accessed from "Bank Accounts" button).

**Features:**
- List of saved bank accounts
- Add new bank account
- Set default account
- Edit account details
- Remove account
- Verify account (if needed)

**Bank Account Card Shows:**
- Bank name and logo
- Account number (masked)
- Account name
- Default badge (if applicable)
- Actions: Edit, Remove, Set as Default

---

## 6. More/Settings Section

### 6.1 Profile Tab (Bottom Nav)
Accessible from bottom nav "Profile" tab.

**Page Structure:**
```
┌─────────────────────────────────────┐
│ Profile                             │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ [Avatar]                        │ │
│ │ [Name]                          │ │ ← Profile Header
│ │ [Email/Phone]                   │ │
│ │              [Edit Profile]     │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Account                             │ ← Section
│ • Notifications                     │
│ • Bank Accounts                     │
│ • KYC/Verification                  │
│ • Security & Password               │
│                                     │
│ Support                             │ ← Section
│ • Complaints                        │
│ • FAQs                              │
│ • Contact/Support                   │
│ • Contact Messages                  │
│                                     │
│ About                               │ ← Section
│ • Announcements                     │
│ • Settings                          │
│ • Terms & Privacy                   │
│ • About App                         │
│                                     │
│ • Logout                            │
│                                     │
└─────────────────────────────────────┘
```

**Menu Items:**

**Account Section:**
- **Notifications** - Notification preferences and history
- **Bank Accounts** - Manage bank accounts for withdrawals
- **KYC/Verification** - Identity verification and documents
- **Security & Password** - Change password, 2FA settings

**Support Section:**
- **Complaints** - Submit and track complaints
- **FAQs** - Frequently asked questions
- **Contact/Support** - Contact support team
- **Contact Messages** - Messages from customers/admin

**About Section:**
- **Announcements** - System announcements and updates
- **Settings** - App settings (theme, language, etc.)
- **Terms & Privacy** - Terms of service and privacy policy
- **About App** - App version, credits, licenses

**Actions:**
- **Logout** - Sign out of the app

### 6.2 Settings
- Profile settings (name, email, phone, avatar)
- Security (change password, 2FA)
- Notification preferences
- Theme (dark/light mode)
- Language
- About app (version, licenses)

---

## 7. Design Consistency

### 7.1 Reusable Components
Create/update reusable widgets:

**Existing (Keep & Enhance):**
- `SearchFilterCard` - For marketplace search/filter/action
- `EmptyState` - For empty lists
- `FilterSheet` - For filter bottom sheets
- `NotificationCard` - For notifications

**New Components Needed:**
- `BottomNavBar` - Bottom navigation bar
- `MarketplaceCard` - Generic card for marketplace items
- `OrderCard` - Card for orders list
- `CategoryCard` - Card for marketplace hub categories
- `ActionButton` - Consistent action buttons
- `StatusBadge` - Status indicators (Active, Pending, etc.)

### 7.2 Admin Panel Design Alignment
- Order cards match admin design
- Order detail forms match admin design
- Status indicators match admin design
- Action buttons match admin design

---

## 8. Implementation Phases

### Phase 1: Navigation Foundation
1. Create bottom navigation bar
2. Update routing structure
3. Remove sidebar drawer
4. Update home page with filter tabs

### Phase 2: Home Page Redesign
1. Create wallet balance card
2. Create quick action services grid
3. Create filter tabs component
4. Update home page layout
5. Remove quick transfer actions
6. Remove alert banner

### Phase 3: Marketplace Restructuring
1. Update Templates marketplace (move button to top)
2. Update Creatives marketplace (move button to top)
3. Create Billboards marketplace
4. Create Digital Screens marketplace
5. Create Advertisement Walls marketplace
6. Create Services marketplace
7. Create Vettings marketplace

### Phase 4: Orders System
1. Create unified orders page
2. Implement filter tabs
3. Create order cards (admin design)
4. Create order details page
5. Implement order actions

### Phase 5: Wallet & Transactions
1. Create wallet dashboard
2. Create transactions page
3. Create withdrawal page
4. Implement bank account management

### Phase 6: More/Settings
1. Create More menu page
2. Update settings pages
3. Implement remaining features

### Phase 7: Polish & Testing
1. Dark mode consistency
2. Loading states
3. Error handling
4. Empty states
5. Testing all flows

---

## 9. Files to Create

### New Features
```
lib/features/
├── orders/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── orders_screen.dart
│   │   │   └── order_details_screen.dart
│   │   └── widgets/
│   │       ├── order_card.dart
│   │       └── order_filter_tabs.dart
│
├── billboard/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── billboard_marketplace_screen.dart
│   │   │   └── add_billboard_screen.dart
│   │   └── widgets/
│   │       └── billboard_card.dart
│
├── digital_screen/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── screen_marketplace_screen.dart
│   │   │   └── add_screen_screen.dart
│   │   └── widgets/
│   │       └── screen_card.dart
│
├── advertisement_wall/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── wall_marketplace_screen.dart
│   │   │   └── add_wall_screen.dart
│   │   └── widgets/
│   │       └── wall_card.dart
│
├── service/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── service_marketplace_screen.dart
│   │   │   └── add_service_screen.dart
│   │   └── widgets/
│   │       └── service_card.dart
│
├── vetting/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── vetting_marketplace_screen.dart
│   │   │   └── add_vetting_plan_screen.dart
│   │   └── widgets/
│   │       └── vetting_card.dart
│
├── wallet/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── wallet_screen.dart (main wallet tab)
│   │   │   ├── transactions_screen.dart
│   │   │   ├── withdrawal_screen.dart
│   │   │   └── bank_accounts_screen.dart
│   │   └── widgets/
│   │       ├── wallet_balance_card.dart
│   │       ├── pending_earnings_card.dart
│   │       ├── transaction_card.dart
│   │       ├── withdrawal_card.dart
│   │       └── bank_account_card.dart
│
└── profile/
    └── presentation/
        ├── screens/
        │   ├── profile_screen.dart (main profile tab)
        │   ├── edit_profile_screen.dart
        │   ├── security_screen.dart
        │   ├── complaints_screen.dart
        │   ├── faqs_screen.dart
        │   ├── contact_support_screen.dart
        │   ├── announcements_screen.dart
        │   └── settings_screen.dart
        └── widgets/
            ├── profile_header.dart
            ├── profile_menu_section.dart
            └── profile_menu_item.dart
```

### Core Widgets
```
lib/core/widgets/
├── bottom_nav_bar.dart (4 tabs: Home, Orders, Wallet, Profile)
├── quick_actions_grid.dart
├── service_quick_action_button.dart
├── filter_tab_bar.dart
├── marketplace_card.dart
├── order_card.dart
├── action_button.dart
└── status_badge.dart
```

### Dashboard Widgets (Updated)
```
lib/features/dashboard/presentation/widgets/
├── wallet_balance_card.dart (for home page)
├── quick_actions_grid.dart
├── service_quick_action_button.dart
└── filter_tab_bar.dart
```

---

## 10. Files to Update

### Existing Features
```
lib/features/
├── template/
│   └── presentation/
│       └── screen/
│           └── template_marketplace/
│               └── template_marketplace.dart (UPDATE: move button to top)
│
├── creative/
│   └── presentation/
│       └── screen/
│           └── creative_marketplace/
│               └── creative_marketplace.dart (UPDATE: move button to top)
│
└── dashboard/
    └── presentation/
        ├── screens/
        │   └── dashboard_screen.dart (UPDATE: add bottom nav)
        └── widgets/
            ├── sidebar_menu.dart (REMOVE)
            └── sidebar_navigation_list.dart (REMOVE)
```

### Routes
```
lib/routes/
└── app_routes.dart (UPDATE: add all new routes)
```

---

## 11. Breaking Changes

### Removed Features
- Sidebar drawer navigation
- Individual "Orders" sub-items under each category
- Separate upload pages (moved to marketplace pages)

### Changed Behavior
- Navigation now via bottom nav bar
- All orders in one unified page
- Add/Upload buttons moved to marketplace page tops
- Marketplace hub as central access point

---

## 12. Success Criteria

### User Experience
- ✅ Faster navigation (max 2 taps to any feature)
- ✅ Consistent UI patterns across all marketplaces
- ✅ Clear visual hierarchy
- ✅ Intuitive bottom navigation
- ✅ Unified orders management

### Technical
- ✅ Reusable components reduce code duplication
- ✅ Consistent routing structure
- ✅ Proper state management
- ✅ Dark mode support throughout
- ✅ Responsive design

### Business
- ✅ Easier for providers to manage all offerings
- ✅ Simplified order management
- ✅ Better wallet/earnings visibility
- ✅ Matches admin panel design language

---

## 13. Timeline Estimate

- **Phase 1:** 2-3 days (Navigation Foundation)
- **Phase 2:** 3-4 days (Home Page Redesign)
- **Phase 3:** 5-7 days (Marketplace Restructuring)
- **Phase 4:** 3-4 days (Orders System)
- **Phase 5:** 3-4 days (Wallet & Transactions)
- **Phase 6:** 3-4 days (Profile/More Section)
- **Phase 7:** 2-3 days (Polish & Testing)

**Total:** ~21-29 days

---

## Notes

- Keep existing authentication flow unchanged
- Maintain existing theme system (light/dark mode)
- Preserve existing notification system
- Keep existing file picker service
- Reuse existing reusable widgets where possible
- Follow existing code structure and naming conventions
