import 'package:flutter/material.dart';

goTo(context, routeName) => Navigator.of(context).pushNamed(routeName);
goToReplace(context, routeName) =>
    Navigator.pushReplacementNamed(context, routeName);
goToData(context, routeName, arg) =>
    Navigator.of(context).pushNamed(routeName, arguments: arg);
goToReplaceData(context, routeName, arg) =>
    Navigator.pushReplacementNamed(context, routeName, arguments: arg);
goToUntil(context, routeName) =>
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
goBack(context) => Navigator.of(context).pop();
