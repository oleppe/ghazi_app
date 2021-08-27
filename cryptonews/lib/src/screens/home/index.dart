// home screen contents
// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:async';

import 'package:cryptonews/src/config/image_constants.dart';
import 'package:cryptonews/src/screens/navbar/analytics_screen.dart';
import 'package:cryptonews/src/screens/navbar/crypto_screen.dart';
import 'package:cryptonews/src/screens/navbar/news_screen.dart';
import 'package:cryptonews/src/screens/navbar/settings_screen.dart';
import 'package:cryptonews/src/widgets/home_appbar.dart';

import 'package:cryptonews/src/widgets/home_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationBloc authenticationBloc =
      AuthenticationBlocController().authenticationBloc;

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final focusNode = FocusNode();
  final TextEditingController searchController = new TextEditingController();
  late bool searchBar = false;
  late Timer searchTimer;
  num selectedScreen = 0;
  _HomeScreenState() {}

  @override
  void initState() {
    super.initState();

    /*
    FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  print('User granted permission');
} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  print('User granted provisional permission');
} else {
  print('User declined or has not accepted permission');
}
 */
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,

      // iconTheme: IconThemeData(color: Color(0xffe93d25)),
      leading: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
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
          child: searchBar
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
                        focusNode: focusNode,
                        controller: searchController,
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
                          searchBar = false;
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
                              FocusScope.of(context).requestFocus(focusNode);
                              setState(() {
                                searchBar = true;
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

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    authenticationBloc.add(GetUserData());
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        cubit: authenticationBloc,
        builder: (BuildContext context, AuthenticationState state) {
          if (state is SetUserData) {
            return WillPopScope(
              onWillPop: () async {
                //Navigator.pop(context);
                if (Navigator.canPop(context))
                  return true;
                else
                  return true;
              },
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                    key: _key,
                    appBar: selectedScreen != 2
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(60),
                            child: HomeAppBar(
                              golbalKey: _key,
                              appBar: AppBar(),
                              searchBar: searchBar,
                            ),
                          )
                        : null,
                    body: FutureBuilder<InitializationStatus>(
                      future: _initGoogleMobileAds(),
                      builder: (context, snapshot) {
                        return PersistentTabView(
                          context,
                          onItemSelected: (index) => {
                            setState(() {
                              selectedScreen = index;
                            })
                          },
                          controller: _controller,
                          screens: _buildScreens(),
                          items: _navBarsItems(),
                          confineInSafeArea: true,
                          backgroundColor:
                              Colors.white, // Default is Colors.white.
                          handleAndroidBackButtonPress:
                              true, // Default is true.
                          resizeToAvoidBottomInset:
                              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                          stateManagement: true, // Default is true.
                          hideNavigationBarWhenKeyboardShows:
                              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                          decoration: NavBarDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            colorBehindNavBar: Colors.white,
                          ),
                          popAllScreensOnTapOfSelectedTab: true,
                          popActionScreens: PopActionScreensType.all,
                          itemAnimationProperties: ItemAnimationProperties(
                            // Navigation Bar's items animation properties.
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease,
                          ),
                          screenTransitionAnimation: ScreenTransitionAnimation(
                            // Screen transition animation on change of selected tab.
                            animateTabTransition: true,
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 200),
                          ),
                          navBarStyle: NavBarStyle
                              .style6, // Choose the nav bar style with this property.
                        );
                      },
                    ),
                    drawer: HomeDrawer(
                      state: state,
                    )),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  List<Widget> _buildScreens() {
    return [
      NewsScreen(),
      AnalyticScreen(),
      CryptoScreen(true),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("الرئيسية"),
        activeColorPrimary: Color(0xffe93d25),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        onPressed: (context) {
          //Navigator.pop(context!);
        },
        icon: Icon(CupertinoIcons.chart_bar_circle),
        title: ("تحليلات"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey[300],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.pie_chart_outline_outlined),
        title: ("العملات"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("الإعدادات"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
