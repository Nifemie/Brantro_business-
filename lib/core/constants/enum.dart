// User Roles
enum UserRole {
  ADVERTISER('ADVERTISER'),
  ARTIST('ARTIST'),
  SCREEN_BILLBOARD('Screen / Billboard'),
  PRODUCER('PRODUCER'),
  INFLUENCER('INFLUENCER'),
  UGC_CREATOR('UGC_CREATOR'),
  HOST('HOST'),
  TV_STATION('TV_STATION'),
  RADIO_STATION('RADIO_STATION'),
  MEDIA_HOUSE('MEDIA_HOUSE'),
  DESIGNER('CREATIVE'),
  TALENT_MANAGER('TALENT_MANAGER');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.ADVERTISER,
    );
  }
}

// Auth Providers
enum AuthProvider {
  INTERNAL('INTERNAL'),
  GOOGLE('GOOGLE'),
  FACEBOOK('FACEBOOK'),
  APPLE('APPLE');

  final String value;
  const AuthProvider(this.value);
}

// Account Types
enum AccountType {
  INDIVIDUAL('INDIVIDUAL'),
  BUSINESS('BUSINESS'),
  PERSONAL('PERSONAL');

  final String value;
  const AccountType(this.value);

  static AccountType fromString(String value) {
    return AccountType.values.firstWhere(
      (type) =>
          type.value == value ||
          type.value.toLowerCase() == value.toLowerCase(),
      orElse: () => AccountType.INDIVIDUAL,
    );
  }
}

// Artist Professions
enum ArtistProfession {
  MUSICIAN('Musician'),
  ACTOR('Actor'),
  DANCER('Dancer'),
  COMEDIAN('Comedian'),
  MODEL('Model'),
  VOICE_ACTOR('Voice Actor'),
  ANIMATOR('Animator'),
  ILLUSTRATOR('Illustrator');

  final String value;
  const ArtistProfession(this.value);
}

// Artist Specializations
enum ArtistSpecialization {
  POP('Pop'),
  ROCK('Rock'),
  HIP_HOP('Hip Hop'),
  JAZZ('Jazz'),
  CLASSICAL('Classical'),
  AFROBEATS('Afrobeats'),
  GOSPEL('Gospel'),
  REGGAE('Reggae'),
  COMEDY('Comedy'),
  DRAMA('Drama'),
  ACTION('Action'),
  THRILLER('Thriller');

  final String value;
  const ArtistSpecialization(this.value);
}

// Music Genres
enum MusicGenre {
  POP('Pop'),
  ROCK('Rock'),
  HIP_HOP('Hip Hop'),
  JAZZ('Jazz'),
  CLASSICAL('Classical'),
  ELECTRONIC('Electronic'),
  COUNTRY('Country'),
  R_AND_B('R&B'),
  SOUL('Soul'),
  REGGAE('Reggae'),
  AFROBEATS('Afrobeats'),
  GOSPEL('Gospel'),
  FOLK('Folk'),
  INDIE('Indie');

  final String value;
  const MusicGenre(this.value);
}

// Availability Types
enum AvailabilityType {
  FULL_TIME('Full Time'),
  PART_TIME('Part Time'),
  FREELANCE('Freelance'),
  OCCASIONAL('Occasional'),
  WEEKENDS_ONLY('Weekends Only'),
  FLEXIBLE('Flexible');

  final String value;
  const AvailabilityType(this.value);
}

// Years of Experience
enum YearsOfExperience {
  LESS_THAN_ONE('Less than 1 year'),
  ONE_TO_THREE('1-3 years'),
  THREE_TO_FIVE('3-5 years'),
  FIVE_TO_TEN('5-10 years'),
  TEN_PLUS('10+ years');

  final String value;
  const YearsOfExperience(this.value);
}

// Number of Productions
enum NumberOfProductions {
  ZERO_TO_FIVE('0-5'),
  FIVE_TO_TEN('5-10'),
  TEN_TO_TWENTY('10-20'),
  TWENTY_PLUS('20+');

