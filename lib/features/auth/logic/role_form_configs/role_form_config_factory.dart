import 'base_role_form_config.dart';
import 'advertiser_form_config.dart';
import 'artist_form_config.dart';
import 'producer_form_config.dart';
import 'influencer_form_config.dart';
import 'ugc_creator_form_config.dart';
import 'billboard_form_config.dart';
import 'tv_station_form_config.dart';
import 'radio_station_form_config.dart';
import 'media_house_form_config.dart';
import 'creatives_form_config.dart';
import 'talent_manager_form_config.dart';
import 'host_form_config.dart';

/// Factory to get the appropriate form configuration for a role
class RoleFormConfigFactory {
  static BaseRoleFormConfig getConfig(String role) {
    switch (role) {
      case 'Artist':
        return ArtistFormConfig();
      case 'Advertiser':
        return AdvertiserFormConfig();
      case 'Content Producer':
        return ProducerFormConfig();
      case 'Influencer':
        return InfluencerFormConfig();
      case 'UGC Creator':
        return UGCCreatorFormConfig();
      case 'Screen / Billboard':
        return BillboardFormConfig();
      case 'TV Station':
        return TVStationFormConfig();
      case 'Radio Station':
        return RadioStationFormConfig();
      case 'Media House':
        return MediaHouseFormConfig();
      case 'Creatives':
        return CreativesFormConfig();
      case 'Talent Manager':
        return TalentManagerFormConfig();
      case 'Host':
        return HostFormConfig();
      default:
        throw Exception('Unknown role: $role');
    }
  }
}
