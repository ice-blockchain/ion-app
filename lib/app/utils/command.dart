// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_command/flutter_command.dart';

typedef StateCommand<T> = Command<T, T>;

StateCommand<T> stateCommand<T>(T initialValue) => Command.createSync(
      (s) => s,
      initialValue: initialValue,
    );
