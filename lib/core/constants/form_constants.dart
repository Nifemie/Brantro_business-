/// Form Constants - All dropdown and select options for signup forms
/// Converted from JavaScript constants for use across the app

// ===============================
// Advertiser Constants
// ===============================
const List<String> ADVERTISER_BUSINESS_INDUSTRIES = [
  "Advertising & Marketing",
  "Real Estate & Property",
  "Financial Services / Fintech",
  "Telecommunications",
  "E-commerce & Retail",
  "FMCG",
  "Hospitality & Tourism",
  "Transportation & Logistics",
  "Education & Training",
  "Healthcare & Pharmaceuticals",
  "Entertainment & Media",
  "Politics & Public Sector",
  "Technology / SaaS",
  "Construction & Engineering",
  "Manufacturing & Industrial",
  "NGO / Non-Profit",
  "Other",
];

// ===============================
// Artist Constants
// ===============================
const List<Map<String, String>> PROFESSION_OPTIONS = [
  {"label": "Musician", "value": "Musician"},
  {"label": "Actor", "value": "Actor"},
  {"label": "Comedian", "value": "Comedian"},
  {"label": "DJ", "value": "DJ"},
  {"label": "MC", "value": "MC"},
  {"label": "Dancer", "value": "Dancer"},
  {"label": "Filmmaker", "value": "Filmmaker"},
  {"label": "Content Creator", "value": "Content Creator"},
  {"label": "Visual Artist", "value": "Visual Artist"},
];

const List<Map<String, String>> SPECIALIZATION_OPTIONS = [
  {"label": "Comedy", "value": "Comedy"},
  {"label": "Film Acting", "value": "Film Acting"},
  {"label": "Music Performance", "value": "Music Performance"},
  {"label": "Music Recording", "value": "Music Recording"},
  {"label": "Stage Acting", "value": "Stage Acting"},
  {"label": "Skits", "value": "Skits"},
  {"label": "Voice Acting", "value": "Voice Acting"},
  {"label": "Dance Performance", "value": "Dance Performance"},
];

const List<Map<String, String>> GENRE_OPTIONS = [
  {"label": "Afrobeats", "value": "Afrobeats"},
  {"label": "Hip Hop", "value": "Hip Hop"},
  {"label": "Gospel", "value": "Gospel"},
  {"label": "Comedy", "value": "Comedy"},
  {"label": "Drama", "value": "Drama"},
  {"label": "Action", "value": "Action"},
  {"label": "Romance", "value": "Romance"},
  {"label": "Documentary", "value": "Documentary"},
];

const List<Map<String, String>> AVAILABILITY_OPTIONS = [
  {"label": "Full Time", "value": "Full Time"},
  {"label": "Part Time", "value": "Part Time"},
  {"label": "On Demand", "value": "On Demand"},
  {"label": "Contract", "value": "Contract"},
  {"label": "Campaign Based", "value": "Campaign Based"},
];

final List<Map<String, String>> YEARS_OF_EXPERIENCE_OPTIONS = [
  ...List.generate(60, (index) {
    final years = index + 1;
    final label = years == 1 ? "1 Year" : "$years Years";
    return {"label": label, "value": "$years"};
  }),
  {"label": "60+ Years", "value": "60+"},
];

final List<Map<String, String>> NUMBER_OF_PRODUCTIONS_OPTIONS = [
  ...List.generate(500, (index) {
    final number = index + 1;
    return {"label": "$number", "value": "$number"};
  }),
  {"label": "500+", "value": "500+"},
];

// ===============================
// Influencer Constants
// ===============================
const List<Map<String, String>> INFLUENCER_PLATFORMS = [
  {"label": "Instagram", "value": "Instagram"},
  {"label": "TikTok", "value": "TikTok"},
  {"label": "YouTube", "value": "YouTube"},
  {"label": "Facebook", "value": "Facebook"},
  {"label": "Twitter / X", "value": "Twitter/X"},
  {"label": "Snapchat", "value": "Snapchat"},
  {"label": "Mixed Platforms", "value": "Mixed Platforms"},
];

const List<Map<String, String>> CONTENT_FORMAT_OPTIONS = [
  {"label": "Posts", "value": "Posts"},
  {"label": "Stories", "value": "Stories"},
  {"label": "Reels", "value": "Reels"},
  {"label": "Short Videos", "value": "Short Videos"},
  {"label": "Long Videos", "value": "Long Videos"},
  {"label": "Live Streams", "value": "Live Streams"},
];

