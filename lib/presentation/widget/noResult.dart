import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class noResult extends StatelessWidget {
  const noResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            width: 150,
            height: 350,
            child: SvgPicture.asset(IMG_NOTFOUND, fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Oops!',
                  style: TextStyle(
                    fontSize: TXT_SIZE_LARGE(context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
                Text(
                  'It seems there is a problem fetching the bill at the moment. Kindly try again later.',
                  style: TextStyle(
                    fontSize: TXT_SIZE_LARGE(context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
