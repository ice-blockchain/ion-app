import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openUrl(String url) async {
  final uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint('Could not launch $url: $e');
    return false;
  }
}
