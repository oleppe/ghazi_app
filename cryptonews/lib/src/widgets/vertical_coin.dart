// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryptonews/src/config/image_constants.dart';
import 'package:cryptonews/src/screens/crypto/image_keys.txt';
import 'package:cryptonews/src/screens/navbar/crypto_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/local_database.dart';
// ignore: import_of_legacy_library_into_null_safe

// ignore: must_be_immutable
class VerticalCoin extends StatelessWidget {
  VerticalCoin({required this.imgList, this.callback});

  List<Map<String, dynamic>?> imgList;
  final VoidCallback? callback;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var format = NumberFormat.simpleCurrency(
        name: Provider.of<HomeModel>(context).symbol);

    List<Widget> imageSliders = imgList
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, -2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              FadeInImage(
                                  image: !blacklist.contains(item!['key'])
                                      ? NetworkImage(
                                          "https://static.coincap.io/assets/icons/${item['symbol'].toLowerCase()}@2x.png")
                                      : Image.asset(AllImages().logo).image,
                                  placeholder: AssetImage(AllImages().logo),
                                  fadeInDuration:
                                      const Duration(milliseconds: 100),
                                  height: 52.0,
                                  width: 52.0),
                            ]),
                            Container(height: 5.0),
                            Row(children: [
                              ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxWidth: width / 3),
                                  child: AutoSizeText(item["name"],
                                      maxLines: 1,
                                      minFontSize: 7.0,
                                      maxFontSize: 14.0,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Kufi'))),
                            ]),
                          ]),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PriceText(item["id"]),
                            Text(
                                (item["marketCapUsd"] >= 0
                                    ? item["marketCapUsd"] > 1
                                        ? format.currencySymbol +
                                            NumberFormat.currency(
                                                    symbol: "",
                                                    decimalDigits: 0)
                                                .format(item["marketCapUsd"])
                                        : format.currencySymbol +
                                            item["marketCapUsd"]
                                                .toStringAsFixed(2)
                                    : "N/A"),
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            SizedBox(
                              height: 5,
                            ),
                            Provider.of<HomeModel>(context)
                                    .settings["disableGraphs"]
                                ? linkMap[item['symbol']] != null &&
                                        !blacklist.contains(item['id'])
                                    ? SvgPicture.network(
                                        "https://www.coingecko.com/coins/${linkMap[item['symbol']] ?? linkMap[item['id']]}/sparkline",
                                        placeholderBuilder:
                                            (BuildContext context) => Container(
                                                width: 0, height: 35.0),
                                        width: 105.0,
                                        height: 35.0)
                                    : Container(height: 35.0)
                                : Container(),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        initialPage: 0,
        aspectRatio: 3.0,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        viewportFraction: 0.6,
      ),
      items: imageSliders,
    );
  }
}