  final String value;
  const NumberOfProductions(this.value);
}

// Talent Manager Types
enum TalentManagerType {
  SELF_MANAGED('Self Managed'),
  PERSONAL_MANAGER('Personal Manager'),
  AGENCY('Agency'),
  LABEL('Label'),
  STUDIO('Studio');

  final String value;
  const TalentManagerType(this.value);
}

// Industries
enum Industry {
  FASHION('Fashion'),
  BEAUTY('Beauty'),
  TECHNOLOGY('Technology'),
  FINANCE('Finance'),
  HEALTHCARE('Healthcare'),
  AUTOMOTIVE('Automotive'),
  FOOD_BEVERAGE('Food & Beverage'),
  RETAIL('Retail'),
  REAL_ESTATE('Real Estate'),
  EDUCATION('Education'),
  ENTERTAINMENT('Entertainment'),
  MEDIA('Media'),
  HOSPITALITY('Hospitality'),
  TRAVEL('Travel'),
  SPORTS('Sports'),
  FITNESS('Fitness'),
  TELECOMMUNICATIONS('Telecommunications'),
  INSURANCE('Insurance'),
  ENERGY('Energy'),
  AGRICULTURE('Agriculture'),
  MANUFACTURING('Manufacturing'),
  CONSTRUCTION('Construction'),
  NONPROFIT('Nonprofit');

  final String value;
  const Industry(this.value);
}

// Advertiser Industries
enum AdvertiserIndustry {
  FASHION('Fashion'),
  BEAUTY('Beauty'),
  TECHNOLOGY('Technology'),
  FINANCE('Finance'),
  HEALTHCARE('Healthcare'),
  AUTOMOTIVE('Automotive'),
  FOOD_BEVERAGE('Food & Beverage'),
  RETAIL('Retail'),
  REAL_ESTATE('Real Estate'),
  EDUCATION('Education'),
  ENTERTAINMENT('Entertainment'),
  TELECOMMUNICATIONS('Telecommunications'),
  INSURANCE('Insurance'),
  NONPROFIT('Nonprofit'),
  ECOMMERCE('E-commerce'),
  STARTUP('Startup'),
  CORPORATE('Corporate'),
  SME('SME');

  final String value;
  const AdvertiserIndustry(this.value);
}

// Broadcast Types
enum BroadcastType {
  FM('FM'),
  AM('AM'),
  DIGITAL('Digital');

  final String value;
  const BroadcastType(this.value);
}

// Channel Types
enum ChannelType {
  ENTERTAINMENT('Entertainment'),
  NEWS('News'),
  SPORTS('Sports'),
  MUSIC('Music'),
  EDUCATION('Education'),
  DOCUMENTARY('Documentary'),
  KIDS('Kids'),
  LIFESTYLE('Lifestyle');

  final String value;
  const ChannelType(this.value);
}

// Broadcast Bands
enum BroadcastBand {
  FM('FM'),
  AM('AM'),
  SW('SW');

  final String value;
  const BroadcastBand(this.value);
}

// Primary Languages
enum PrimaryLanguage {
  ENGLISH('English'),
  YORUBA('Yoruba'),
  IGBO('Igbo'),
  HAUSA('Hausa'),
  PIDGIN('Pidgin'),
  FRENCH('French'),
  TWIBANDIBUTE('Twi');

  final String value;
  const PrimaryLanguage(this.value);
}

// Media Types
enum MediaType {
  TELEVISION('Television'),
  RADIO('Radio'),
  PRINT('Print'),
  DIGITAL('Digital'),
  NEWSPAPER('Newspaper'),
  MAGAZINE('Magazine'),
  ONLINE('Online'),
  BROADCAST('Broadcast');

  final String value;
  const MediaType(this.value);
}

