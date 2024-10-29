// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

const List<String> mockedPubKeys = [
  'c558c7cc69bbda3c271782b736babc64acd2da258b14f356dbca966cb0b7b89e',
  '91d0411861e83ab3353739bc9da3b33f24dbb741a0f524bdf2ab51648c6866e0',
  'fdfefa96f9591f7f90cf4a6c31630826532a1f0d195a05c9bec604953736b8f9',
  '45addb99d8ec5e34a96d52b850c653dfefe2b49f46f6acadf62592bfe74b6e09',
  'e202c8e80569fc35caee8325e2b6353018c286c9afcb1569ebde635d689bdfd1',
  'e88527b44e3e58e5a092cf30448a9881ecfca3c36bcd503108c2230f7ccf6efa',
  '0b453a2418397af510dae126c9aa0abb118aa559c42ed2faf5c4b98fd207e3c4',
  'ba18b6545357cff8e531accfe1d609a41ef3023fba071db1cbf5a67448c19046',
  '04918dfc36c93e7db6cc0d60f37e1522f1c36b64d3f4b424c532d7c595febbc5',
  '2cb8ae560de65cbed6e6fa956b67d0c9c86da83c22c4eafbe3d10a5284d30cba',
  '129f51895d12ab3c9cdc26cb22bdbb9de918e5f1cff98943f3860ef53a441803',
  'f240c9c2510c3c63d3525ad11ed1307741d0dffecdeb3e5cd7da12396c0c0a86',
  '12348c08f0981121393b3c38241aff5ec66b5ca5d304972912d6c98b04d5e6b5',
  '3fdf8b43d2e6eb59fc399f7cb1b81923d1dff0215d45a11e1c1f279827eaaad8',
  'cef69a32f8ab7e032f4c52e681876af87e7756a04bded1da05cd7eee4935f374',
];

List<String> getRandomPubKeys() {
  final random = Random();
  final randomKeys = <String>{};

  while (randomKeys.length < 6) {
    randomKeys.add(mockedPubKeys[random.nextInt(mockedPubKeys.length)]);
  }

  return randomKeys.toList();
}
