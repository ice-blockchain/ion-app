import 'dart:io';

import 'package:ion/app/utils/url.dart';

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => isIPv4(host);
  }
}

void setGlobalHttpOverrides() {
  HttpOverrides.global = CustomHttpOverrides();
}
