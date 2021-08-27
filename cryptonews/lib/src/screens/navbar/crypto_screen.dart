// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/config/color_constants.dart';
import 'package:cryptonews/src/config/image_constants.dart';
import 'package:cryptonews/src/screens/crypto/image_keys.dart';
import 'package:cryptonews/src/widgets/contest_tab_header.dart';
import 'package:cryptonews/src/widgets/vertical_coin.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "dart:collection";
import "dart:async";
import "package:intl/intl.dart";
import 'package:shared/local_database.dart';
import "dart:convert";
import "package:web_socket_channel/io.dart";
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import "package:auto_size_text/auto_size_text.dart";
import "dart:math";
import "package:syncfusion_flutter_charts/charts.dart";
//import "key.dart";
import "package:flutter_svg/flutter_svg.dart";

String _api = "https://api.coincap.io/v2/";
HashMap<String, ValueNotifier<num>> _valueNotifiers =
    HashMap<String, ValueNotifier<num>>();
List<String> _savedCoins = [];

String symbol = '';
bool _loading = false;
//;
Future<dynamic> _apiGet(String link) async {
  return json
      .decode((await http.get(Uri.parse(Uri.encodeFull("$_api$link")))).body);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey[700]),
        debugShowCheckedModeBanner: false,
        home: CryptoScreen(true));
  }
}

String sortingBy = '';

class CryptoScreen extends StatefulWidget {
  final bool savedPage;

  CryptoScreen(this.savedPage) : super(key: ValueKey(savedPage));

  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

typedef int SortType(String s1, String s2);
HashMap<String, Map<String, Comparable>> _coinData =
    HashMap<String, Map<String, Comparable>>();

SortType sortBy(String s) {
  String sortVal = s.substring(0, s.length - 1);
  bool ascending = s.substring(s.length - 1).toLowerCase() == "a";
  return (s1, s2) {
    if (s == "custom") {
      return _savedCoins.indexOf(s1) - _savedCoins.indexOf(s2);
    }
    Map<String, Comparable>? m1 = _coinData[ascending ? s1 : s2],
        m2 = _coinData[ascending ? s2 : s1];
    dynamic v1 = m1![sortVal], v2 = m2![sortVal];
    if (sortVal == "name") {
      v1 = v1.toUpperCase();
      v2 = v2.toUpperCase();
    }
    int comp = v1.compareTo(v2);
    if (comp == 0) {
      return sortBy("nameA")(s1, s2);
    }
    return comp;
  };
}

class _CryptoScreenState extends State<CryptoScreen> {
  bool searching = false;

  List<String> sortedKeys = [];
  String prevSearch = "";
  late IOWebSocketChannel socket;
  List<Map<String, Comparable>?> top = [];
  Future<void> setUpData() async {
    _loading = true;
    setState(() {});
    try {
      var data = (await _apiGet("assets?limit=50"))["data"];
      data.forEach((e) {
        String id = e["id"];
        _coinData[id] = e.cast<String, Comparable>();
        _valueNotifiers[id] = ValueNotifier(0);
        for (String s in e.keys) {
          if (e[s] == null) {
            e[s] = (s == "changePercent24Hr" ? -1000000 : -1);
          } else if (!["id", "symbol", "name"].contains(s)) {
            // ignore: deprecated_member_use
            e[s] = num.parse(e[s], (e) => 0);
          }
        }
      });
      _loading = false;
      setState(() {});
      //socket?.sink?.close();
      socket =
          IOWebSocketChannel.connect("wss://ws.coincap.io/prices?assets=ALL");
      socket.stream.listen((message) {
        Map<String, dynamic> data = json.decode(message);
        data.forEach((s, v) {
          if (_coinData[s] != null) {
            num old = _coinData[s]!["priceUsd"] as num;
            _coinData[s]!["priceUsd"] = num.parse(v);
            _valueNotifiers[s]!.value = old;
          }
        });
      });
    } catch (e) {
      _loading = false;
      setState(() {});
    }
  }

  void reset() {
    if (widget.savedPage) {
      sortedKeys = List.from(_savedCoins)..sort(sortBy(sortingBy));
    } else {
      sortedKeys = List.from(_coinData.keys)..sort(sortBy(sortingBy));
    }
    setState(() {});
  }

