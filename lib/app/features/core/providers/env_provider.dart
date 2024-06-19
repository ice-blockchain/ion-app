// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_provider.g.dart';

enum EnvVariable { FOO }

@Riverpod(keepAlive: true)
class Env extends _$Env {
  final String _filename = '.app.env';

  @override
  Future<void> build() async {
    await dotenv.load(fileName: _filename);
    final notDefined = _getNotDefined();
    if (notDefined.isNotEmpty) {
      throw Exception('Invalid ENV value for $notDefined');
    }
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
