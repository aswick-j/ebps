import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/screens/home/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        final homeCubit = HomeCubit();

        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => homeCubit,
                  child: const HomeScreen(),
                ));
      default:
        return null;
    }
  }
}

horizontalSpacer(double width) {
  return SizedBox(
    width: width,
  );
}

verticalSpacer(double height) {
  return SizedBox(
    height: height,
  );
}
