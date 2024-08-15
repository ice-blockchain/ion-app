import 'package:ice/app/services/logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openUrl(
  String url, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  final uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: mode);
    } else {
      return false;
    }
  } catch (error) {
    Logger.log('Could not launch $url', error: error);
    return false;
  }
}

Future<bool> openUrlInAppBrowser(String url) async {
  return openUrl(url, mode: LaunchMode.inAppBrowserView);
}
