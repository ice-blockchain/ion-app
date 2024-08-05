import 'package:ice/app/features/wallet/model/contact_data.dart';

String getIconUrl(String name) {
  return 'https://i.pravatar.cc/100?u=@$name';
}

final List<ContactData> mockedContactDataArray = <ContactData>[
  ContactData(
    id: '1',
    name: 'Samantha Howard',
    nickname: 'sammyathowards',
    icon: getIconUrl('sammyathowards'),
    hasIceAccount: true,
    isVerified: true,
    lastSeen: DateTime.now().subtract(Duration.zero),
  ),
  ContactData(
    id: '2',
    name: 'Tamila Shotten',
    nickname: 'tamilashotten',
    icon: getIconUrl('tamilashotten'),
    hasIceAccount: true,
    isVerified: false,
    lastSeen: DateTime.now().subtract(Duration.zero),
  ),
  ContactData(
    id: '3',
    name: 'Jennifer Mary Fishbourne',
    nickname: 'jennymaytofishybee',
    icon: getIconUrl('jennymaytofishybee'),
    hasIceAccount: true,
    isVerified: false,
    lastSeen: DateTime.now().subtract(const Duration(minutes: 23)),
  ),
  ContactData(
    id: '4',
    name: 'Curtis Washington',
    nickname: 'curtiswashington',
    icon: getIconUrl('curtiswashington'),
    hasIceAccount: true,
    isVerified: true,
    lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  ContactData(
    id: '5',
    name: 'Miky Hash',
    nickname: 'mikki',
    phoneNumber: '+40 750 741 021',
    icon: getIconUrl('+40 750 741 021'),
    hasIceAccount: false,
    isVerified: false,
    lastSeen: DateTime.parse('2023-05-23'),
  ),
  ContactData(
    id: '6',
    name: 'Curtis Washington',
    nickname: 'curtiswashington',
    icon: getIconUrl('curtiswashington'),
    hasIceAccount: false,
    isVerified: true,
    lastSeen: DateTime.now().subtract(const Duration(days: 1)),
  ),
  ContactData(
    id: '7',
    name: 'Cristian Lower',
    nickname: 'cristianlower',
    icon: getIconUrl('cristianlower'),
    hasIceAccount: false,
    isVerified: true,
    lastSeen: DateTime.now().subtract(const Duration(days: 7)),
  ),
  ContactData(
    id: '8',
    name: 'Alicia Wernet',
    nickname: 'aliciawernet',
    icon: getIconUrl('aliciawernet'),
    hasIceAccount: true,
    isVerified: true,
    lastSeen: DateTime.now().subtract(const Duration(days: 14)),
  ),
  ContactData(
    id: '9',
    name: 'Tamila Shotten',
    nickname: 'tamilashotten',
    icon: getIconUrl('tamilashotten'),
    hasIceAccount: true,
    isVerified: true,
    lastSeen: DateTime.now().subtract(const Duration(days: 30)),
  ),
  ContactData(
    id: '10',
    name: 'Michael Smith',
    nickname: 'michaelsmith',
    icon: getIconUrl('michaelsmith'),
    hasIceAccount: true,
    isVerified: true,
    lastSeen: DateTime.now().subtract(const Duration(days: 60)),
  ),
];

extension ContactDataExtension on ContactData {
  bool get isUserOnline {
    if (lastSeen == null) return false;
    return DateTime.now().difference(lastSeen!).inMinutes < 5;
  }
}
