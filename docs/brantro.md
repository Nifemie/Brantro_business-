1)App Entry & Auth Flow
[ Splash ]
→ [ Onboarding (optional) ]
→ [ Welcome ]
→ (Login) → [ Login ]
→ (Sign up) → [ Sign Up ]
→ (Continue as Guest) → [ Home Marketplace ]  (limited: browse only)


After Login / Signup
[ Login / Sign Up ]
→ [ Role Resolver ] (fetch user + role + KYC status)
→ [ Main Shell (Bottom Nav) ]



2)Main Shell (Bottom Navigation)
For most roles, keep a consistent e-commerce layout: [Main Shell]
Tabs:
1)Home
2)Explore / Categories
3)Campaigns (Orders)
4)Wallet
5)Profile


For seller roles (Influencer/Host/Stations/Designer) add “Sell” tools via:

●A dedicated tab or
●A floating “+” action button that opens Seller menu.


3)Home Marketplace Flow (E-commerce Entry)
[ Home Marketplace ]
-Search bar
-Category grid
-Featured listings
-Promotions
-Quick filters (Location, Price, Platform)
→ Tap Category Card → [ Category Listing ]


Category cards:

●Influencers
●Artists
●Radio Stations
●TV Stations
●Media Houses
●Digital Screens
●Billboards
●Designers / Creatives


4)Browse → Listing → Details → Slot Selection
4.1Category Listing Screen (Product Listing Page)
[ Category Listing (e.g., Influencers) ]
-Filters (Location, Price, Rating, Platform)
-Sort (Recommended, Price low-high, Most booked)
-Card list
→ Tap Item Card → [ Seller/Inventory Details ]


4.2Seller/Inventory Details Screen (Product Details Page)
For influencer/artist/stations/media/host:

[ Seller/Inventory Details ]
-Profile / brand info
-Media gallery
-Specs (followers, reach, location, screen size, etc.)
-Ad Slots / Packages (list)
→ Tap Slot/Package → [ Booking Summary ]


For designers:

[ Designer Details ]
-Portfolio
-Services list
→ Tap Service → [ Service Details ] → [ Booking Summary ]



5)Booking & Payment Flow (Universal)
5.1Booking Summary Screen (Checkout Page)
[ Booking Summary ]
-Selected slot/package
-Scheduled date/time (if applicable)
-Notes / Description
-Attachments upload (creative files)
-Total Amount
-(Pay & Book)
{Gate: KYC Required?}
→ if NO → proceed to Paystack
→ if YES → [ KYC Gate Screen ]


5.2KYC Gate Screen (Progressive Trust Gate)
[ KYC Gate Screen ]
-Explain why KYC is needed
-Show current KYC status
-(Start / Continue KYC) → [ KYC Flow ]
-(Not now) → back to [ Booking Summary ] (Pay disabled)


5.3Paystack Checkout Flow
[ Paystack Checkout ]

→ Payment Success
→ [ Payment Processing ]
-show “We are confirming your payment”
-poll booking status or show “pending confirmation”
→ [ Booking Created (REQUESTED) ]
→ Payment Failed / Cancelled
→ back to [ Booking Summary ]


Important UX: “Payment succeeded” does not always mean “booking accepted”. Booking acceptance depends on seller (influencer/station/host).


6)Campaigns (Orders) Flow — Buyer Side (USER/ADVERTISER)
6.1Campaigns Tab (Order History)
[ Campaigns ]
-Tabs: All | Requested | Accepted | In Progress | Completed
-Each card shows:
Seller name + slot + status + amount + scheduled date
→ Tap Campaign Card → [ Campaign Details ]


6.2Campaign Details Screen
[ Campaign Details ]
-Booking info
-Seller info
-Status timeline
-Attachments (creatives)
-Proof section Actions vary by status:
REQUESTED: (Cancel?) (Chat?) optional ACCEPTED: (Wait / View Schedule) IN_PROGRESS: (Wait for proof)
PROOF SUBMITTED: (Review Proof) → [ Proof Review ] COMPLETED: (Rate Seller) (Rebook)


6.3Proof Review (Buyer Confirms Delivery)

[ Proof Review ]
-Proof list (URL, screenshot, video)
-(Approve Proof) → completes campaign
-(Reject Proof) → enter reason → sends back for correction



7)Seller Flows (Influencer/Artist/Radio/TV/Media/Host/Des igner)
7A) Seller Mode Entry (Unified)
[ Home Marketplace ]
→ (Sell / Manage) button
→ [ Seller Dashboard ]


Seller Dashboard (Role-aware)
[ Seller Dashboard ]
-My Listings / My Slots
-Campaign Inbox (Bookings)
-Earnings Summary
-Proof Upload shortcuts
-KYC status (must be approved to sell for some roles)



7B) KYC Mandatory Before Selling (Seller Gate)
For roles: INFLUENCER, ARTIST, RADIO_STATION, TV_STATION, MEDIA_HOUSE, HOST, DESIGNER
[ Seller Dashboard ]
{Gate: KYC Approved?} if NO:
→ [ KYC Required to Sell Screen ] → [ KYC Flow ] if YES:
→ allow Create Slot / Upload Inventory




