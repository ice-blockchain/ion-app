import 'package:ion/app/features/core/model/user_agent.f.dart';
import 'package:ion/app/features/core/providers/app_info_provider.r.dart';
import 'package:ion/app/services/platform_info_service/platform_info_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_agent.r.g.dart';

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
    final platformInfo = ref.watch(platformInfoServiceProvider);
    return UserAgentComponent(
      name: platformInfo.name,
      version: await platformInfo.version,
    );
  }
}
