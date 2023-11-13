import 'package:ebps/screens/BillFlow/BillParameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BillerListContainer extends StatefulWidget {
  const BillerListContainer({super.key});

  @override
  State<BillerListContainer> createState() => _BillerListContainerState();
}

class _BillerListContainerState extends State<BillerListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0 + 2),
          border: Border.all(
            color: Color(0xffD1D9E8),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6.0),
                  topLeft: Radius.circular(6.0)),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.menu, color: Color(0xffffffff)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "All Billers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffffffff),
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                height: 40.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    stops: [0.001, 19],
                    colors: [
                      Color(0xff768EB9).withOpacity(.7),
                      Color(0xff463A8D).withOpacity(.7),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BillParameters()));
                  },
                  child: ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 6, right: 6, top: 0),
                      leading: Container(
                        width: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SvgPicture.asset(
                              "packages/ebps/assets/icon/icon_jio.svg"),
                        ),
                      ),
                      title: Text(
                        "Airtel Digital TV",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4c4c4c),
                        ),
                        textAlign: TextAlign.left,
                      )),
                );
              },
            )
          ],
        ));
  }
}
