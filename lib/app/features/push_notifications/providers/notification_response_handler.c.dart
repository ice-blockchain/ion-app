import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_response_data_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_handler.c.g.dart';

@Riverpod(keepAlive: true)
class NotificationResponseHandler extends _$NotificationResponseHandler {
  @override
  FutureOr<void> build() async {
    final notificationResponses = ref.watch(notificationResponseDataProvider);
    final notificationResponse = notificationResponses.firstOrNull;
    if (notificationResponse != null) {
      await _handleNotificationResponse(notificationResponse);
    }
  }

  Future<void> _handleNotificationResponse(Map<String, dynamic> response) async {
    try {
      final notificationPayload = IonConnectPushDataPayload.fromJson(response);
      final eventParser = ref.read(eventParserProvider);
      final entity = eventParser.parse(notificationPayload.event);

      if (entity is ModifiablePostEntity) {
        await _openPostDetail(entity.toEventReference());
      } else {
        throw UnsupportedEntityType(entity);
      }

      ref.watch(notificationResponseDataProvider.notifier).removeFirst();
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace, message: 'Error handling notification response');
    } finally {
      ref.read(notificationResponseDataProvider.notifier).removeFirst();
    }
  }

  Future<void> _openPostDetail(EventReference eventReference) async {
    await PostDetailsRoute(eventReference: eventReference.encode())
        .push<void>(rootNavigatorKey.currentContext!);
  }
}
