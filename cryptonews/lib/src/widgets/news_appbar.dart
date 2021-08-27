import 'package:flutter/material.dart';

class NewsAppBar extends StatefulWidget implements PreferredSizeWidget {
  NewsAppBar({Key? key, required this.appBar}) : super(key: key);
  final AppBar appBar;

  @override
  _NewsAppBarState createState() => _NewsAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _NewsAppBarState extends State<NewsAppBar> {
  @override
  Widget build(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 230),
                child: Text(
                  "أخبار كريبتو",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ],
          ),
        ),
        // IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () {
        //       authenticationBloc.add(UserLogOut());
        //     }),
      ],
    );
  }
}
