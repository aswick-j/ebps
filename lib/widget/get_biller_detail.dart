import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// billerDetail(pARAMETERNAME, pARAMETERVALUE, context) {
//   return Center(
//     child: Container(
//         // margin: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Padding(
//                 padding: EdgeInsets.fromLTRB(8.w, 10.h, 0, 0),
//                 child: SizedBox(
//                   width: 100.w,
//                   child: Text(
//                     pARAMETERNAME,
//                     // "Subscriber ID",
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xff808080),
//                     ),
//                     textAlign: TextAlign.start,
//                     maxLines: 1,
//                   ),
//                 )),
//             Padding(
//                 padding: EdgeInsets.fromLTRB(8.w, 10.h, 0, 0),
//                 child: SizedBox(
//                   width: 100.w,
//                   child: Text(
//                     pARAMETERVALUE,
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xff1b438b),
//                     ),
//                     textAlign: TextAlign.start,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ))
//           ],
//         )),
//   );
// }

billerdetail(pARAMETERNAME, pARAMETERVALUE, context) {
  return Center(
      child: Container(
          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 5.h, 8.w, 5.h),
                  child: SizedBox(
                    width: 110.w,
                    child: Text(
                      pARAMETERNAME,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.TXT_CLR_LITE,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.left,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 10.h, 24.w, 10.h),
                  child: SizedBox(
                    width: 130.w,
                    child: Text(
                      pARAMETERVALUE,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.TXT_CLR_PRIMARY,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.right,
                    ),
                  ))
            ],
          )));
}
