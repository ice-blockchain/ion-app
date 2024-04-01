class User {
  const User({
    required this.name,
    required this.nickname,
    this.isFollowed = false,
    this.isVerified = false,
    this.imageUrl,
  });

  final String name;
  final String nickname;
  final bool? isFollowed;
  final bool? isVerified;
  final String? imageUrl;
}

const List<User> creators = <User>[
  User(
    name: 'John Dor',
    nickname: '@johndoe',
    imageUrl: 'https://i.pravatar.cc/150?u=@mysterox',
    isVerified: true,
  ),
  User(
    name: 'Max Krevchov',
    nickname: '@maxkrevchov',
    imageUrl: 'https://i.pravatar.cc/150?u=@maxkrevchov',
    isVerified: true,
  ),
  User(
    name: 'Mark Poland',
    nickname: '@markpoland',
    imageUrl: 'https://i.pravatar.cc/150?u=@markpoland',
  ),
  User(
    name: 'Curtis Washington',
    nickname: '@curtiswashington',
    imageUrl: 'https://i.pravatar.cc/150?u=@curtiswashington',
    isVerified: true,
  ),
  User(
    name: 'Sophie Anderson',
    nickname: '@sophieanderson',
    imageUrl: 'https://i.pravatar.cc/150?u=@sophieanderson',
  ),
  User(
    name: 'Dan Scott',
    nickname: '@danscott',
    imageUrl: 'https://i.pravatar.cc/150?u=@danscott',
    isVerified: true,
  ),
  User(
    name: 'Ava Gardner',
    nickname: '@avagardner',
    imageUrl: 'https://i.pravatar.cc/150?u=@avagardner',
    isVerified: true,
  ),
  User(
    name: 'Daniel Metalo',
    nickname: '@danielmetalo',
    imageUrl: 'https://i.pravatar.cc/150?u=@danielmetalo',
  ),
  User(
    name: 'Max Samson',
    nickname: '@maxsamson',
    imageUrl: 'https://i.pravatar.cc/150?u=@maxsamson',
  ),
];
