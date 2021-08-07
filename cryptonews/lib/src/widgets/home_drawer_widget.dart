import 'package:cryptonews/src/config/image_constants.dart';
import 'package:cryptonews/src/utils/app_state_notifier.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/main.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/authentication/bloc/authentication/authentication_state.dart';

// ignore: must_be_immutable
class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key, required this.state}) : super(key: key);

  SetUserData state;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: Image.asset(AllImages().user).image,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Switch(
                      value: Provider.of<AppStateNotifier>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<AppStateNotifier>(context, listen: false)
                            .updateTheme(value);
                      },
                    ),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
            ),
          ),
          // ListTile(
          //   title: Text(
          //       '${state.currentUserData.data.firstName} ${state.currentUserData.data.lastName}',
          //       style: Theme.of(context).textTheme.bodyText2),
          // ),
          // ListTile(
          //   title: Text(state.currentUserData.data.email,
          //       style: Theme.of(context).textTheme.bodyText2),
          // ),
          // ListTile(
          //   title: Text(state.currentUserData.ad.company,
          //       style: Theme.of(context).textTheme.bodyText2),
          // ),
        ],
      ),
    );
  }
}
