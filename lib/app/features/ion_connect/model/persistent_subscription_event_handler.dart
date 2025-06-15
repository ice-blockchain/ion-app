import 'package:ion/app/features/ion_connect/ion_connect.dart';

abstract class PersistentSubscriptionEventHandler {
  bool canHandle(EventMessage eventMessage);

  Future<void> handle(EventMessage eventMessage);
}
