// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_reaction_group.c.freezed.dart';

@freezed
class MessageReactionGroup with _$MessageReactionGroup {
  const factory MessageReactionGroup({
    required String emoji,
    required List<String> pubkeys,
  }) = _MessageReactionGroup;
}

const mockReactionsSimple = [
  MessageReactionGroup(
    emoji: '🔥',
    pubkeys: ['496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807'],
  ),
];

const mockReactionsMany = [
  MessageReactionGroup(
    emoji: '🚀',
    pubkeys: [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
    ],
  ),
  MessageReactionGroup(
    emoji: '😊',
    pubkeys: [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
      '5f010febe730be42d18c3bf9bf3a135f90621dc572175b5c357119533ae9756b',
      'e202c8e80569fc35caee8325e2b6353018c286c9afcb1569ebde635d689bdfd1',
    ],
  ),
  MessageReactionGroup(
    emoji: '😭',
    pubkeys: [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
      '5f010febe730be42d18c3bf9bf3a135f90621dc572175b5c357119533ae9756b',
      'e202c8e80569fc35caee8325e2b6353018c286c9afcb1569ebde635d689bdfd1',
    ],
  ),
  MessageReactionGroup(
    emoji: '😈',
    pubkeys: [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
      '5f010febe730be42d18c3bf9bf3a135f90621dc572175b5c357119533ae9756b',
      'e202c8e80569fc35caee8325e2b6353018c286c9afcb1569ebde635d689bdfd1',
    ],
  ),
  MessageReactionGroup(
    emoji: '😉',
    pubkeys: [
      'f5d70542664e65719b55d8d6250b7d51cbbea7711412dbb524108682cbd7f0d4',
      '496bf22b76e63553b2cac70c44b53867368b4b7612053a2c78609f3144324807',
      '5f010febe730be42d18c3bf9bf3a135f90621dc572175b5c357119533ae9756b',
      'e202c8e80569fc35caee8325e2b6353018c286c9afcb1569ebde635d689bdfd1',
    ],
  ),
];