// Content Focus
enum ContentFocus {
  NEWS('News'),
  ENTERTAINMENT('Entertainment'),
  SPORTS('Sports'),
  MUSIC('Music'),
  EDUCATION('Education'),
  LIFESTYLE('Lifestyle'),
  TECHNOLOGY('Technology'),
  BUSINESS('Business'),
  COMEDY('Comedy'),
  DRAMA('Drama'),
  DOCUMENTARY('Documentary'),
  KIDS('Kids');

  final String value;
  const ContentFocus(this.value);
}

// Content Styles (for UGC)
enum ContentStyle {
  HUMOROUS('Humorous'),
  PROFESSIONAL('Professional'),
  CASUAL('Casual'),
  EDUCATIONAL('Educational'),
  MOTIVATIONAL('Motivational'),
  CINEMATIC('Cinematic'),
  DOCUMENTARY('Documentary'),
  TESTIMONIAL('Testimonial');

  final String value;
  const ContentStyle(this.value);
}

// Content Formats
enum ContentFormat {
  VIDEO('Video'),
  IMAGE('Image'),
  AUDIO('Audio'),
  TEXT('Text'),
  CAROUSEL('Carousel'),
  REEL('Reel'),
  STORY('Story'),
  LIVESTREAM('Livestream'),
  PODCAST('Podcast'),
  BLOG('Blog');

  final String value;
  const ContentFormat(this.value);
}

// Content Categories
enum ContentCategory {
  FASHION('Fashion'),
  BEAUTY('Beauty'),
  LIFESTYLE('Lifestyle'),
  FOOD('Food'),
  TRAVEL('Travel'),
  TECHNOLOGY('Technology'),
  FINANCE('Finance'),
  HEALTH_FITNESS('Health & Fitness'),
  EDUCATION('Education'),
  ENTERTAINMENT('Entertainment'),
  GAMING('Gaming'),
  PARENTING('Parenting'),
  BUSINESS('Business');

  final String value;
  const ContentCategory(this.value);
}

// Niches
enum Niche {
  FASHION('Fashion'),
  BEAUTY('Beauty'),
  LIFESTYLE('Lifestyle'),
  FOOD_COOKING('Food & Cooking'),
  TRAVEL('Travel'),
  TECHNOLOGY('Technology'),
  FINANCE_CRYPTO('Finance & Crypto'),
  HEALTH_FITNESS('Health & Fitness'),
  SELF_IMPROVEMENT('Self Improvement'),
  PARENTING('Parenting'),
  GAMING('Gaming'),
  BUSINESS('Business'),
  ENTREPRENEURSHIP('Entrepreneurship'),
  COMEDY('Comedy'),
  EDUCATION('Education');

  final String value;
  const Niche(this.value);
}

// Audience Size Ranges
enum AudienceSizeRange {
  LESS_THAN_10K('Less than 10K'),
  TEN_TO_50K('10K - 50K'),
  FIFTY_TO_100K('50K - 100K'),
  HUNDRED_TO_500K('100K - 500K'),
  FIVE_HUNDRED_K_TO_1M('500K - 1M'),
  ONE_M_PLUS('1M+');

  final String value;
  const AudienceSizeRange(this.value);
}

// Experience Levels (Designer)
enum ExperienceLevel {
  JUNIOR('Junior'),
  MID_LEVEL('Mid Level'),
  SENIOR('Senior'),
  EXPERT('Expert'),
  LEAD('Lead');

  final String value;
  const ExperienceLevel(this.value);
}

// Pricing Models (Designer)
enum PricingModel {
  PER_PROJECT('Per Project'),
  HOURLY('Hourly'),
  MONTHLY('Monthly'),
  RETAINER('Retainer'),
  FIXED('Fixed');

  final String value;
  const PricingModel(this.value);
}

// Talent Categories
enum TalentCategory {
  MUSICIAN('Musician'),
  ACTOR('Actor'),
  DANCER('Dancer'),
  COMEDIAN('Comedian'),
  MODEL('Model'),
  VOICE_ARTIST('Voice Artist'),
  ANIMATOR('Animator'),
  ILLUSTRATOR('Illustrator'),
  PRODUCER('Producer'),
  DIRECTOR('Director'),
  CINEMATOGRAPHER('Cinematographer'),
  EDITOR('Editor'),
  WRITER('Writer');

