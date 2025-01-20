// SPDX-License-Identifier: ice License 1.0

sealed class ActionSource {
  const ActionSource({this.anonymous = false});
  final bool anonymous;
}

class ActionSourceCurrentUser extends ActionSource {
  const ActionSourceCurrentUser({super.anonymous});
}

class ActionSourceUser extends ActionSource {
  const ActionSourceUser(this.pubkey, {super.anonymous});
  final String pubkey;
}

class ActionSourceRelayUrl extends ActionSource {
  const ActionSourceRelayUrl(this.url, {super.anonymous});
  final String url;
}

class ActionSourceIndexers extends ActionSource {
  const ActionSourceIndexers({super.anonymous});
}

class ActionSourceUserChat extends ActionSource {
  const ActionSourceUserChat(this.pubkey, {super.anonymous});
  final String pubkey;
}

class ActionSourceCurrentUserChat extends ActionSource {
  const ActionSourceCurrentUserChat({super.anonymous});
}