const List<Map<String, String>> AUDIENCE_SIZE_OPTIONS = [
  {"label": "Below 10k", "value": "Below 10k"},
  {"label": "10k – 50k", "value": "10k – 50k"},
  {"label": "50k – 200k", "value": "50k – 200k"},
  {"label": "200k – 1M", "value": "200k – 1M"},
  {"label": "Above 1M", "value": "Above 1M"},
];

const List<Map<String, String>> INFLUENCER_CONTENT_CATEGORIES = [
  {"label": "Lifestyle", "value": "Lifestyle"},
  {"label": "Comedy", "value": "Comedy"},
  {"label": "Education", "value": "Education"},
  {"label": "Technology", "value": "Technology"},
  {"label": "Fashion", "value": "Fashion"},
  {"label": "Beauty", "value": "Beauty"},
  {"label": "Fitness & Health", "value": "Fitness & Health"},
  {"label": "Food & Cooking", "value": "Food & Cooking"},
  {"label": "Travel", "value": "Travel"},
  {"label": "Finance", "value": "Finance"},
  {
    "label": "Business & Entrepreneurship",
    "value": "Business & Entrepreneurship",
  },
  {"label": "Gaming", "value": "Gaming"},
  {"label": "Music & Entertainment", "value": "Music & Entertainment"},
  {"label": "Parenting & Family", "value": "Parenting & Family"},
  {"label": "Religion & Faith", "value": "Religion & Faith"},
  {
    "label": "Motivation & Self Development",
    "value": "Motivation & Self Development",
  },
  {"label": "News", "value": "News"},
  {"label": "Other", "value": "Other"},
];

const List<Map<String, String>> INFLUENCER_NICHES = [
  {"label": "Tech Reviews", "value": "Tech Reviews"},
  {"label": "Skits & Short Comedy", "value": "Skits & Short Comedy"},
  {"label": "Product Reviews", "value": "Product Reviews"},
  {"label": "Tutorials & How-To", "value": "Tutorials & How-To"},
  {"label": "Vlogging", "value": "Vlogging"},
  {"label": "Personal Branding", "value": "Personal Branding"},
  {"label": "Fitness Coaching", "value": "Fitness Coaching"},
  {"label": "Makeup & Beauty Tips", "value": "Makeup & Beauty Tips"},
  {"label": "Travel Diaries", "value": "Travel Diaries"},
  {"label": "Financial Tips", "value": "Financial Tips"},
  {"label": "Business Insights", "value": "Business Insights"},
  {"label": "Gaming Streams", "value": "Gaming Streams"},
  {"label": "Music Covers", "value": "Music Covers"},
  {"label": "Spiritual Content", "value": "Spiritual Content"},
  {"label": "Relationship Advice", "value": "Relationship Advice"},
  {"label": "News", "value": "News"},
  {"label": "Other", "value": "Other"},
];

// ===============================
// Designer/Creative Constants
// ===============================
const List<Map<String, String>> CREATIVE_TYPE_OPTIONS = [
  {"label": "Graphic Designer", "value": "Graphic Designer"},
  {"label": "Video Editor", "value": "Video Editor"},
  {"label": "Motion Designer", "value": "Motion Designer"},
  {"label": "Animator", "value": "Animator"},
  {"label": "Illustrator", "value": "Illustrator"},
  {"label": "UI/UX Designer", "value": "UI/UX Designer"},
  {"label": "Photographer", "value": "Photographer"},
  {"label": "Mixed Creative", "value": "Mixed Creative"},
];

const List<Map<String, String>> CREATIVE_SPECIALIZATION_OPTIONS = [
  {"label": "Brand Identity", "value": "Brand Identity"},
  {"label": "Social Media Content", "value": "Social Media Content"},
  {"label": "Advertising & Marketing", "value": "Advertising & Marketing"},
  {"label": "Product Design", "value": "Product Design"},
  {"label": "Film & Video Production", "value": "Film & Video Production"},
  {
    "label": "Animation & Motion Graphics",
    "value": "Animation & Motion Graphics",
  },
  {"label": "Photography & Retouching", "value": "Photography & Retouching"},
  {"label": "UI/UX & Web Design", "value": "UI/UX & Web Design"},
];

