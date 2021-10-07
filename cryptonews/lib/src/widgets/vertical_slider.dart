import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryptonews/src/config/image_constants.dart';
import 'package:cryptonews/src/screens/news/news_page.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/news/model/news.dart';

// ignore: must_be_immutable
class VerticalSlider extends StatelessWidget {
  VerticalSlider({required this.imgList});

  List<News> imgList;

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList
        .map(
          (item) => InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NewsPage(news: item)));
            },
            child: Container(
              margin: EdgeInsets.only(top: 13, bottom: 8, left: 0, right: 0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      item.imagePath != ''
                          ? Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/cryptonews-c3622.appspot.com/o/articles%2F' +
                                  item.imagePath +
                                  '?alt=media',
                              fit: BoxFit.cover,
                              width: 1000.0,
                            )
                          : Image.asset(
                              AllImages().logo,
                              fit: BoxFit.contain,
                              width: 1000.0,
                            ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(item.name,
                              style: Theme.of(context).textTheme.headline3),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        )
        .toList();

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: imageSliders,
    );
  }
}
