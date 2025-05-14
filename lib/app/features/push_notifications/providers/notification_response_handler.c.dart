import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_response_data_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_handler.c.g.dart';

@riverpod
class NotificationResponseHandler extends _$NotificationResponseHandler {
  @override
  FutureOr<void> build() async {
    final notificationResponses = ref.watch(notificationResponseDataProvider);
    final notificationResponse = notificationResponses.firstOrNull;
    if (notificationResponse != null) {
      handleNotificationResponse(notificationResponse);
    }
  }

  void handleNotificationResponse(Map<String, dynamic> response) {
    try {
      final notificationPayload = IonConnectPushDataPayload.fromJson(response);
      print(notificationPayload);
      //TODO:do something
      ref.watch(notificationResponseDataProvider.notifier).removeFirst();
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace, message: 'Error handling notification response');
    } finally {
      ref.read(notificationResponseDataProvider.notifier).removeFirst();
    }
  }
}
