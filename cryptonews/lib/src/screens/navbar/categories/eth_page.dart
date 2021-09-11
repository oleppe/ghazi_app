// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/screens/news/news_page.dart';
import 'package:cryptonews/src/utils/AdHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared/modules/news/model/news.dart' show News;
import 'package:shared/modules/news/resources/firebase_news_operations.dart';

import '../../../widgets/hotel_list_view.dart';

class ETHPage extends StatefulWidget {
  final String category;
  ETHPage(this.category, {Key? key}) : super(key: key);

  @override
  _ETHPageState createState() => _ETHPageState();
}

class _ETHPageState extends State<ETHPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late FirebaseNewsOperations newsContext;
  AnimationController? animationController;
  List<News> news = [];
  int pageCount = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoadMore = true;
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
    newsContext = Provider.of<FirebaseNewsOperations>(context);
    super.build(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder<List<News>>(
          future: newsContext.fetchEthNews(widget.category, true),
          builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
            if (snapshot.hasData) {
              if (news.length == 0) {
                news = (snapshot.data)!;
              }
              pageCount = news.length;
              return Column(
                children: [
                  _isAdLoaded
                      ? Container(
                          child: AdWidget(ad: _ad),
                          width: _ad.size.width.toDouble(),
                          height: 72.0,
                          alignment: Alignment.center,
                        )
                      : Container(),
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: isLoadMore,
                      header: WaterDropHeader(
                        complete: Text("تم التحديث",
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text(
                              "أرفع لتحميل المزيد",
                              style: Theme.of(context).textTheme.headline6,
                            );
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("فشل التحميل",
                                style: Theme.of(context).textTheme.headline6);
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("أفلت لتحميل المزيد",
                                style: Theme.of(context).textTheme.headline6);
                          } else {
                            body = Text("لايوجد مزيد من الأخبار",
                                style: Theme.of(context).textTheme.headline6);
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: pageCount,
                        padding: const EdgeInsets.only(top: 8),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= news.length) {
                            return Container();
                          }

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
                                      builder: (_) =>
                                          NewsPage(news: news[index])));
                            },
                            hotelData: news[index],
                            animation: animation,
                            animationController: animationController!,
                          );
                        },
                      ),
                    ),
                  ),
                ],
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

  void _onRefresh() async {
    news =
        await newsContext.fetchEthNews(widget.category, false, refresh: true);
    setState(() {
      isLoadMore = true;
      pageCount = news.length;
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    if (isLoadMore == false) return;
    List<News> loadNews =
        await newsContext.fetchEthNews(widget.category, false);
    if (loadNews.length < 3) isLoadMore = false;

    pageCount = news.length;

    if (mounted)
      setState(() {
        if (loadNews.length < 3) isLoadMore = false;
        news.addAll(loadNews);
      });
    _refreshController.loadComplete();
  }

  @override
  // bool get wantKeepAlive => false;
  bool get wantKeepAlive => true;
}
