class SliderModel {
  SliderModel({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
  });
  DateTime time;
  String imagePath;
  String titleTxt;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  int perNight;
//DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  static List<SliderModel> sliders = <SliderModel>[
    SliderModel(
      imagePath: 'assets/images/articles/hotel_6.png',
      titleTxt: 'البيتكوين إلى صعود',
      subTxt: 'ظهور عدة مؤشرات إيجابية تشير إلى صعود البيتكوين',
    ),
    SliderModel(
      imagePath: 'assets/images/articles/hotel_7.png',
      titleTxt: 'إيلون ماسك: تيسلى تمتلك بيتكوين',
      subTxt: 'علق ايلون مساك على استثمار شركة تيسلى في البيتكوين',
    ),
    SliderModel(
      imagePath: 'assets/images/articles/hotel_8.png',
      titleTxt: 'تزايد الحوالات على شبكة Tron',
      subTxt: 'تم تسجيل رقم قياسي جديد على عدد الحوالات التي تستخدم شبكة Tron',
    ),
    SliderModel(
      imagePath: 'assets/images/articles/hotel_4.png',
      titleTxt: 'تحليل فني لعملة Ethereum',
      subTxt: 'مؤشرات قوية تزيد من فرص وصول Ethereum إلى مستويات 2500-3500',
    ),
    SliderModel(
      imagePath: 'assets/images/articles/hotel_5.png',
      titleTxt: 'عدد مستخدمي العملات الرقمية 221 مليوناً',
      subTxt: 'يصل العدد التقديري لمستخدمي العملات الرقمية إلى 221 مليونًا',
    ),
  ];
}
