// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_info_provider.r.g.dart';

@Riverpod(keepAlive: true)
Future<PackageInfo> appInfo(Ref ref) async {
  return PackageInfo.fromPlatform();
}