  void search(String s) {
    scrollController.jumpTo(0.0);
    reset();
    moving = false;
    moveWith = '';
    for (int i = 0; i < sortedKeys.length; i++) {
      String key = sortedKeys[i];
      String name = _coinData[key]!["name"] as String;
      String ticker = _coinData[key]!["symbol"] as String;
      if (![name, ticker]
          .any((w) => w.toLowerCase().contains(s.toLowerCase()))) {
        sortedKeys.removeAt(i--);
      }
    }
    prevSearch = s;
    setState(() {});
  }

  void sort(String s) {
    scrollController.jumpTo(0.0);
    moving = false;
    moveWith = '';
    sortingBy = s;
    setState(() {
      sortedKeys.sort(sortBy(s));
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.savedPage != false) setUpData();
    sortingBy = widget.savedPage ? "custom" : "marketCapUsdD";
    reset();
  }

  late Timer searchTimer = Timer(Duration(milliseconds: 500), () {
    search('');
  });
  ScrollController scrollController = ScrollController();
  List<PopupMenuItem> l = [
    PopupMenuItem<String>(child: const Text("اسم تصاعدي"), value: "nameA"),
    PopupMenuItem<String>(child: const Text("اسم تنازلي"), value: "nameD"),
    PopupMenuItem<String>(child: const Text("سعر تصاعدي"), value: "priceUsdA"),
    PopupMenuItem<String>(child: const Text("سعر تنازلي"), value: "priceUsdD"),
    PopupMenuItem<String>(
        child: const Text("قيمة سوقية تصاعدي"), value: "marketCapUsdA"),
    PopupMenuItem<String>(
        child: const Text("قيمة سوقية تنازلي"), value: "marketCapUsdD"),
    PopupMenuItem<String>(
        child: const Text("24H تغير تصاعدي"), value: "changePercent24HrA"),
    PopupMenuItem<String>(
        child: const Text("24H تغير تنازلي"), value: "changePercent24HrD")
  ];
  @override
  Widget build(BuildContext context) {
    if (widget.savedPage) {
      try {} catch (e) {
        l.insert(
            0,
            PopupMenuItem<String>(
                child: const Text("Custom"), value: "custom"));
      }
    }
    setState(() {
      _savedCoins = Provider.of<HomeModel>(context).savedCoins;

      if (widget.savedPage) {
        sortedKeys = List.from(_savedCoins)..sort(sortBy(sortingBy));
      } else {
        sortedKeys = List.from(_coinData.keys)..sort(sortBy(sortingBy));
      }
      List<String> keysCoin = List.from(_coinData.keys)
        ..sort(sortBy('marketCapUsdD'));
      top.clear();
      for (var i = 0; i < _coinData.length; i++) {
        top.add(_coinData[keysCoin[i]]);
        if (i == 9) break;
      }
    });

    Widget ret = Scaffold(
        appBar: AppBar(
          bottom: _loading
              ? PreferredSize(
                  preferredSize: Size(double.infinity, 3.0),
                  child:
                      Container(height: 3.0, child: LinearProgressIndicator()))
              : null,
          title: searching
              ? TextField(
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "البحث",
                      hintStyle: Theme.of(context).textTheme.headline6,
                      border: InputBorder.none),
                  style: Theme.of(context).textTheme.headline6,
                  onChanged: (s) {
                    searchTimer.cancel();
                    searchTimer = Timer(Duration(milliseconds: 500), () {
                      search(s);
                    });
                  },
                  onSubmitted: (s) {
                    search(s);
                  })
              : Text(
                  widget.savedPage ? "العملات الرقمية" : "جميع العملات",
                  style: Theme.of(context).textTheme.headline2,
                ),
          actions: [
            IconButton(
                icon: Icon(searching ? Icons.close : Icons.search, size: 25),
                onPressed: () {
                  if (_loading) {
                    return;
                  }
                  setState(() {
                    if (searching) {
                      searching = false;
                      reset();
                    } else {
                      searching = true;
                    }
                  });
                }),
            Container(
                width: 35.0,
                child: PopupMenuButton(
                    itemBuilder: (BuildContext context) => l,
                    child: Icon(Icons.sort, size: 25),
                    onSelected: (s) {
                      if (_loading) {
                        return;
                      }
                      sort(s as String);
                    })),
            IconButton(
                icon: Icon(Icons.refresh, size: 25),
                onPressed: () async {
                  if (_loading) {
                    return;
                  }
                  searching = false;
                  sortingBy = widget.savedPage ? "custom" : "marketCapUsdD";
                  await setUpData();
                  reset();
                })
          ],
        ),

        // widget.savedPage
        //                     ? ListView(
        //                         physics: ClampingScrollPhysics(),
        //                         children: [
        //                           Container()
        //                         ])
        //                     : Container(),
        body: !_loading
            ? Consumer<HomeModel>(builder: (context, model, child) {
                return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: widget.savedPage
                        ? NestedScrollView(
                            controller: scrollController,
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[
                                SliverPersistentHeader(
                                  pinned: true,
                                  floating: true,
                                  delegate: ContestTabHeader(
                                    getTopBarUI(context),
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        //getSearchBarUI(context),
                                        VerticalCoin(imgList: top),
                                      ],
                                    );
                                  }, childCount: 1),
                                ),
                                SliverPersistentHeader(
                                  pinned: true,
                                  floating: true,
                                  delegate: ContestTabHeader(
                                    getBarUI(context),
                                  ),
                                ),
                              ];
                            },
                            body: _savedCoins.length > 0
                                ? ListView.builder(
                                    itemBuilder: (context, i) =>
                                        Crypto(sortedKeys[i], widget.savedPage),
                                    itemCount: sortedKeys.length,
                                  )
                                : Center(
                                    child: Text(
                                      'المفضلة فارغة',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, i) =>
                                Crypto(sortedKeys[i], widget.savedPage),
                            itemCount: sortedKeys.length,
                            controller: scrollController));
              })
            : Container(),
        floatingActionButton: widget.savedPage
            ? !_loading
                ? FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      moving = false;
                      moveWith = '';
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CryptoScreen(false)))
                          .then((d) {
                        sortingBy = "custom";
                        searching = false;
                        reset();
                        scrollController.jumpTo(0.0);
                      });
                    },
                    child: Icon(Icons.add),
                    heroTag: "newPage")
                : null
            : FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  scrollController.jumpTo(0.0);
                },
                child: Icon(Icons.arrow_upward),
                heroTag: "jump"));
    if (!widget.savedPage) {
      ret = WillPopScope(
          child: ret, onWillPop: () => Future<bool>(() => !_loading));
    }
    return ret;
  }

  Widget getBarUI(BuildContext context) {
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
                      'العملات المفضلة',
                      style: Theme.of(context).textTheme.headline4,
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
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text('فلتر',
                              style: Theme.of(context).textTheme.headline6),
                          Container(
                              width: 35.0,
                              child: PopupMenuButton(
                                  itemBuilder: (BuildContext context) => l,
                                  child: Icon(Icons.sort,
                                      size: 25,
                                      color: Theme.of(context).primaryColor),
                                  onSelected: (s) {
                                    if (_loading) {
                                      return;
                                    }
                                    sort(s as String);
                                  })),
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

  Widget getTopBarUI(BuildContext context) {
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
                const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'أفضل العملات',
                      style: Theme.of(context).textTheme.headline4,
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
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Row(
                        children: <Widget>[],
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
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class PriceText extends StatefulWidget {
  final String id;

  PriceText(this.id);

  @override
  _PriceTextState createState() => _PriceTextState();
}

class _PriceTextState extends State<PriceText> {
  late Color? changeColor = Colors.grey;
  late Timer updateTimer = Timer(Duration(milliseconds: 400), () {
    if (disp) {
      return;
    }
    setState(() {
      changeColor = Colors.grey;
    });
  });
  bool disp = false;
  late ValueNotifier<num>? coinNotif;
  late Map<String, dynamic>? data;

  void update() {
    if (data!["priceUsd"].compareTo(coinNotif!.value) > 0) {
      changeColor = Colors.green;
    } else {
      changeColor = Colors.red;
    }
    setState(() {});
    updateTimer.cancel();
    updateTimer = Timer(Duration(milliseconds: 400), () {
      if (disp) {
        return;
      }
      setState(() {
        changeColor = Colors.grey;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    data = _coinData[widget.id];
    coinNotif = _valueNotifiers[widget.id];
    coinNotif!.addListener(update);
  }

  @override
  void dispose() {
    super.dispose();
    disp = true;
    coinNotif!.removeListener(update);
  }

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(
        name: Provider.of<HomeModel>(context).symbol);
    num price =
        data!["priceUsd"] * Provider.of<HomeModel>(context).exchangeRate;
    return Text(
        price >= 0
            ? format.currencySymbol +
                NumberFormat.currency(
                        symbol: '',
                        decimalDigits: price > 1
                            ? price < 100000
                                ? 2
                                : 0
                            : price > .000001
                                ? 6
                                : 7)
                    .format(price)
            : "N/A",
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: changeColor));
  }
}

bool moving = false;
String moveWith = '';

class Crypto extends StatefulWidget {
  final String id;
  final bool savedPage;

  Crypto(this.id, this.savedPage)
      : super(key: ValueKey(id + savedPage.toString()));

  @override
  _CryptoState createState() => _CryptoState();
}

class _CryptoState extends State<Crypto> {
  late bool saved;
  late Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = _coinData[widget.id];
    saved = _savedCoins.contains(widget.id);
  }

  void move(List<String> coins) {
    int moveTo = coins.indexOf(widget.id);
    int moveFrom = coins.indexOf(moveWith);
    coins.removeAt(moveFrom);
    coins.insert(moveTo, moveWith);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    num mCap = data!["marketCapUsd"];
    mCap *= Provider.of<HomeModel>(context).exchangeRate;
    num change = data!["changePercent24Hr"];
    String shortName = data!["symbol"];

    var format = NumberFormat.simpleCurrency(
        name: Provider.of<HomeModel>(context).symbol);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
          decoration: BoxDecoration(
            color: ColorConstants.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: ColorConstants.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          height: !Provider.of<HomeModel>(context).settings["disableGraphs"]
              ? 90.0
              : 100.0,
          padding:
              EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: GestureDetector(
              onLongPress: () {
                if (sortingBy == "custom") {
                  context
                      .findAncestorStateOfType<_CryptoScreenState>()!
                      .setState(() {
                    moving = true;
                    moveWith = widget.id;
                  });
                } else if (!widget.savedPage) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemInfo(widget.id)));
                }
              },
              child: Dismissible(
                  background: Container(color: Colors.redAccent),
                  key: ValueKey(widget.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (d) {
                    _savedCoins.remove(widget.id);
                    Provider.of<HomeModel>(context)
                        .updateSavedCoin(_savedCoins);
                    context
                        .findAncestorStateOfType<_CryptoScreenState>()!
                        .sortedKeys
                        .remove(widget.id);
                    context
                        .findAncestorStateOfType<_CryptoScreenState>()!
                        .setState(() {});
                  },
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0))),
                    onPressed: () {
                      if (widget.savedPage) {
                        if (moving) {
                          move(_savedCoins);
                          move(context
                              .findAncestorStateOfType<_CryptoScreenState>()!
                              .sortedKeys);
                          setState(() {
                            moveWith = '';
                            moving = false;
                          });
                          context
                              .findAncestorStateOfType<_CryptoScreenState>()!
                              .setState(() {});
                          Provider.of<HomeModel>(context, listen: false)
                              .updateSavedCoin(_savedCoins);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemInfo(widget.id)));
                        }
                      } else {
                        setState(() {
                          if (saved) {
                            saved = false;
                            _savedCoins.remove(widget.id);
                            Provider.of<HomeModel>(context, listen: false)
                                .updateSavedCoin(_savedCoins);
                          } else {
                            saved = true;
                            _savedCoins.add(widget.id);
                            Provider.of<HomeModel>(context, listen: false)
                                .updateSavedCoin(_savedCoins);
                          }
                        });
                      }
                    },
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
                    color: saved && moveWith != widget.id
                        ? ColorConstants.nearlyWhite
                        : ColorConstants.notWhite,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Row(children: [
                                ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: width / 3),
                                    child: AutoSizeText(data!["name"],
                                        maxLines: 2,
                                        minFontSize: 0.0,
                                        maxFontSize: 17.0,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)),
                              ]),
                              Container(height: 5.0),
                              Row(children: [
                                FadeInImage(
                                    image: !blacklist.contains(widget.id)
                                        ? NetworkImage(
                                            "https://static.coincap.io/assets/icons/${shortName.toLowerCase()}@2x.png")
                                        : Image.asset(AllImages().logo).image,
                                    placeholder: AssetImage(AllImages().logo),
                                    fadeInDuration:
                                        const Duration(milliseconds: 100),
                                    height: 32.0,
                                    width: 32.0),
                                Container(width: 4.0),
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: width / 3 - 40),
                                    child: AutoSizeText(shortName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        maxLines: 1))
                              ])
                            ])),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PriceText(widget.id),
                              Text(
                                  (mCap >= 0
                                      ? mCap > 1
                                          ? format.currencySymbol +
                                              NumberFormat.currency(
                                                      symbol: "",
                                                      decimalDigits: 0)
                                                  .format(mCap)
                                          : format.currencySymbol +
                                              mCap.toStringAsFixed(2)
                                      : "N/A"),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              SizedBox(
                                height: 5,
                              ),
                              Provider.of<HomeModel>(context)
                                      .settings["disableGraphs"]
                                  ? linkMap[shortName] != null &&
                                          !blacklist.contains(widget.id)
                                      ? SvgPicture.network(
                                          "https://www.coingecko.com/coins/${linkMap[shortName] ?? linkMap[widget.id]}/sparkline",
                                          placeholderBuilder: (BuildContext
                                                  context) =>
                                              Container(width: 0, height: 35.0),
                                          width: 105.0,
                                          height: 35.0)
                                      : Container(height: 35.0)
                                  : Container(),
                            ]),
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                              change != -1000000.0
                                  ? Text(
                                      ((change >= 0) ? "+" : "") +
                                          change.toStringAsFixed(3) +
                                          "\%",
                                      style: TextStyle(
                                          color: ((change >= 0)
                                              ? Colors.green
                                              : Colors.red)))
                                  : Text("N/A"),
                              Container(width: 2),
                              !widget.savedPage
                                  ? Icon(saved ? Icons.check : Icons.add)
                                  : Container()
                            ]))
                      ],
                    ),
                  )))),
    );
  }
}

