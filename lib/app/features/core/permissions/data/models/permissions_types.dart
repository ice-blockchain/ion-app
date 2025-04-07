// SPDX-License-Identifier: ice License 1.0

enum Permission {
  notifications,
  camera,
  photos,
  videos,
  cloud,
  microphone,
}

enum PermissionStatus {
  granted,
  denied,
  limited,
  permanentlyDenied,
  restricted,
  provisional,
  unknown,
  notAvailable,
}