const List<Map<String, String>> CREATIVE_SKILLS_OPTIONS = [
  {"label": "Logo Design", "value": "Logo Design"},
  {"label": "Video Editing", "value": "Video Editing"},
  {"label": "Motion Graphics", "value": "Motion Graphics"},
  {"label": "Illustration", "value": "Illustration"},
  {"label": "Photo Editing", "value": "Photo Editing"},
  {"label": "UI Design", "value": "UI Design"},
  {"label": "UX Research", "value": "UX Research"},
  {"label": "Branding", "value": "Branding"},
  {"label": "Typography", "value": "Typography"},
  {"label": "Color Grading", "value": "Color Grading"},
  {"label": "3D Design", "value": "3D Design"},
  {"label": "Storyboarding", "value": "Storyboarding"},
];

const List<Map<String, String>> CREATIVE_TOOLS_OPTIONS = [
  {"label": "Adobe Photoshop", "value": "Adobe Photoshop"},
  {"label": "Adobe Illustrator", "value": "Adobe Illustrator"},
  {"label": "Adobe After Effects", "value": "Adobe After Effects"},
  {"label": "Adobe Premiere Pro", "value": "Adobe Premiere Pro"},
  {"label": "Figma", "value": "Figma"},
  {"label": "Sketch", "value": "Sketch"},
  {"label": "Canva", "value": "Canva"},
  {"label": "Blender", "value": "Blender"},
  {"label": "Final Cut Pro", "value": "Final Cut Pro"},
  {"label": "DaVinci Resolve", "value": "DaVinci Resolve"},
  {"label": "Cinema 4D", "value": "Cinema 4D"},
];

// ===============================
// Producer Constants
// ===============================
const List<Map<String, String>> PRODUCER_SERVICE_TYPE_OPTIONS = [
  {"label": "Movie Production", "value": "Movie Production"},
  {"label": "Short Film Production", "value": "Short Film Production"},
  {"label": "Music Video Production", "value": "Music Video Production"},
  {"label": "YouTube Video Production", "value": "YouTube Video Production"},
  {"label": "Skits & Comedy Videos", "value": "Skits & Comedy Videos"},
  {"label": "Documentary Production", "value": "Documentary Production"},
  {"label": "Web Series Production", "value": "Web Series Production"},
  {"label": "Commercial & Brand Videos", "value": "Commercial & Brand Videos"},
];

final List<Map<String, String>> PRODUCER_PRODUCTION_COUNT_OPTIONS = [
  ...List.generate(500, (index) {
    final number = index + 1;
    return {"label": "$number", "value": "$number"};
  }),
  {"label": "500+", "value": "500+"},
];

const List<Map<String, String>> PRODUCER_SPECIALIZATION_OPTIONS = [
  {"label": "Film & Movie Production", "value": "Film & Movie Production"},
  {"label": "Short Films & Skits", "value": "Short Films & Skits"},
  {"label": "Music Video Production", "value": "Music Video Production"},
  {"label": "YouTube & Online Videos", "value": "YouTube & Online Videos"},
  {"label": "Comedy & Skit Videos", "value": "Comedy & Skit Videos"},
  {"label": "Documentaries", "value": "Documentaries"},
  {"label": "Web Series", "value": "Web Series"},
  {
    "label": "Social Media Video Content",
    "value": "Social Media Video Content",
  },
  {"label": "Brand & Sponsored Content", "value": "Brand & Sponsored Content"},
];

// ===============================
// Host / Screen Billboard Constants
// ===============================
const List<Map<String, String>> HOST_INDUSTRY_OPTIONS = [
  {"label": "Outdoor Advertising", "value": "Outdoor Advertising"},
  {"label": "Digital Screens", "value": "Digital Screens"},
  {"label": "Billboard Advertising", "value": "Billboard Advertising"},
  {"label": "Transit Advertising", "value": "Transit Advertising"},
  {"label": "Mall / Retail Screens", "value": "Mall / Retail Screens"},
  {"label": "Cinema Advertising", "value": "Cinema Advertising"},
  {"label": "Mixed Advertising", "value": "Mixed Advertising"},
];

// ===============================
// TV Station Constants
// ===============================
const List<Map<String, String>> TV_CONTENT_FOCUS_OPTIONS = [
  {"label": "News", "value": "News"},
  {"label": "Entertainment", "value": "Entertainment"},
  {"label": "Sports", "value": "Sports"},
  {"label": "Movies", "value": "Movies"},
  {"label": "Music", "value": "Music"},
  {"label": "Kids", "value": "Kids"},
  {"label": "Education", "value": "Education"},
  {"label": "Religion", "value": "Religion"},
  {"label": "General", "value": "General"},
];

