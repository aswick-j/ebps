import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getSavedBillersByCategory.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:ebps/models/saved_biller_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesContainer extends StatelessWidget {
  final String headerName;
  final bool? viewall;
  final int categoriesCount;
  List<CategorieData>? categoriesData;
  final List<SavedBillersData>? SavedBiller;

  CategoriesContainer(
      {super.key,
      required this.headerName,
      required this.categoriesCount,
      required this.categoriesData,
      this.viewall,
      this.SavedBiller});

  @override
  Widget build(BuildContext context) {
    return ReusableContainer(
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
                color: AppColors.CLR_PRIMARY,
                height: 25 / 15,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.CLR_BACKGROUND,
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
                                GoToData(context, allCATROUTE, {
                                  "categoriesData": categoriesData,
                                  "sAVEDBILLERS": SavedBiller
                                })
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => AllBillCategories()))
                              },
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(3.r),
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
                                  color: AppColors.TXT_CLR_LITE_V2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                      : InkWell(
                          onTap: () {
                            GoToData(context, bILLERLISTROUTE, {
                              "cATEGORY_ID": categoriesData![index].iD,
                              "cATEGORY_NAME":
                                  categoriesData![index].cATEGORYNAME,
                              "sAVEDBILLERS": getSavedBillersByCategory(
                                  categoriesData![index]
                                      .cATEGORYNAME
                                      .toString(),
                                  SavedBiller)
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                height: 33.h,
                                colorFilter: ColorFilter.mode(
                                    AppColors.CLR_ICON, BlendMode.srcIn),
                                CATEGORY_ICON(
                                    categoriesData![index].cATEGORYNAME),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    categoriesData![index]
                                        .cATEGORYNAME
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.TXT_CLR_LITE_V2,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
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
