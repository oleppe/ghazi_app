import 'package:cryptonews/src/screens/news/news_page.dart';
import 'package:cryptonews/src/utils/AdHelper.dart';
import 'package:cryptonews/src/widgets/contest_tab_header.dart';
import 'package:cryptonews/src/widgets/filter_screen.dart';
import 'package:cryptonews/src/widgets/hotel_list_view.dart';
import 'package:cryptonews/src/widgets/vertical_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/news/model/news.dart' show News;
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/news/resources/firebase_news_operations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AllNews extends StatefulWidget {
  const AllNews({Key? key, required this.selectedCategory}) : super(key: key);
  final String selectedCategory;
  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<News> news = [];
  AnimationController? animationController;
  late FirebaseNewsOperations newsContext;
  int pageCount = 0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
  }

  static final _kAdIndex = 0;

  late BannerAd _ad;

  bool _isAdLoaded = false;

  @override
  Widget build(BuildContext context) {
    newsContext = RepositoryProvider.of<FirebaseNewsOperations>(context);
    super.build(context);
    return Container(
      child: FutureBuilder<List<News>>(
          future: newsContext.fetchNews(widget.selectedCategory),
          builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
            if (snapshot.hasData) {
              if (news.length == 0) news = (snapshot.data)!;
              pageCount = news.length;
              return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            //getSearchBarUI(context),
                            VerticalSlider(imgList: news.take(4).toList()),
                            _isAdLoaded
                                ? Container(
                                    child: AdWidget(ad: _ad),
                                    width: _ad.size.width.toDouble(),
                                    height: 72.0,
                                    alignment: Alignment.center,
                                  )
                                : Container(),
                          ],
                        );
                      }, childCount: 1),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: ContestTabHeader(
                        getFilterBarUI(context),
                      ),
                    ),
                  ];
                },
                body: Container(
                  color: Theme.of(context).backgroundColor,
                  child: ListView.builder(
                    itemCount: pageCount + (_isAdLoaded ? 1 : 0),
                    padding: const EdgeInsets.only(top: 8),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final int count = news.length > 10 ? 10 : news.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController?.forward();
                      return HotelListView(
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewsPage(news: news[index])));
                        },
                        hotelData: news[index],
                        animation: animation,
                        animationController: animationController!,
                      );
                    },
                  ),
                ),
              );
            }
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            );
          }),
    );
  }

  Widget getFilterBarUI(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '52 خبر اليوم',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          // Text('فلتر',
                          //     style: Theme.of(context).textTheme.headline6),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Icon(Icons.sort,
                          //       color: Theme.of(context).primaryColor),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
            color: Colors.grey[500],
          ),
        )
      ],
    );
  }

  bool get wantKeepAlive => true;
}
