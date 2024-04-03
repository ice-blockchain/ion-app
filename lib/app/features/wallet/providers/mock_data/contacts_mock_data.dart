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
  ),
  ContactData(
    id: '2',
    name: 'Tamila Shotten',
    nickname: 'tamilashotten',
    icon: getIconUrl('tamilashotten'),
    hasIceAccount: true,
    isVerified: false,
  ),
  ContactData(
    id: '3',
    name: 'Jennifer Mary Fishbourne',
    nickname: 'jennymaytofishybee',
    icon: getIconUrl('jennymaytofishybee'),
    hasIceAccount: true,
    isVerified: false,
  ),
  ContactData(
    id: '4',
    name: 'Curtis Washington',
    nickname: 'curtiswashington',
    icon: getIconUrl('curtiswashington'),
    hasIceAccount: true,
    isVerified: true,
  ),
  ContactData(
    id: '5',
    name: 'Miky Hash',
    phoneNumber: '+40 750 741 021',
    icon: getIconUrl('+40 750 741 021'),
    hasIceAccount: false,
    isVerified: false,
  ),
];
