// SPDX-License-Identifier: ice License 1.0

sealed class ActionSource {
  const ActionSource();
}

class ActionSourceCurrentUser extends ActionSource {
  const ActionSourceCurrentUser();
}

class ActionSourceUser extends ActionSource {
  ActionSourceUser(this.pubkey);
  final String pubkey;
}

class ActionSourceIndexers extends ActionSource {
  const ActionSourceIndexers();
}