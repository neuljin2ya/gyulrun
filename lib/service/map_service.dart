import 'package:url_launcher/url_launcher.dart';

class MapService {
  const MapService();

  Future<bool> openNaverMap(String address) {
    final encodedAddress = Uri.encodeComponent(address);
    final uri = Uri.parse('https://map.naver.com/p/search/$encodedAddress');
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
