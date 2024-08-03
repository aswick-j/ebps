import 'package:ebps/common/Container/ImageTile.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BillerListSaved extends StatefulWidget {
  final List<SavedBillersData>? SavedBiller;

  const BillerListSaved({super.key, this.SavedBiller});

  @override
  State<BillerListSaved> createState() => _BillerListSavedState();
}

class _BillerListSavedState extends State<BillerListSaved> {
  final controller = PageController(
    keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 95.h,
            // margin: EdgeInsets.fromLTRB(0, 120.h, 0, 10.h),
            child: PageView.builder(
                controller: controller,
                itemCount: widget.SavedBiller!.length,
                itemBuilder: (_, index) {
                  return InkWell(
                      onTap: () => {
                            GoToData(context, fETCHBILLERDETAILSROUTE, {
                              "name": widget.SavedBiller![index].bILLERNAME,
                              "billName": widget.SavedBiller![index].bILLNAME,
                              "savedBillersData": widget.SavedBiller![index],
                              "SavedinputParameters":
                                  widget.SavedBiller![index].pARAMETERS,
                              "categoryName":
                                  widget.SavedBiller![index].cATEGORYNAME,
                              "isSavedBill": true,
                            })
                          },
                      child: ReusableContainer(
                          child: ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
                        leading: ImageTileContainer(iconPath: LOGO_BBPS),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.SavedBiller![index].bILLNAME
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.TXT_CLR_PRIMARY,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 240.w,
                                          child: Text(
                                            widget
                                                .SavedBiller![index].bILLERNAME
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.TXT_CLR_DEFAULT,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        SizedBox(
                                          width: 200.w,
                                          child: Text(
                                            widget.SavedBiller![index]
                                                .pARAMETERVALUE
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.TXT_CLR_LITE,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // if (widget.SavedBiller![index].dUESTATUS ==
                                    //     1)
                                    //   Text(
                                    //     "Bill Due in 19 Days",
                                    //     style: TextStyle(
                                    //         fontSize: 9.sp,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: AppColors.CLR_ASTRIX,
                                    //         overflow: TextOverflow.ellipsis),
                                    //     maxLines: 1,
                                    //   ),
                                  ]),
                            ]),
                      )));
                })),
        SmoothPageIndicator(
            controller: controller,
            count: widget.SavedBiller!.length,
            effect: ScrollingDotsEffect(
              dotColor: AppColors.TXT_CLR_LITE.withOpacity(0.5),
              activeDotColor: AppColors.CLR_BLUE_LITE,
              dotHeight: 6,
              dotWidth: 6,

              // dotDecoration: DotDecoration(
              //   color: Color(0xFFA4A1A1),
              //   borderRadius: BorderRadius.all(Radius.circular(4)),
              // ),
              // activeDotDecoration: DotDecoration(
              //   color: AppColors.CLR_BLUE_LITE,
              //   borderRadius: BorderRadius.all(Radius.circular(4)),
              //   dotBorder: DotBorder(
              //     color: Colors.white,
              //     width: 2,
              //     padding: 3,
              //   ),
              // ),
            )),
      ],
    );
  }
}
