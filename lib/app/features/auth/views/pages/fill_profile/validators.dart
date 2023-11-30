String? validateName(String text) {
  if (text.trim().isEmpty) {
    return 'Field is required';
  }

  return null;
}

String? validateNickname(String text) {
  if (text.trim().isEmpty) {
    return 'Field is required';
  } else if (!text.contains('@')) {
    return 'Nickname must contain @';
  } else if (text.length <= 1) {
    return 'Nickname too short';
  }
  return null;
}

String? validateWhoInvited(String text) {
  if (text.trim().isEmpty) {
    return 'Field is required';
  }
  return null;
}
