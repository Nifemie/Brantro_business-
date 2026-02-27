import 'base_signup_handler.dart';
import 'artist_signup_handler.dart';
import 'advertiser_signup_handler.dart';
import 'creative_signup_handler.dart';
import 'designer_signup_handler.dart';
import 'influencer_signup_handler.dart';
import 'producer_signup_handler.dart';
import 'ugc_creator_signup_handler.dart';
import 'screen_billboard_signup_handler.dart';
import 'host_signup_handler.dart';
import 'tv_station_signup_handler.dart';
import 'radio_station_signup_handler.dart';
import 'media_house_signup_handler.dart';
import 'talent_manager_signup_handler.dart';

/// Factory class to get the appropriate signup handler for a role
class SignupHandlerFactory {
  static BaseSignupHandler? getHandler(String role) {
    switch (role.toUpperCase()) {
      case 'ARTIST':
        return ArtistSignupHandler();
      case 'ADVERTISER':
        return AdvertiserSignupHandler();
      case 'CREATIVES':
        return CreativeSignupHandler();
      case 'DESIGNER':
        return DesignerSignupHandler();
      case 'INFLUENCER':
        return InfluencerSignupHandler();
      case 'CONTENT PRODUCER':
        return ProducerSignupHandler();
      case 'UGC CREATOR':
        return UGCCreatorSignupHandler();
      case 'SCREEN / BILLBOARD':
        return ScreenBillboardSignupHandler();
      case 'HOST':
        return HostSignupHandler();
      case 'TV STATION':
        return TVStationSignupHandler();
      case 'RADIO STATION':
        return RadioStationSignupHandler();
      case 'MEDIA HOUSE':
        return MediaHouseSignupHandler();
      case 'TALENT MANAGER':
        return TalentManagerSignupHandler();
      default:
        return null;
    }
  }
}