const List<Map<String, String>> TV_CHANNEL_TYPE_OPTIONS = [
  {"label": "Free To Air", "value": "Free To Air"},
  {"label": "Paid", "value": "Paid"},
  {"label": "Subscription", "value": "Subscription"},
];

const List<Map<String, String>> TV_BROADCAST_TYPE_OPTIONS = [
  {"label": "Terrestrial", "value": "Terrestrial"},
  {"label": "Cable", "value": "Cable"},
  {"label": "Satellite", "value": "Satellite"},
  {"label": "Digital", "value": "Digital"},
  {"label": "Mixed", "value": "Mixed"},
];

const List<Map<String, String>> LANGUAGE_OPTIONS = [
  {"label": "English", "value": "English"},
  {"label": "Hausa", "value": "Hausa"},
  {"label": "Yoruba", "value": "Yoruba"},
  {"label": "Igbo", "value": "Igbo"},
  {"label": "Pidgin", "value": "Pidgin"},
  {"label": "French", "value": "French"},
  {"label": "Arabic", "value": "Arabic"},
];

// ===============================
// Radio Station Constants
// ===============================
const List<Map<String, String>> RADIO_CONTENT_FOCUS_OPTIONS = [
  {"label": "News", "value": "News"},
  {"label": "Music", "value": "Music"},
  {"label": "Talk Shows", "value": "Talk Shows"},
  {"label": "Sports", "value": "Sports"},
  {"label": "Religion", "value": "Religion"},
  {"label": "Education", "value": "Education"},
  {"label": "Entertainment", "value": "Entertainment"},
  {"label": "General", "value": "General"},
];

const List<Map<String, String>> RADIO_BROADCAST_BAND_OPTIONS = [
  {"label": "FM", "value": "FM"},
  {"label": "AM", "value": "AM"},
  {"label": "Online Radio", "value": "Online Radio"},
  {"label": "Mixed", "value": "Mixed"},
];

// ===============================
// Media House Constants
// ===============================
const List<Map<String, String>> MEDIA_HOUSE_TYPE_OPTIONS = [
  {"label": "TV", "value": "TV"},
  {"label": "Radio", "value": "Radio"},
  {"label": "Digital", "value": "Digital"},
  {"label": "Print", "value": "Print"},
  {"label": "Outdoor", "value": "Outdoor"},
  {"label": "Online", "value": "Online"},
  {"label": "General", "value": "General"},
];

const List<Map<String, String>> MEDIA_HOUSE_CONTENT_FOCUS_OPTIONS = [
  {"label": "News", "value": "News"},
  {"label": "Entertainment", "value": "Entertainment"},
  {"label": "Sports", "value": "Sports"},
  {"label": "Politics", "value": "Politics"},
  {"label": "Lifestyle", "value": "Lifestyle"},
  {"label": "Education", "value": "Education"},
  {"label": "Religion", "value": "Religion"},
  {"label": "Business", "value": "Business"},
  {"label": "General", "value": "General"},
];

// ===============================
// Nigerian States (Operating Regions)
// ===============================
const List<Map<String, String>> OPERATING_REGIONS_OPTIONS = [
  {"label": "Abia", "value": "Abia"},
  {"label": "Adamawa", "value": "Adamawa"},
  {"label": "Akwa Ibom", "value": "Akwa Ibom"},
  {"label": "Anambra", "value": "Anambra"},
  {"label": "Bauchi", "value": "Bauchi"},
  {"label": "Bayelsa", "value": "Bayelsa"},
  {"label": "Benue", "value": "Benue"},
  {"label": "Borno", "value": "Borno"},
  {"label": "Cross River", "value": "Cross River"},
  {"label": "Delta", "value": "Delta"},
  {"label": "Ebonyi", "value": "Ebonyi"},
  {"label": "Edo", "value": "Edo"},
  {"label": "Ekiti", "value": "Ekiti"},
  {"label": "Enugu", "value": "Enugu"},
  {"label": "FCT", "value": "FCT"},
  {"label": "Gombe", "value": "Gombe"},
  {"label": "Imo", "value": "Imo"},
  {"label": "Jigawa", "value": "Jigawa"},
  {"label": "Kaduna", "value": "Kaduna"},
  {"label": "Kano", "value": "Kano"},
  {"label": "Katsina", "value": "Katsina"},
  {"label": "Kebbi", "value": "Kebbi"},
  {"label": "Kogi", "value": "Kogi"},
  {"label": "Kwara", "value": "Kwara"},
  {"label": "Lagos", "value": "Lagos"},
  {"label": "Nasarawa", "value": "Nasarawa"},
  {"label": "Niger", "value": "Niger"},
  {"label": "Ogun", "value": "Ogun"},
  {"label": "Ondo", "value": "Ondo"},
  {"label": "Osun", "value": "Osun"},
  {"label": "Oyo", "value": "Oyo"},
  {"label": "Plateau", "value": "Plateau"},
  {"label": "Rivers", "value": "Rivers"},
  {"label": "Sokoto", "value": "Sokoto"},
  {"label": "Taraba", "value": "Taraba"},
  {"label": "Yobe", "value": "Yobe"},
  {"label": "Zamfara", "value": "Zamfara"},
];

