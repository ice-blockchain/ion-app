import 'package:ion/app/features/ion_connect/ion_connect.dart';

abstract class GlobalSubscriptionEventHandler {
  bool canHandle(EventMessage eventMessage);

  Future<void> handle(EventMessage eventMessage);
}
