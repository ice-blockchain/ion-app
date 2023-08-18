// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

enum EnvVariable { FOO }

class EnvService extends GetxService {
  final String filename = '.app.env';

  Future<EnvService> init() async {
    await dotenv.load(fileName: filename);
    final List<EnvVariable> notDefined = _getNotDefined();
    if (notDefined.isNotEmpty) {
      throw Exception('Invalid ENV value for $notDefined');
    }
    return this;
  }

  List<EnvVariable> _getNotDefined() {
    return EnvVariable.values
        .where((EnvVariable element) => dotenv.maybeGet(element.name) == null)
        .toList();
  }

  String get(EnvVariable variable) {
    return dotenv.get(variable.name);
  }
}
