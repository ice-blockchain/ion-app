import 'dart:developer' as developer;
import 'dart:io';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class IonIdentityLogger extends PrettyDioLogger {
  IonIdentityLogger({File? fileOutput})
      : super(
          requestBody: true,
          requestHeader: true,
          logPrint: fileOutput != null
              ? (message) {
                  fileOutput.writeAsStringSync('$message\n', mode: FileMode.append);
                  developer.log(message.toString());
                }
              : (Object message) => developer.log(message.toString()),
        );

  static const logFileName = 'ion_identity_client_logs.txt';
}
