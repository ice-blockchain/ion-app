class User {
  const User({
    required this.name,
    required this.nickname,
    required this.id,
    this.isVerified = false,
    this.imageUrl,
  });

  final String name;
  final String nickname;
  final bool? isVerified;
  final String? imageUrl;
  final String id;
}

const List<User> creators = <User>[
  User(
    name: 'John Dor',
    nickname: '@johndoe',
    imageUrl: 'https://i.pravatar.cc/150?u=@mysterox',
    isVerified: true,
    id: '1',
  ),
  User(
    name: 'Max Krevchov',
    nickname: '@maxkrevchov',
    imageUrl: 'https://i.pravatar.cc/150?u=@maxkrevchov',
    isVerified: true,
    id: '2',
  ),
  User(
    name: 'Mark Poland',
    nickname: '@markpoland',
    imageUrl: 'https://i.pravatar.cc/150?u=@markpoland',
    id: '3',
  ),
  User(
    name: 'Curtis Washington',
    nickname: '@curtiswashington',
    imageUrl: 'https://i.pravatar.cc/150?u=@curtiswashington',
    isVerified: true,
    id: '4',
  ),
  User(
    name: 'Sophie Anderson',
    nickname: '@sophieanderson',
    imageUrl: 'https://i.pravatar.cc/150?u=@sophieanderson',
    id: '5',
  ),
  User(
    name: 'Dan Scott',
    nickname: '@danscott',
    imageUrl: 'https://i.pravatar.cc/150?u=@danscott',
    isVerified: true,
    id: '6',
  ),
  User(
    name: 'Ava Gardner',
    nickname: '@avagardner',
    imageUrl: 'https://i.pravatar.cc/150?u=@avagardner',
    isVerified: true,
    id: '7',
  ),
  User(
    name: 'Daniel Metalo',
    nickname: '@danielmetalo',
    imageUrl: 'https://i.pravatar.cc/150?u=@danielmetalo',
    id: '8',
  ),
  User(
    name: 'Max Samson',
    nickname: '@maxsamson',
    imageUrl: 'https://i.pravatar.cc/150?u=@maxsamson',
    id: '9',
  ),
];
