import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_constants.dart';

class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required Color divider,
    required Color buttonBackground,
    required Color buttonText,
    required Color cardBackground,
    required Color disabled,
    required Color error,
  }) {
    final baseTextTheme = brightness == Brightness.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    return ThemeData(
      fontFamily: 'Kufi',
      brightness: brightness,
      buttonColor: buttonBackground,
      canvasColor: background,
      cardColor: background,
      dividerColor: divider,
      dividerTheme: DividerThemeData(
        color: divider,
        space: 1,
        thickness: 1,
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      backgroundColor: background,
      primaryColor: accentColor,
      accentColor: accentColor,
      toggleableActiveColor: accentColor,
      appBarTheme: AppBarTheme(
        brightness: brightness,
        color: Colors.white,
        textTheme: TextTheme(
          bodyText1: baseTextTheme.bodyText1!
              .copyWith(color: secondaryText, fontSize: 18, fontFamily: 'Kufi'),
        ),
        iconTheme: IconThemeData(
          color: secondaryText,
        ),
      ),
      iconTheme: IconThemeData(
        color: secondaryText,
        size: 16.0,
      ),
      errorColor: error,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: accentColor,
          primaryVariant: accentColor,
          secondary: accentColor,
          secondaryVariant: accentColor,
          surface: background,
          background: background,
          error: error,
          onPrimary: buttonText,
          onSecondary: buttonText,
          onSurface: buttonText,
          onBackground: buttonText,
          onError: buttonText,
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: error),
        labelStyle: TextStyle(
          fontFamily: 'Kufi',
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          color: primaryText.withOpacity(0.5),
        ),
        hintStyle: TextStyle(
          color: secondaryText,
          fontSize: 13.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      textTheme: TextTheme(
        headline1: baseTextTheme.headline1!.copyWith(
            color: primaryText,
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kufi'),
        headline2: baseTextTheme.headline2!.copyWith(
            color: Color(0xffe93d25),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kufi'),
        headline3: baseTextTheme.headline3!.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Kufi'),
        headline4: baseTextTheme.headline4!.copyWith(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Kufi'),
        headline5: baseTextTheme.headline5!.copyWith(
            color: primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Kufi'),
        headline6: baseTextTheme.headline6!.copyWith(
            color: secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Kufi'),
        bodyText1: baseTextTheme.bodyText1!
            .copyWith(color: primaryText, fontSize: 15, fontFamily: 'Kufi'),
        bodyText2: baseTextTheme.bodyText2!.copyWith(
            fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Kufi'),
        button: baseTextTheme.button!.copyWith(
            color: primaryText,
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            fontFamily: 'Kufi'),
        caption: baseTextTheme.caption!.copyWith(
            color: primaryText,
            fontSize: 11.0,
            fontWeight: FontWeight.w300,
            fontFamily: 'Kufi'),
        overline: baseTextTheme.overline!.copyWith(
            color: secondaryText,
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Kufi'),
        subtitle1: baseTextTheme.subtitle1!.copyWith(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
        subtitle2: baseTextTheme.subtitle2!.copyWith(
          color: secondaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor,
        selectionHandleColor: accentColor,
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
        background: ColorConstants.lightScaffoldBackgroundColor,
        cardBackground: ColorConstants.secondaryAppColor,
        primaryText: Colors.black,
        secondaryText: (Colors.grey[500])!,
        accentColor: Color(0xffe93d25),
        divider: ColorConstants.secondaryAppColor,
        buttonBackground: Colors.black38,
        buttonText: ColorConstants.secondaryAppColor,
        disabled: ColorConstants.secondaryAppColor,
        error: Colors.red,
      );

  static ThemeData get darkTheme => createTheme(
        brightness: Brightness.dark,
        background: ColorConstants.darkScaffoldBackgroundColor,
        cardBackground: ColorConstants.secondaryDarkAppColor,
        primaryText: Colors.black,
        secondaryText: (Colors.grey[500])!,
        accentColor: ColorConstants.secondaryDarkAppColor,
        divider: Colors.black45,
        buttonBackground: Colors.white,
        buttonText: ColorConstants.secondaryDarkAppColor,
        disabled: ColorConstants.secondaryDarkAppColor,
        error: Colors.red,
      );
}
