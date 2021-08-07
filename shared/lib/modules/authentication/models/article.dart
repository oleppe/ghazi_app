class Article {
  Article({
    this.imagePath = '',
    this.titleTxt = '',
    this.subText = '',
    this.dist = 1.8,
    this.reviews = 15,
    this.rating = 4.5,
    this.perNight = 180,
    this.time = null,
  });
  DateTime time;
  String imagePath;
  String titleTxt;
  String subText;
  double dist;
  double rating;
  int reviews;
  int perNight;
//DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  static List<Article> hotelList = <Article>[
    Article(
        imagePath: 'assets/images/articles/hotel_1.png',
        titleTxt: 'البيتكوين إلى صعود',
        subText: 'ظهور عدة مؤشرات إيجابية تشير إلى صعود البيتكوين',
        dist: 2.0,
        reviews: 80,
        rating: 4.4,
        perNight: 180,
        time: DateTime.fromMillisecondsSinceEpoch(1560523991 * 1000)),
    Article(
        imagePath: 'assets/images/articles/hotel_2.png',
        titleTxt: 'إيلون ماسك: تيسلى تمتلك بيتكوين',
        subText: 'علق ايلون مساك على استثمار شركة تيسلى في البيتكوين',
        dist: 4.0,
        reviews: 74,
        rating: 4.5,
        perNight: 200,
        time: DateTime.fromMillisecondsSinceEpoch(1560523991 * 1000)),
    Article(
        imagePath: 'assets/images/articles/hotel_3.png',
        titleTxt: 'تزايد الحوالات على شبكة Tron',
        subText:
            'تم تسجيل رقم قياسي جديد على عدد الحوالات التي تستخدم شبكة Tron',
        dist: 3.0,
        reviews: 62,
        rating: 4.0,
        perNight: 60,
        time: DateTime.fromMillisecondsSinceEpoch(1560523991 * 1000)),
    Article(
        imagePath: 'assets/images/articles/hotel_4.png',
        titleTxt: 'تحليل فني لعملة Ethereum',
        subText: 'مؤشرات قوية تزيد من فرص وصول Ethereum إلى مستويات 2500-3500',
        dist: 7.0,
        reviews: 90,
        rating: 4.4,
        perNight: 170,
        time: DateTime.fromMillisecondsSinceEpoch(1560523991 * 1000)),
    Article(
        imagePath: 'assets/images/articles/hotel_5.png',
        titleTxt: 'عدد مستخدمي العملات الرقمية 221 مليوناً',
        subText: 'يصل العدد التقديري لمستخدمي العملات الرقمية إلى 221 مليونًا',
        dist: 2.0,
        reviews: 240,
        rating: 4.5,
        perNight: 200,
        time: DateTime.fromMillisecondsSinceEpoch(1560523991 * 1000)),
  ];
}
