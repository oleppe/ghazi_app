import 'package:cryptonews/src/config/color_constants.dart';
import 'package:cryptonews/src/utils/AdHelper.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/style.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:share/share.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/news/model/news.dart' show News;

class NewsPage extends StatefulWidget {
  final News news;
  NewsPage({required this.news});
  @override
  _NewsPage createState() => _NewsPage();
}

class _NewsPage extends State<NewsPage> with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  late InterstitialAd _interstitialAd;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();

    InterstitialAd.load(
        adUnitId: AdHelper.interAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            _interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) =>
                  print('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                print('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
              onAdImpression: (InterstitialAd ad) =>
                  print('$ad impression occurred.'),
            );
            _interstitialAd.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));

    super.initState();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd-MM-yy');
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: <Widget>[
                    Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/cryptonews-c3622.appspot.com/o/articles%2F' +
                                widget.news.imagePath +
                                '?alt=media',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 110,
                        ),
                      ],
                    ),
                    Positioned(
                        top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorConstants.nearlyWhite,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32.0),
                                topRight: Radius.circular(32.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: ColorConstants.grey.withOpacity(0.2),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 18, right: 16),
                                    child: Text(
                                      widget.news.name,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: ColorConstants.darkerText,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                widget.news.views.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 22,
                                                  letterSpacing: 0.27,
                                                  color: ColorConstants.grey,
                                                ),
                                              ),
                                              Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                widget.news.like.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 22,
                                                  letterSpacing: 0.27,
                                                  color: ColorConstants.grey,
                                                ),
                                              ),
                                              Icon(
                                                Icons.favorite_border,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                f.format(widget.news.createdAt),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 22,
                                                  letterSpacing: 0.27,
                                                  color: ColorConstants.grey,
                                                ),
                                              ),
                                              Icon(
                                                Icons.date_range_outlined,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        )),
                  ]),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.nearlyWhite,
                    ),
                    child: Html(
                      style: {
                        'div':
                            Style(backgroundColor: ColorConstants.nearlyWhite),
                        // tables will have the below background color
                        "p": Style(
                            color: Colors.grey[600],
                            fontSize: FontSize(15),
                            backgroundColor: ColorConstants.nearlyWhite),
                      },
                      data: widget.news.description,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacity3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, bottom: 16, right: 16),
                      child: InkWell(
                        onTap: () {
                          Share.share(
                              'تابع أحدث الأخبار على تطبيق أخبار كريبتو https://cryptonewsfun.page.link/?link=https://mayakroha.com.ua/iDzQ/?id=' +
                                  widget.news.id +
                                  '&apn=com.ghazi.cryptonews&afl=https://play.google.com/store/apps/details?id=com.ghazi.cryptonews');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 48,
                              height: 48,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorConstants.nearlyWhite,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  border: Border.all(
                                      color:
                                          ColorConstants.grey.withOpacity(0.2)),
                                ),
                                child: Icon(
                                  Icons.share,
                                  color: ColorConstants.nearlyBlue,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: ColorConstants.nearlyBlue,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: ColorConstants.nearlyBlue
                                            .withOpacity(0.5),
                                        offset: const Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'شارك الخبر',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: 0.0,
                                      color: ColorConstants.nearlyWhite,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: ColorConstants.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: ColorConstants.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: ColorConstants.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
