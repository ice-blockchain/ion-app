import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ion/app/features/core/model/user_agent.f.dart';
import 'package:ion/app/features/core/providers/app_info_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_agent.r.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserAgent extends _$CurrentUserAgent {
  @override
  Future<UserAgent> build() async {
    return UserAgent(
      components: await Future.wait([
        _buildPlatformComponent(),
        _buildClientComponent(),
      ]),
    );
  }

  Future<UserAgentComponent> _buildClientComponent() async {
    final packageInfo = await ref.watch(appInfoProvider.future);
    return UserAgentComponent(
      name: 'ion-app',
      version: '${packageInfo.version}.${packageInfo.buildNumber}',
    );
  }

  Future<UserAgentComponent> _buildPlatformComponent() async {
    final deviceInfo = DeviceInfoPlugin();
    final version = switch (defaultTargetPlatform) {
      TargetPlatform.android => (await deviceInfo.androidInfo).version.release,
      TargetPlatform.iOS => (await deviceInfo.iosInfo).systemVersion,
      TargetPlatform.macOS => (await deviceInfo.macOsInfo).osRelease,
      TargetPlatform.windows => (await deviceInfo.windowsInfo).computerName,
      TargetPlatform.linux => (await deviceInfo.linuxInfo).prettyName,
      _ => 'Unknown',
    };
    return UserAgentComponent(
      name: Platform.operatingSystem,
      version: version,
    );
  }
}
