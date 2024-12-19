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

class ActionSourceRelayUrl extends ActionSource {
  ActionSourceRelayUrl(this.url);
  final String url;
}

class ActionSourceIndexers extends ActionSource {
  const ActionSourceIndexers();
}

class ActionSourceUserChat extends ActionSource {
  const ActionSourceUserChat(this.pubkey);
  final String pubkey;
}

class ActionSourceCurrentUserChat extends ActionSource {
  const ActionSourceCurrentUserChat();
}
