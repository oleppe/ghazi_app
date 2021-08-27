import 'package:cryptonews/src/config/string_constants.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'من نحن؟',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Text("ما هو تطبيق أخبار كريبتو؟",
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(
                    height: 15,
                  ),
                  Text(about,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
