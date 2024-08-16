import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class IonServiceLocator {
  static Dio createDio({
    required IonClientConfig config,
  }) {
    final dioOptions = BaseOptions(
      baseUrl: config.origin,
      headers: {
        'X-DFNS-APPID': config.appId,
      },
    );
    final dio = Dio(dioOptions);

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
      ),
    );

    return dio;
  }
}
