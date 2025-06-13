import 'package:ion/app/features/ion_connect/ion_connect.dart';

abstract class PersistentSubscriptionEncryptedEventMessageHandler {
  bool canHandle({
    required List<String> wrappedKinds,
    List<String> wrappedSecondKinds,
  });
  Future<void> handle(EventMessage rumor);
}
