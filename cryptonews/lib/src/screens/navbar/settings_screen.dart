// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/config/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/local_database.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(builder: (context, model, child) {
      return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 20.0, right: 15, left: 15),
            child: ListView(physics: ClampingScrollPhysics(), children: [
              Card(
                color: ColorConstants.nearlyWhite,
                child: ListTile(
                    title: Text(
                      "عرض الرسم البياني",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    subtitle: Text("عرض الرسم البياني داخل بطاقة كل عملة",
                        style: Theme.of(context).textTheme.headline6),
                    trailing: Switch(
                        value: model.settings["disableGraphs"],
                        onChanged: (disp) {
                          model.updateSettings(disp);
                        }),
                    onTap: () {
                      model.updateSettings(!model.settings["disableGraphs"]);
                    }),
                margin: EdgeInsets.zero,
              ),
              Container(height: 20),
              Card(
                color: ColorConstants.nearlyWhite,
                child: ListTile(
                    title: Text(
                      "العملة",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    subtitle: Text(
                      "يمكنك أختيار العملة المفضلة لعرض أسعار العملات الرقمية",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Padding(
                        child: Container(
                            color: Colors.white12,
                            padding: EdgeInsets.only(right: 7.0, left: 7.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: model.settings["currency"],
                                    onChanged: (s) {
                                      model.updateCurrency(s);
                                    },
                                    items: model.supportedCurrencies
                                        .map((s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(model.conversionMap !=
                                                    null
                                                ? model.conversionMap[s] != null
                                                    ? "$s ${model.conversionMap[s]["symbol"]}"
                                                    : ""
                                                : "")))
                                        .toList()))),
                        padding: EdgeInsets.only(right: 10.0))),
                margin: EdgeInsets.zero,
              )
            ])),
      );
    });
  }

  @override
  // bool get wantKeepAlive => false;
  bool get wantKeepAlive => true;
}