7C) Influencer/Artist Flow (Slots + Booking + Proof)
Create Ad Slot
[ Seller Dashboard ]
→ (Create Ad Slot)
→ [ Create Influencer Ad Slot ]
-platform
-content type
-price
-duration
-max revisions
-active toggle
→ (Save) → [ My Ad Slots ]


Social Accounts (Profile building)
[ Seller Dashboard ]
→ (Social Accounts)
→ [ Social Accounts List ]
→ (Add) → [ Add Social Account ]
→ (Edit) → [ Edit Social Account ]
→ (Set Primary)


Campaign Inbox (Seller accepts/rejects)
[ Seller Dashboard ]
→ (Campaign Inbox)
→ [ Seller Campaign List ]
→ Tap Campaign → [ Seller Campaign Details ]


Seller Campaign Details Actions
[ Seller Campaign Details ] REQUESTED:
-(Accept)
-(Reject) → reason ACCEPTED:
-(Mark In Progress) or auto when posting starts IN_PROGRESS:

-(Upload Proof) → [ Upload Proof ]


Upload Proof
[ Upload Proof ]
-proof type: Screenshot / Video / URL
-upload / paste link
-(Submit) → status becomes SUBMITTED
→ back to [ Seller Campaign Details ]



7D) Radio/TV/Media House Flow (Packages + Schedule)
Create Package / Slot
[ Seller Dashboard ]
→ (Create Package)
→ [ Create Media Package ]
-package name
-slot duration (e.g., 30s)
-time band / show slot
-price
-availability calendar
→ (Save) → [ My Packages ]


Proof Upload (broadcast proof)
[ Seller Campaign Details ]
→ (Upload Proof)
→ [ Upload Proof ]
-URL (published article)
-screenshot/video/audio
-notes/logs



7E) Host (Digital Screen/Billboard) Inventory Flow
[ Seller Dashboard ]
→ (Add Inventory)
→ [ Create Screen/Billboard Listing ]
-location

-size/specs
-price per day/week/month
-availability
-images
→ (Save) → [ My Inventory ]


Proof upload:

●photo/video showing ad displayed


7F) Designer Flow (Services + Orders)
[ Seller Dashboard ]
→ (Add Service)
→ [ Create Design Service ]
-title
-description
-price
-duration days
-tags
-sample url
-thumbnail
→ (Save) → [ My Services ]


Orders:

[ Seller Dashboard ]
→ (Orders)
→ [ Designer Orders List ]
→ Tap Order → [ Order Details ]
-(Upload Delivery File)
-(Message buyer) optional



8)Wallet Flow (All Users)
Wallet Home
[ Wallet ]

-Available balance
-Pending balance
-(Fund Wallet)
-(Withdraw)
-Transactions list
→ tap transaction → [ Transaction Details ]


Fund Wallet (Paystack)
[ Wallet ]
→ (Fund Wallet)
→ [ Fund Wallet ]
-enter amount
-(Pay with Paystack)
→ [ Paystack Checkout ]
→ [ Funding Processing ]
→ wallet updates after webhook


Withdrawal (Requires KYC + Verified Bank Account)
[ Wallet ]
→ (Withdraw)
{Gate: balance > 0 ?}
{Gate: KYC approved ?}
{Gate: withdrawal account exists & verified ?} if missing → [ Withdrawal Account Setup ] else → [ Withdrawal Request ]


Withdrawal Account Setup
[ Withdrawal Account Setup ]
-bank selection
-account number
-account name (auto-resolved)
-(Verify Account) (platform verifies ownership)
-(Save)


Withdrawal Request
[ Withdrawal Request ]
-select verified account
-enter amount
-confirm

-submit
→ status: REQUESTED
→ [ Withdrawal Requests List ]


Withdrawal Requests List
[ Withdrawal Requests List ]
-REQUESTED / APPROVED / REJECTED / PAID
-Tap item → [ Withdrawal Request Details ]



9)KYC Flow (Reusable Across App)
[ KYC Start ]
→ [ Personal KYC Form ]
→ [ ID Upload ]
→ [ Address Info ]
→ (Submit)
→ [ KYC Status Screen (SUBMITTED) ]
-pending review
-rejected reason if any
-re-submit option

For business/media roles: [ Business KYC Form ]
-CAC / reg number
-business address
-company documents upload
-tax id optional



10)Admin Flow (Web Only Summary)
[ Admin Dashboard ]
→ User Management
→ KYC Review
→ Campaign Review
→ Proof Approvals

→ Withdrawal Approvals
→ Disputes & Reports


(No Flutter admin needed unless you want an internal admin app.)


11)Recommended Flutter Folder / Navigation Structure
Route groups (clean)

●auth/
●marketplace/
●details/
●booking/
●campaigns/
●seller/
●wallet/
●kyc/
●profile/


12)Quick Summary (If dev remembers only this)
●Brantro = Ads e-commerce
●Home = categories
●Listings = product grid
●Details = slots/packages
●Booking = checkout + Paystack
●Campaigns = order tracking
●Proof = delivery confirmation
●Wallet = fund / earn / withdraw
●KYC = progressive gate (required to transact or sell; mandatory for stations/hosts/media)