// ===============================
// UGC Creator Constants
// ===============================
const List<Map<String, String>> UGC_CONTENT_STYLE_OPTIONS = [
  {"label": "Product Reviews", "value": "Product Reviews"},
  {"label": "Unboxing", "value": "Unboxing"},
  {"label": "Testimonials", "value": "Testimonials"},
  {"label": "Lifestyle Shots", "value": "Lifestyle Shots"},
  {"label": "Voice Over Content", "value": "Voice Over Content"},
  {"label": "How-To Videos", "value": "How-To Videos"},
  {"label": "Short Ads", "value": "Short Ads"},
];

const List<Map<String, String>> UGC_NICHE_OPTIONS = [
  {"label": "Beauty & Skincare", "value": "Beauty & Skincare"},
  {"label": "Fashion", "value": "Fashion"},
  {"label": "Fitness & Wellness", "value": "Fitness & Wellness"},
  {"label": "Technology", "value": "Technology"},
  {"label": "Food & Drinks", "value": "Food & Drinks"},
  {"label": "Travel & Lifestyle", "value": "Travel & Lifestyle"},
  {"label": "Parenting & Family", "value": "Parenting & Family"},
  {"label": "Finance & Business", "value": "Finance & Business"},
  {"label": "Education", "value": "Education"},
  {"label": "Gaming", "value": "Gaming"},
  {"label": "Health & Medical", "value": "Health & Medical"},
  {"label": "Real Estate", "value": "Real Estate"},
  {"label": "E-commerce & Products", "value": "E-commerce & Products"},
];

const List<Map<String, String>> UGC_CONTENT_FORMAT_OPTIONS = [
  {"label": "Short Videos", "value": "Short Videos"},
  {"label": "Long Videos", "value": "Long Videos"},
  {"label": "Images", "value": "Images"},
  {"label": "Voice Over", "value": "Voice Over"},
];

const List<Map<String, String>> UGC_CREATOR_AVAILABILITY_OPTIONS = [
  {"label": "On Demand", "value": "On Demand"},
  {"label": "Contract", "value": "Contract"},
  {"label": "Campaign Based", "value": "Campaign Based"},
];

// ===============================
// Talent Manager Constants
// ===============================
const List<Map<String, String>> TALENT_MANAGER_TYPE_OPTIONS = [
  {"label": "Individual Manager", "value": "Individual Manager"},
  {"label": "Agency", "value": "Agency"},
  {"label": "Talent Management Company", "value": "Talent Management Company"},
];

const List<Map<String, String>> TALENT_CATEGORY_OPTIONS = [
  {"label": "Artists", "value": "Artists"},
  {"label": "Influencers", "value": "Influencers"},
  {"label": "Creatives", "value": "Creatives"},
  {"label": "Actors", "value": "Actors"},
  {"label": "Comedians", "value": "Comedians"},
  {"label": "UGC Creators", "value": "UGC Creators"},
];

final List<Map<String, String>> TALENTS_MANAGED_COUNT_OPTIONS = [
  ...List.generate(500, (index) {
    final number = index + 1;
    return {"label": "$number", "value": "$number"};
  }),
  {"label": "500+", "value": "500+"},
];

// ===============================
// Identity Constants
// ===============================
const List<Map<String, String>> ID_TYPE_OPTIONS = [
  {"label": "CAC", "value": "CAC"},
  {"label": "NIN", "value": "NIN"},
  {"label": "International Passport", "value": "International Passport"},
  {"label": "Driver's License", "value": "Driver's License"},
  {"label": "Voters Card", "value": "Voters Card"},
];
