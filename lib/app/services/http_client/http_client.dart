// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:ion/app/utils/url.dart';

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => isIP(host);
  }
}

void setGlobalHttpOverrides() {
  HttpOverrides.global = CustomHttpOverrides();
}
