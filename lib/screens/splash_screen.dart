import 'package:ebps/bloc/splash/splash_cubit.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/ebps.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class splashScreen extends StatefulWidget {
  String apiData;
  splashScreen({Key? key, required this.apiData}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    final uri = Uri.parse(widget.apiData.toString());
    final id = uri.queryParameters['id'];
    final hash = uri.queryParameters['hash'];

    // logger.i(id);
    // logger.i(hash);

    BlocProvider.of<SplashCubit>(context).login(id.toString(), hash.toString());
  }

  bool isLoginError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) async {
          if (state is SplashLoading) {
            isLoginError = false;
          } else if (state is SplashSuccess) {
            myAccounts = await getDecodedAccounts();
            isLoginError = false;
            GoToReplaceData(context, hOMEROUTE, {
              "index": 0,
            });
          } else if (state is SplashError) {
            isLoginError = true;
          }
        },
        builder: (context, state) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              // image: const DecorationImage(
              //   image: AssetImage(SPLASH_BAG),
              //   fit: BoxFit.fill,
              // ),
              borderRadius: BorderRadius.circular(2.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.CLR_BLUESHADE,
                  AppColors.CLR_BODYSHADE,
                ],
                stops: const [
                  0,
                  0.2,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100.h,
                        width: 100.w,
                        child: Image.asset(
                          LOGO_EQUITAS,
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Container(
                        height: 100.h,
                        width: 100.w,
                        child: Image.asset(LOGO_BBPS_FULL_PNG
                            // IsCustomerElite.isCustomerElite
                            //     ? LOGO_BBPS_FULL_WHITE_PNG
                            //     : LOGO_BBPS_FULL_PNG,
                            ),
                      ),
                    ],
                  ),

                  // Image.asset(
                  //   'packages/ebps/assets/logo/logo_equitas_normal.png',
                  //   height: 57,
                  //   width: 164,
                  // ),
                ),

                if (isLoginError)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 120.h),
                      MyAppText(
                        data: 'Failed to Login BBPS.',
                        size: 13.0.sp,
                        color: AppColors.CLR_PRIMARY,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 10.h),
                      MyAppText(
                        data: 'Please Contact Bank for more information.',
                        size: 13.0.sp,
                        color: AppColors.CLR_PRIMARY,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 40.h),
                      MyAppButton(
                          onPressed: () {
                            if (AppLoginFrom.IsFromSuperApp) {
                              AppTrigger.instance.goBackCallback!.call();
                            } else {
                              AppExit.instance.mainAppExit!.call();
                            }
                          },
                          buttonText: "Go Back",
                          buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                          buttonBorderColor: Colors.transparent,
                          buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                          buttonSizeX: 10.h,
                          buttonSizeY: 40.w,
                          buttonTextSize: 14.sp,
                          buttonTextWeight: FontWeight.w500),
                    ],
                  ),
                // SizedBox(height: 600),
                // MyAppText(
                //   data: 'UAT v1.0',
                //   size: 12.0,
                //   color: CLR_PRIMARY,
                //   weight: FontWeight.w800,
                // ),
              ],
            ),
          );
        },
      ),
      // bottomSheet: isLoginError
      //     ? Container(
      //         decoration: const BoxDecoration(
      //             border: Border(
      //                 top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
      //         child: Padding(
      //           padding:
      //               EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               Expanded(
      //                 child: MyAppButton(
      //                     onPressed: () {},
      //                     buttonText: "Go Back",
      //                     buttonTxtColor: CLR_PRIMARY,
      //                     buttonBorderColor: Colors.transparent,
      //                     buttonColor: BTN_CLR_ACTIVE,
      //                     buttonSizeX: 10.h,
      //                     buttonSizeY: 40.w,
      //                     buttonTextSize: 14.sp,
      //                     buttonTextWeight: FontWeight.w500),
      //               ),
      //               SizedBox(
      //                 width: 40.w,
      //               ),
      //               Expanded(
      //                 child: MyAppButton(
      //                     onPressed: () {
      //                       final uri = Uri.parse(widget.apiData.toString());
      //                       final id = uri.queryParameters['id'];
      //                       final hash = uri.queryParameters['hash'];

      //                       // logger.i(id);
      //                       // logger.i(hash);

      //                       BlocProvider.of<SplashCubit>(context)
      //                           .login(id.toString(), hash.toString());
      //                     },
      //                     buttonText: "Retry",
      //                     buttonTxtColor: BTN_CLR_ACTIVE,
      //                     buttonBorderColor: Colors.transparent,
      //                     buttonColor: CLR_PRIMARY,
      //                     buttonSizeX: 10.h,
      //                     buttonSizeY: 40.w,
      //                     buttonTextSize: 14.sp,
      //                     buttonTextWeight: FontWeight.w500),
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
      //     : null
    );
  }
}
