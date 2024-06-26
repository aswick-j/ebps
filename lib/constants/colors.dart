// ignore_for_file: constant_identifier_names

import 'package:ebps/ebps.dart';
import 'package:flutter/material.dart';

//Ref from IBM- MB

class AppColors {
  static bool get isElite => IsCustomerElite.isCustomerElite;

  //APP MAIN COLORS

  static Color get CLR_BACKGROUND =>
      isElite ? Color(0xFF0E2146) : Color(0xFFFFFFFF);

  static Color get CLR_CONTAINER_BG =>
      isElite ? Color(0xffD1D9E8) : Color(0xffD1D9E8);

  static Color get CLR_PRIMARY => isElite ? Colors.white : Color(0xff1B438B);
  static Color get CLR_PRIMARY_NC =>
      isElite ? Color(0xff1B438B) : Color(0xff1B438B);

  static Color get CLR_PRIMARY_LITE =>
      isElite ? Color(0xffD1D9E8) : Color(0xff4969A2);

  static Color get CLR_SECONDARY =>
      isElite ? Color(0xff1B438B) : Color(0xff4969A2);

  static Color get CLR_GREY => isElite ? Color(0xffD1D9E8) : Color(0xFFA4B4D1);

  static Color get CLR_ASTRIX =>
      isElite ? Color(0xffE27882) : Color(0xff982F67);

  static Color get CLR_BLUESHADE =>
      isElite ? Color(0xFF0E2146).withOpacity(0.7) : Color(0xCCACC9FF);

  static Color get CLR_BODYSHADE => isElite ? Color(0xFF0E2146) : Colors.white;

  static Color get CLR_GREENSHADE =>
      isElite ? Color(0xffD1D9E8) : Color(0xff99DDB4);

  static Color get CLR_REDSHADE =>
      isElite ? Color(0xffD1D9E8) : Color.fromARGB(255, 221, 153, 153);

  static Color get CLR_ORANGESHADE =>
      isElite ? Color(0xffD1D9E8) : Color.fromRGBO(221, 198, 153, 1);

  static Color get CLR_ERROR => isElite ? Color(0xffD94B59) : Color(0xffCF1E2F);

  static Color get CLR_GREEN => isElite ? Color(0xff00AB44) : Color(0xff008936);
  static Color get CLR_DARKGREEN =>
      isElite ? Color.fromARGB(255, 0, 85, 34) : Color(0xff008936);

  static Color get CLR_ORANGE =>
      isElite ? Color(0xFFCE7D1E) : Color(0xFFCE7D1E);

  static Color get CLR_BLUE_LITE =>
      isElite ? Color(0xFF768EB9) : Color(0xFF768EB9);

//CONTAINER

  static Color get CLR_CON_BORDER =>
      isElite ? Color(0xff94AFD8) : Color(0xFF94AFD8);

  static Color get CLR_CON_BORDER_LITE =>
      isElite ? Color(0xff94AFD8) : Color(0xffE8ECF3);

  //ICON CLR

  static Color get CLR_ICON => isElite ? Color(0xff94afd8) : Color(0xff1B438B);

//TEXT COLORS

  static Color get TXT_CLR_DEFAULT =>
      isElite ? Color(0xff94afd8) : Color(0xff191919);
  static Color get TXT_CLR_DEFAULT_LOADER =>
      isElite ? Color(0xFF0E2146) : Color(0xff191919);

  static Color get TXT_CLR_BLACK =>
      isElite ? Color(0xCCACC9FF) : Color(0xff191919);
  static Color get TXT_CLR_BLACK_W =>
      isElite ? Color(0xfff3f4f7) : Color(0xff191919);

  static Color get TXT_CLR_PRIMARY =>
      isElite ? Color(0xffD1D9E8) : Color(0xff1B438B);

  static Color get TXT_CLR_LITE =>
      isElite ? Color(0xff94afd8) : Color(0xff808080);

  static Color get TXT_CLR_LITE_V2 =>
      isElite ? Color(0xffD1D9E8) : Color(0xff313131);

  static Color get TXT_CLR_LITE_V3 =>
      isElite ? Color(0xff94AFD8) : Color(0xff313131);

  static Color get TXT_CLR_GREY =>
      isElite ? Color(0xffD1D9E8) : Color(0xff4c4c4c);

  static Color get TXT_CLR_SECONDARY =>
      isElite ? Color(0xffD1D9E8) : Color(0xff313131);

//DIVIDER

  static Color get CLR_DIVIDER =>
      isElite ? Color(0xff0B1B38) : Colors.grey.withOpacity(0.2);
  static Color get CLR_DIVIDER_LITE =>
      isElite ? Color(0xff94AFD8) : Color(0xffD1D9E8);

//BUTTON COLORS

  static Color get BTN_CLR_ACTIVE_BG =>
      isElite ? Color(0xff94AFD8) : Color(0xff1B438B);
  static Color get BTN_CLR_ALTER_BG =>
      isElite ? Color(0xFF94AFD8) : Colors.white;
  static Color get BTN_CLR_ACTIVE_TEXT =>
      isElite ? Color(0xff1B438B) : Colors.white;

  static Color get BTN_CLR_ACTIVE =>
      isElite ? Color(0xff0E2146) : Color(0xffffffff);

  static Color get BTN_CLR_ACTIVE_BORDER =>
      isElite ? Color(0xffD1D9E8) : Color(0xFF94AFD8);

  static Color get BTN_CLR_ACTIVE_ALTER =>
      isElite ? Color(0xffD1D9E8) : Color(0xff1B438B);
  static Color get BTN_CLR_ACTIVE_ALTER_TEXT =>
      isElite ? Color(0xff1B438B) : Colors.white;
  static Color get BTN_CLR_ACTIVE_ALTER_C =>
      isElite ? Color(0xFF0E2146) : Color(0xffffffff);
  static Color get BTN_CLR_ACTIVE_ALTER_TEXT_C =>
      isElite ? Colors.white : Color(0xff1B438B);
  static Color get BTN_CLR_DISABLE => isElite ? Colors.grey : Colors.grey;
  static Color get BTN_CLR_DISABLE_TEXT =>
      isElite ? Colors.white : Colors.white;

  //PDF COLOR BY HEX
  static String get CLR_PDF_BG => isElite ? " #a9bbdb" : " #a9bbdb";

  //INPUT FILED

  static Color get CLR_INPUT_FILL =>
      isElite ? Color(0xff0B1B38) : Color(0xffD1D9E8).withOpacity(0.2);

  //GRADIENT CLR

  static Color get CLR_GRD_1 => isElite ? Color(0xff4969A2) : Color(0xff768EB9);
  static Color get CLR_GRD_2 => isElite ? Color(0xff4969A2) : Color(0xff463A8D);

  static const Color gradient1 = Color(0xFFE79BBA);
  static const Color gradient2 = Color(0xFF463A8D);
  static const Color gradient3 = Color(0xFF768EB9);
  static const Color gradient4 = Color(0xFF1B438B);
  static const Color gradient5 = Color(0xFF99DDB4);
  static const Color gradient6 = Color(0xFF31637D);
  static const Color gradient7 = Color(0xFFCCAA59);
  static const Color gradient8 = Color(0xFFCE7D1E);
  static const Color gradient9 = Color(0xFFFFD05F);
  static const Color gradient10 = Color(0xFFCF1E2F);
  static const Color gradient11 = Color(0xFF7C121C);
}
