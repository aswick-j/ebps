import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesContainer extends StatelessWidget {
  final String headerName;
  final bool? viewall;
  final int categoriesCount;
  List<CategorieData>? categoriesData;
  CategoriesContainer(
      {super.key,
      required this.headerName,
      required this.categoriesCount,
      required this.categoriesData,
      this.viewall});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:
          EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(
          color: Color(0xFFD1D9E8),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Text(
              headerName,
              style: TextStyle(
                fontSize: 15.w,
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
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (context, index) {
                  return viewall == true && index == 7
                      ? InkWell(
                          onTap: () => {
                                goToData(context, allCATROUTE,
                                    {"categoriesData": categoriesData})
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => AllBillCategories()))
                              },
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(6.r),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE8ECF3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(6.0.r),
                                    child: Icon(Icons.arrow_forward,
                                        color: Color(0xff1b438b)),
                                  )),
                              Text(
                                "View All",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff4c4c4c),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                goToData(context, bILLERLISTROUTE, {
                                  "cATEGORY_ID": categoriesData![index].iD,
                                  "cATEGORY_NAME":
                                      categoriesData![index].cATEGORYNAME,
                                });
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => BillerList()));
                              },
                              child: SvgPicture.asset(
                                height: 38.h,
                                CATEGORY_ICON(
                                    categoriesData![index].cATEGORYNAME),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  categoriesData![index]
                                      .cATEGORYNAME
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff4c4c4c),
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        );
                }),
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
