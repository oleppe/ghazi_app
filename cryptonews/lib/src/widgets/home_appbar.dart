import 'package:cryptonews/src/config/image_constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar(
      {Key? key,
      required this.golbalKey,
      required this.searchBar,
      required this.appBar})
      : super(key: key);
  final GlobalKey<ScaffoldState> golbalKey;
  bool searchBar;
  final AppBar appBar;

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,

      // iconTheme: IconThemeData(color: Color(0xffe93d25)),
      leading: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: GestureDetector(
          onTap: () {
            widget.golbalKey.currentState!.openDrawer();
          },
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: Image.asset(
              AllImages().user,
            ).image,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),

      actions: [
        Expanded(
          child: widget.searchBar
              ? Padding(
                  padding: EdgeInsets.only(right: 50),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                    title: Container(
                      child: TextFormField(
                        onChanged: (text) {},
                        onEditingComplete: () {
                          print("res");
                        },
                        autocorrect: false,
                        autofocus: false,
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          hintText: "بحث",
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          widget.searchBar = false;
                        });
                      },
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 55),
                        child: IconButton(
                            icon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.searchBar = true;
                              });
                            })),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
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
