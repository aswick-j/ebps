import 'package:ebps/screens/BillFlow/BillerList.dart';
import 'package:ebps/screens/home/AllBillCategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesContainer extends StatelessWidget {
  final String headerName;
  final bool? viewall;
  final int categoriesCount;
  const CategoriesContainer(
      {super.key,
      required this.headerName,
      required this.categoriesCount,
      this.viewall});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color(0xFFD1D9E8),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              headerName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff1b438b),
                height: 25 / 15,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: categoriesCount,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  print(index);
                  return viewall == true && index == 7
                      ? InkWell(
                          onTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllBillCategories()))
                              },
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE8ECF3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(Icons.arrow_forward,
                                        color: Color(0xff1b438b)),
                                  )),
                              Text(
                                "View All",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff4c4c4c),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                      : Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BillerList()));
                                  },
                                  child: Container(
                                    child: SvgPicture.asset(
                                        'packages/ebps/assets/icon/icon_home.svg'),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 10, 0, 0),
                                  child: Text(
                                    "Mobile Postpaid",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff4c4c4c),
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ));
                }),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
