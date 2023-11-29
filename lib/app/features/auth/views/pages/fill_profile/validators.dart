bool validateName(String text) {
  return text.trim().isNotEmpty;
}

bool validateNickname(String text) {
  return text.trim().isNotEmpty && text.contains('@') && text.length > 1;
}

bool validateWhoInvited(String text) {
  return text.trim().isNotEmpty;
}
