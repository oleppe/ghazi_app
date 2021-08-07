class AllImages {
  AllImages._();
  static AllImages _instance = AllImages._();
  factory AllImages() => _instance;

  String image = 'assets/image';
  String logo = 'assets/images/intro.png';
  String intro = 'assets/images/intro.png';
  String user = 'assets/images/user2.png';
  String welcome1 = 'assets/images/welcome/img1.jpg';
  String welcome2 = 'assets/images/welcome/img2.jpg';
  String welcome3 = 'assets/images/welcome/img3.jpg';
  String kDefaultImage =
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png';
}
