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
    imageUrl: 'https://live.staticflickr.com/4128/5096218360_7aef7a0181_z.jpg',
    isVerified: true,
  ),
  User(
    name: 'Max Krevchov',
    nickname: '@maxkrevchov',
    imageUrl:
        'https://www.artmajeur.com/medias/standard/a/v/ava-moazen-artbyava/artwork/17406766_7_69db939b-4b56-4412-8806-e39441009ef2.jpg',
    isVerified: true,
  ),
  User(
    name: 'Mark Poland',
    nickname: '@markpoland',
    imageUrl:
        'https://farmersmarketcoalition.org/wp-content/uploads/2022/03/ava-3.jpg',
  ),
  User(
    name: 'Curtis Washington',
    nickname: '@curtiswashington',
    imageUrl:
        'https://do2ufdrk7dzyk.cloudfront.net/images/2022/7/26/Poti_Sua_ava.jpg?width=300',
    isVerified: true,
  ),
  User(
    name: 'Sophie Anderson',
    nickname: '@sophieanderson',
    imageUrl:
        'https://www.creativefabrica.com/wp-content/uploads/2022/10/19/Sophie-Andersons-Beautiful-Dark-Skin-African-Queen-Wearing-Traditional-Crown-42396595-1.png',
  ),
  User(
    name: 'Dan Scott',
    nickname: '@danscott',
    imageUrl:
        'https://i0.wp.com/fashionablymale.net/wp-content/uploads/2014/08/david-koch-by-alinejaqueline-tappia2.jpg?fit=640%2C960&ssl=1&resize=350%2C200',
    isVerified: true,
  ),
  User(
    name: 'Ava Gardner',
    nickname: '@avagardner',
    imageUrl:
        'https://imgix.ranker.com/list_img_v2/2179/1222179/original/men-who-ava-gardner-has-dated-u1?auto=format&q=50&fit=crop&fm=pjpg&dpr=2&crop=faces&h=185.86387434554973&w=355',
    isVerified: true,
  ),
  User(
    name: 'Daniel Metalo',
    nickname: '@danielmetalo',
    imageUrl:
        'https://imageio.forbes.com/specials-images/imageserve/627c35a4119fba7ddf23ad23/Thibault-hifi/960x0.jpg?height=952&width=711&fit=bounds',
  ),
  User(
    name: 'Max Samson',
    nickname: '@maxsamson',
    imageUrl:
        'https://storage.googleapis.com/pai-images/9770a8c249e142d6a173e4276e2c1de7.jpeg',
  ),
];
