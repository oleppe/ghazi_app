import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/modules/category/model/category.dart';
import 'package:shared/modules/news/model/news.dart' show News;
import 'package:shared/modules/news/resources/firebase_news_operations.dart';

import '../../../widgets/hotel_list_view.dart';

class AltCoinPage extends StatefulWidget {
  final String category;
  AltCoinPage(this.category, {Key? key}) : super(key: key);

  @override
  _AltCoinPageState createState() => _AltCoinPageState();
}

class _AltCoinPageState extends State<AltCoinPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late FirebaseNewsOperations newsContext;
  late ScrollController listController;
  AnimationController? animationController;
  List<News> news = [];
  int pageCount = 0;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    listController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    newsContext = Provider.of<FirebaseNewsOperations>(context);
    super.build(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: FutureBuilder<List<News>>(
          future: newsContext.fetchNews(widget.category),
          builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
            if (snapshot.hasData) {
              if (news!.length == 0) news = (snapshot.data)!;
              pageCount = news.length;
              return ListView.builder(
                controller: listController,
                itemCount: pageCount,
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
                    callback: () {},
                    hotelData: news[index],
                    animation: animation,
                    animationController: animationController!,
                  );
                },
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

  void _scrollListener() async {
    if (listController.offset >= listController.position.maxScrollExtent &&
        !listController.position.outOfRange) {
      List<News> loadNews = await newsContext.fetchNews(widget.category);
      setState(() {
        news.addAll(loadNews);
        pageCount += 3;
      });
    }
  }

  @override
  // bool get wantKeepAlive => false;
  bool get wantKeepAlive => true;
}