class ItemInfo extends StatefulWidget {
  final String id;

  ItemInfo(this.id);

  @override
  _ItemInfoState createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = _coinData[widget.id];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
                title: Text(data!["name"],
                    style: Theme.of(context).textTheme.headline2),
                backgroundColor: ColorConstants.nearlyWhite,
                actions: [
                  Row(children: [
                    FadeInImage(
                      image: NetworkImage(
                          "https://static.coincap.io/assets/icons/${data!["symbol"].toLowerCase()}@2x.png"),
                      placeholder: AssetImage(AllImages().logo),
                      fadeInDuration: const Duration(milliseconds: 100),
                      height: 32.0,
                      width: 32.0,
                    ),
                    Container(width: 10.0)
                  ])
                ]),
            body: Container(
              color: ColorConstants.nearlyWhite,
              child: ListView(physics: ClampingScrollPhysics(), children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 0, left: 10, right: 10),
                  child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: ColorConstants.grey.withOpacity(0.2),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 3, bottom: 3),
                      child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          tabs: [
                            Tab(
                                icon: AutoSizeText("  1D  ",
                                    maxFontSize: 15.0,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    minFontSize: 0.0)),
                            Tab(
                                icon: AutoSizeText("  1W  ",
                                    maxFontSize: 15.0,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    minFontSize: 0.0)),
                            Tab(
                                icon: AutoSizeText("  1M  ",
                                    maxFontSize: 15.0,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    minFontSize: 0.0)),
                            Tab(
                                icon: AutoSizeText("  6M  ",
                                    maxFontSize: 15.0,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    minFontSize: 0.0)),
                            Tab(
                                icon: AutoSizeText("  1Y  ",
                                    maxFontSize: 15.0,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    minFontSize: 0.0))
                          ])),
                ),
                Container(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: ColorConstants.nearlyWhite,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: ColorConstants.grey.withOpacity(0.2),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      height: 200.0,
                      padding: EdgeInsets.only(
                        right: 10.0,
                        top: 10,
                      ),
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            SimpleTimeSeriesChart(widget.id, 1, "m5"),
                            SimpleTimeSeriesChart(widget.id, 7, "m30"),
                            SimpleTimeSeriesChart(widget.id, 30, "h2"),
                            SimpleTimeSeriesChart(widget.id, 182, "h12"),
                            SimpleTimeSeriesChart(widget.id, 364, "d1")
                          ])),
                ),
                Container(height: 10.0),
                Row(children: [
                  Expanded(child: Info("Price", widget.id, "priceUsd")),
                  Expanded(child: Info("Market Cap", widget.id, "marketCapUsd"))
                ]),
                Row(children: [
                  Expanded(child: Info("Supply", widget.id, "supply")),
                  Expanded(child: Info("Max Supply", widget.id, "maxSupply")),
                ]),
                Row(children: [
                  Expanded(
                      child:
                          Info("24h Change", widget.id, "changePercent24Hr")),
                  Expanded(
                      child: Info("24h Volume", widget.id, "volumeUsd24Hr"))
                ]),
              ]),
            )));
  }
}

