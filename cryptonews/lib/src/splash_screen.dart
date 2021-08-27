// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/config/color_constants.dart';
import 'package:cryptonews/src/config/image_constants.dart';
import 'package:cryptonews/src/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:local_database/local_database.dart';
import 'package:provider/provider.dart';
import 'package:shared/local_database.dart';
import 'package:shared/main.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthenticationBloc authenticationBloc;
  @override
  void initState() {
    authenticationBloc = AuthenticationBlocController().authenticationBloc;
    authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<HomeModel>(context).settings == null ||
        Provider.of<HomeModel>(context).settings!.isEmpty)
      Provider.of<HomeModel>(context).getSettings();

    SizeConfig().init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: ColorConstants.secondaryAppColor,
          body: BlocListener<AuthenticationBloc, AuthenticationState>(
            cubit: authenticationBloc,
            listener: (BuildContext context, AuthenticationState state) async {
              Database _userData = new Database(
                  (await pathProvider.getApplicationDocumentsDirectory()).path);
              bool first = await _userData['firstTime'];
              if (state is AuthenticationLoading) {
                if (first == false) {
                  Navigator.popAndPushNamed(context, '/home');
                } else
                  _userData["firstTime"] = false;
              }
              if (state is AppAutheticated) {
                //Navigator.pushNamed(context, '/home');
              }
              if (state is AuthenticationStart) {
                //Navigator.pushNamed(context, '/auth');
              }
              if (state is UserLogoutState) {
                //Navigator.pushNamed(context, '/auth');
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                cubit: authenticationBloc,
                builder: (BuildContext context, AuthenticationState state) {
                  return IntroductionScreen(
                    globalBackgroundColor: Colors.white,
                    pages: [
                      PageViewModel(
                        title: "تابع أحدث الأخبار",
                        body:
                            "نوفر لك أخبار العملات الرقمية من أكثر من 300 مصدر موثوق",
                        image: Center(
                          child: Image.asset(
                            AllImages().welcome1,
                            width: SizeConfig().screenWidth,
                          ),
                        ),
                        decoration: const PageDecoration(
                          titleTextStyle: TextStyle(color: Colors.black),
                          bodyTextStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0),
                        ),
                      ),
                      PageViewModel(
                        title: "متابعة التحليلات",
                        body:
                            "نوفر لك أفضل التحليلات الفنية للرسوم البيانية ومحافظ الحيتان ومجتمعات العملات الرقمية",
                        image: Center(
                          child: Image.asset(
                            AllImages().welcome2,
                            width: SizeConfig().screenWidth,
                          ),
                        ),
                        decoration: const PageDecoration(
                          titleTextStyle: TextStyle(color: Colors.black),
                          bodyTextStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0),
                        ),
                      ),
                      PageViewModel(
                        title: "تابع السوق باستمرار",
                        body:
                            "باستعمالك تطبيق أخبار كريبتو يمكنك متابعة أسعار وأخبار العملات باستمرار وفي مكان واحد!",
                        image: Center(
                          child: Image.asset(
                            AllImages().welcome3,
                            width: SizeConfig().screenWidth,
                          ),
                        ),
                        decoration: const PageDecoration(
                          titleTextStyle: TextStyle(color: Colors.black),
                          bodyTextStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0),
                        ),
                      )
                    ],
                    onDone: () {
                      if (state is AppAutheticated) {
                        Navigator.pushNamed(context, '/home');
                      }
                      if (state is AuthenticationStart) {
                        Navigator.pushNamed(context, '/home');
                      }
                      if (state is UserLogoutState) {
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    onSkip: () {
                      if (state is AppAutheticated) {
                        Navigator.pushNamed(context, '/home');
                      }
                      if (state is AuthenticationStart) {
                        Navigator.pushNamed(context, '/home');
                      }
                      if (state is UserLogoutState) {
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    showNextButton: false,
                    showSkipButton: true,
                    skip: const Text("تجاوز"),
                    done: const Text("تم",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  );
                  // Stack(
                  //   children: [
                  //     Container(
                  //       decoration: new BoxDecoration(
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     Center(child: Image.asset(AllImages().logo)),
                  //   ],
                  // );
                }),
          )),
    );
  }
}
