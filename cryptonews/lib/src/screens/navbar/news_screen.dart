import 'package:cryptonews/src/screens/TopBar/all_news.dart';
import 'package:cryptonews/src/screens/navbar/categories/alt_coin_page.dart';
import 'package:cryptonews/src/screens/navbar/categories/page_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tab_bar/custom_tab_bar_lib.dart';
import 'package:flutter_custom_tab_bar/indicator/standard_indicator.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/category/model/category.dart';
import 'package:shared/modules/category/resources/firebase_crud_operations.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  final int pageCount = 7;
  final PageController _controller = PageController();
  List<Category> categories = [];
  late String selectedCategory;
  StandardIndicatorController controller = StandardIndicatorController();

  Widget getTabbarChild(BuildContext context, TabBarItemInfo data) {
    return TabBarItem(
        tabbarItemInfo: data,
        delegate: ScaleTransformDelegate(
            maxScale: 1.1,
            delegate: ColorTransformDelegate(
              normalColor: Colors.black,
              highlightColor: Theme.of(context).accentColor,
              builder: (context, color) {
                return Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 85),
                    child: (Text(
                      categories[data.itemIndex!].name,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                      ),
                    )));
              },
            )));
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<FirebaseCRUDoperations>(context);
    return Container(
      child: Stack(
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: 35,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: FutureBuilder<List<Category>>(
                      future: category.fetchBookStores(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        if (snapshot.hasData) {
                          categories = (snapshot.data)!;
                          return CustomTabBar(
                            defaultPage: 0,
                            itemCount: categories.length,
                            builder: getTabbarChild,
                            indicator: StandardIndicator(
                              indicatorWidth: 60,
                              indicatorColor: Theme.of(context).accentColor,
                              controller: controller,
                            ),
                            pageController: _controller,
                            tabbarController: controller,
                          );
                        } else {
                          return Text('fetching');
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: PageView.builder(
                        controller: _controller,
                        itemCount: pageCount,
                        itemBuilder: (context, index) {
                          if (categories.length > 0)
                            selectedCategory = categories[index].id;
                          if (index == 0)
                            return AllNews(
                                selectedCategory: "yFIjAzWnl38hcy3BxnGV");
                          else if (index == 1)
                            return PageItem(selectedCategory);
                          else if (index == 2)
                            return AltCoinPage(selectedCategory);
                          return AltCoinPage(selectedCategory);
                        }))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: Theme.of(context).primaryColorLight,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'London...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 20, color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