class Info extends StatefulWidget {
  final String title, ticker, id;

  Info(this.title, this.ticker, this.id);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  dynamic value;

  late ValueNotifier<num>? coinNotif;

  late Color? textColor = Colors.grey;

  late Timer updateTimer = Timer(Duration(milliseconds: 400), () {
    if (disp) {
      return;
    }
    setState(() {
      textColor = Colors.grey;
    });
  });

  bool disp = false;

  late Map<String, dynamic>? data;

  void update() {
    if (data!["priceUsd"].compareTo(coinNotif!.value) > 0) {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }
    setState(() {});
    updateTimer.cancel();
    updateTimer = Timer(Duration(milliseconds: 400), () {
      if (disp) {
        return;
      }
      setState(() {
        textColor = Colors.grey;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.id == "priceUsd") {
      coinNotif = _valueNotifiers[widget.ticker];
      coinNotif!.addListener(update);
    } else {
      textColor = Colors.grey;
    }
    data = _coinData[widget.ticker];
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.id == "priceUsd") {
      disp = true;
      coinNotif!.removeListener(update);
    }
  }

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.simpleCurrency(
        name: Provider.of<HomeModel>(context).symbol);
    dynamic value = data![widget.id];
    String text;
    if ((widget.id == "changePercent24Hr" && value == -1000000) ||
        value == null ||
        value == -1) {
      text = "N/A";
    } else {
      NumberFormat formatter;
      if (widget.id == "priceUsd") {
        formatter = NumberFormat.currency(
            symbol: '',
            decimalDigits: value > 1
                ? value < 100000
                    ? 2
                    : 0
                : value > .000001
                    ? 6
                    : 7);
      } else if (widget.id == "marketCapUsd") {
        formatter = NumberFormat.currency(
            symbol: Provider.of<HomeModel>(context).symbol,
            decimalDigits: value > 1 ? 0 : 2);
      } else if (widget.id == "changePercent24Hr") {
        formatter = NumberFormat.currency(symbol: "", decimalDigits: 3);
      } else {
        formatter = NumberFormat.currency(symbol: "", decimalDigits: 0);
      }
      text = format.currencySymbol + formatter.format(value);
    }
    if (widget.id == "changePercent24Hr" && value != -1000000) {
      text += "%";
      text = (value > 0 ? "+" : "") + text;
      textColor = value < 0
          ? Colors.red
          : value > 0
              ? Colors.green
              : Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          decoration: BoxDecoration(
            color: ColorConstants.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: ColorConstants.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          padding: EdgeInsets.only(top: 5.0),
          child: Card(
              color: Colors.white,
              child: Container(
                  height: 60.0,
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Column(children: [
                    Text(widget.title,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText1),
                    ConstrainedBox(
                      child: AutoSizeText(text,
                          minFontSize: 0,
                          maxFontSize: 17,
                          style: TextStyle(fontSize: 17, color: textColor),
                          maxLines: 1),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2 - 8),
                    )
                  ])))),
    );
  }
}