  final String value;
  const TalentCategory(this.value);
}

// Talents Managed Count
enum TalentsManagedCount {
  ONE_TO_FIVE('1-5'),
  FIVE_TO_TEN('5-10'),
  TEN_TO_TWENTY('10-20'),
  TWENTY_TO_FIFTY('20-50'),
  FIFTY_PLUS('50+');

  final String value;
  const TalentsManagedCount(this.value);
}

// Service Types (Content Producer)
enum ServiceType {
  VIDEO_PRODUCTION('Video Production'),
  MUSIC_PRODUCTION('Music Production'),
  PHOTOGRAPHY('Photography'),
  AUDIO_PRODUCTION('Audio Production'),
  ANIMATION('Animation'),
  GRAPHIC_DESIGN('Graphic Design'),
  EDITING('Editing'),
  VOICE_OVER('Voice Over'),
  SCRIPTWRITING('Scriptwriting'),
  DIRECTING('Directing'),
  CINEMATOGRAPHY('Cinematography');

  final String value;
  const ServiceType(this.value);
}

// ID Types
enum IDType {
  NATIONAL_ID('National ID'),
  DRIVERS_LICENSE('Driver\'s License'),
  INTERNATIONAL_PASSPORT('International Passport'),
  NIN('NIN'),
  TIN('TIN'),
  RC('RC');

  final String value;
  const IDType(this.value);
}

// Operating Regions (States)
enum OperatingRegion {
  ABIA('Abia'),
  ADAMAWA('Adamawa'),
  AKWA_IBOM('Akwa Ibom'),
  ANAMBRA('Anambra'),
  BAUCHI('Bauchi'),
  BAYELSA('Bayelsa'),
  BENUE('Benue'),
  BORNO('Borno'),
  CROSS_RIVER('Cross River'),
  DELTA('Delta'),
  EBONYI('Ebonyi'),
  EDO('Edo'),
  EKITI('Ekiti'),
  ENUGU('Enugu'),
  FCT('FCT'),
  GOMBE('Gombe'),
  IMO('Imo'),
  JIGAWA('Jigawa'),
  KADUNA('Kaduna'),
  KANO('Kano'),
  KATSINA('Katsina'),
  KEBBI('Kebbi'),
  KOGI('Kogi'),
  KWARA('Kwara'),
  LAGOS('Lagos'),
  NASARAWA('Nasarawa'),
  NIGER('Niger'),
  OGUN('Ogun'),
  ONDO('Ondo'),
  OSUN('Osun'),
  OYO('Oyo'),
  PLATEAU('Plateau'),
  RIVERS('Rivers'),
  SOKOTO('Sokoto'),
  TARABA('Taraba'),
  YOBE('Yobe'),
  ZAMFARA('Zamfara');

  final String value;
  const OperatingRegion(this.value);
}

// Status Types
enum AccountStatus {
  PENDING('PENDING'),
  ACTIVE('ACTIVE'),
  SUSPENDED('SUSPENDED'),
  DELETED('DELETED'),
  VERIFIED('VERIFIED'),
  UNVERIFIED('UNVERIFIED');

  final String value;
  const AccountStatus(this.value);
}

// Verification Status
enum VerificationStatus {
  PENDING('PENDING'),
  VERIFIED('VERIFIED'),
  REJECTED('REJECTED'),
  EXPIRED('EXPIRED');

  final String value;
  const VerificationStatus(this.value);
}

// Payment Status
enum PaymentStatus {
  PENDING('PENDING'),
  COMPLETED('COMPLETED'),
  FAILED('FAILED'),
  CANCELLED('CANCELLED'),
  REFUNDED('REFUNDED');

  final String value;
  const PaymentStatus(this.value);
}
