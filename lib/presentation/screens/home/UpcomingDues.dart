import 'package:ebps/constants/sizes.dart';
import 'package:ebps/presentation/common/Container/Home/UpcomingContainer.dart';
import 'package:ebps/presentation/screens/home/AllUpcomingDues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpcomingDues extends StatefulWidget {
  const UpcomingDues({super.key});

  @override
  State<UpcomingDues> createState() => _UpcomingDuesState();
}

class _UpcomingDuesState extends State<UpcomingDues> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 16, top: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Dues',
                style: TextStyle(
                  fontSize: TXT_SIZE_XL(context),
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1b438b),
                  height: 25 / 15,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllUpcomingDues()));
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: TXT_SIZE_LARGE(context),
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1b438b),
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.center,
                      softWrap: false,
                    ),
                    Icon(Icons.arrow_forward, color: Color(0xff1b438b)),
                  ],
                ),
              ),
            ],
          ),
        ),
        UpcomingDuesContainer(
          titleText: 'SSPL airtel Johnny',
          subtitleText: '+044 4789 7893',
          dateText: '01/09/2023',
          buttonText: 'Pay Now',
          amount: "₹ 589.00",
          iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
          containerBorderColor: Color(0xffD1D9E8),
          buttonColor: Color(0xFF1B438B),
          buttonTxtColor: Color.fromARGB(255, 255, 255, 255),
          buttonTextWeight: FontWeight.normal,
          buttonBorderColor: null,
        ),
        UpcomingDuesContainer(
          titleText: 'Johnny Depp - Jio Post',
          subtitleText: '+044 4789 7893',
          dateText: '01/09/2023',
          buttonText: 'Upcoming Auto Payment',
          amount: "₹ 630.00",
          iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
          containerBorderColor: Color(0xffD1D9E8),
          buttonColor: Color.fromARGB(255, 255, 255, 255),
          buttonTxtColor: Color(0xff00AB44),
          buttonTextWeight: FontWeight.bold,
          buttonBorderColor: Color(0xff00AB44),
        )
      ],
    );
  }
}