class TimeSeriesPrice {
  DateTime time;
  double price;

  TimeSeriesPrice(this.time, this.price);
}

class SimpleTimeSeriesChart extends StatefulWidget {
  final String period, id;

  final int startTime;

  SimpleTimeSeriesChart(this.id, this.startTime, this.period);

  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  late List<TimeSeriesPrice> seriesList = [];
  double count = 0.0;
  double selectedPrice = -1.0;
  late DateTime selectedTime;
  bool canLoad = true, loading = true;
  late int base = 0;
  late num minVal = 0.0, maxVal = 0.0;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    http
        .get(Uri.parse(Uri.encodeFull(
            "https://api.coincap.io/v2/assets/${widget.id}/history?interval=" +
                widget.period +
                "&start=" +
                now
                    .subtract(Duration(days: widget.startTime))
                    .millisecondsSinceEpoch
                    .toString() +
                "&end=" +
                now.millisecondsSinceEpoch.toString())))
        .then((value) {
      seriesList = createChart(json.decode(value.body), widget.id);
      setState(() {
        loading = false;
      });
      base = minVal >= 0 ? max(0, (-log(minVal) / log(10)).ceil() + 2) : 0;
      if (minVal <= 1.1 && minVal > .9) {
        base++;
      }
    });
  }

  Map<String, int> dataPerDay = {
    "m5": 288,
    "m30": 48,
    "h2": 12,
    "h12": 2,
    "d1": 1
  };

  Map<String, DateFormat> formatMap = {
    "m5": DateFormat("h꞉mm a"),
    "m30": DateFormat.MMMd(),
    "h2": DateFormat.MMMd(),
    "h12": DateFormat.MMMd(),
    "d1": DateFormat.MMMd(),
  };

  @override
  Widget build(BuildContext context) {
    bool hasData = seriesList.length >
        (widget.startTime * dataPerDay[widget.period]! / 10);
    double dif, factor, visMax = 0.0, visMin = 0.0;
    DateFormat xFormatter = formatMap[widget.period]!;
    NumberFormat yFormatter = NumberFormat.currency(
        symbol: Provider.of<HomeModel>(context)
            .symbol
            .toString()
            .replaceAll("\.", ""),
        locale: "en_US",
        decimalDigits: base);
    if (!loading && hasData) {
      dif = (maxVal - minVal) as double;
      factor = min(1, max(.2, dif / maxVal));
      visMin = max(0, minVal - dif * factor);
      visMax = visMin != 0 ? maxVal + dif * factor : maxVal + minVal as double;
    }
    return !loading && canLoad && hasData
        ? Container(
            width: 350.0 * MediaQuery.of(context).size.width / 375.0,
            height: 200.0,
            child: SfCartesianChart(
              series: [
                LineSeries<TimeSeriesPrice, DateTime>(
                    dataSource: seriesList,
                    xValueMapper: (TimeSeriesPrice s, _) => s.time,
                    yValueMapper: (TimeSeriesPrice s, _) => s.price,
                    animationDuration: 0,
                    color: Colors.blue)
              ],
              plotAreaBackgroundColor: Colors.transparent,
              primaryXAxis: DateTimeAxis(dateFormat: xFormatter),
              primaryYAxis: NumericAxis(
                  numberFormat: yFormatter,
                  decimalPlaces: base,
                  visibleMaximum: visMax,
                  visibleMinimum: visMin,
                  interval: (visMax - visMin) / 4.001),
              selectionGesture: ActivationMode.singleTap,
              selectionType: SelectionType.point,
              // ignore: deprecated_member_use
              onAxisLabelRender: (a) {
                if (a.orientation == AxisOrientation.vertical) {
                  a.text = yFormatter.format(a.value);
                } else {
                  a.text = xFormatter.format(
                      DateTime.fromMillisecondsSinceEpoch(a.value as int));
                }
              },
              trackballBehavior: TrackballBehavior(
                  activationMode: ActivationMode.singleTap,
                  enable: true,
                  shouldAlwaysShow: true,
                  tooltipSettings: InteractiveTooltip(
                      color: Colors.white,
                      format: "point.x | point.y",
                      decimalPlaces: base)),
              onTrackballPositionChanging: (a) {
                var v = a.chartPointInfo.chartDataPoint;
                a.chartPointInfo.label =
                    "${xFormatter.format(v!.x)} | ${yFormatter.format(v.y)}";
              },
            ))
        : canLoad && (hasData || loading)
            ? Container(
                height: 233.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()]))
            : Container(
                height: 233.0,
                child: Center(
                    child: Text("Sorry, this coin graph is not supported",
                        style: TextStyle(fontSize: 17.0))));
  }

  List<TimeSeriesPrice> createChart(Map<String, dynamic> info, String s) {
    List<TimeSeriesPrice> data = [];

    if (info.length > 1) {
      for (int i = 0; i < info["data"].length; i++) {
        num val = num.parse(info["data"][i]["priceUsd"]) *
            Provider.of<HomeModel>(context, listen: false).exchangeRate;
        minVal = min(minVal, val);
        maxVal = max(maxVal, val);
        data.add(TimeSeriesPrice(
            DateTime.fromMillisecondsSinceEpoch(info["data"][i]["time"]),
            val as double));
      }
    } else {
      canLoad = false;
    }
    return data;
  }
}
