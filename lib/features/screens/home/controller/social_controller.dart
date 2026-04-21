import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialController extends GetxController {
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
