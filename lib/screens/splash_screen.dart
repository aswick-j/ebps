import 'package:ebps/bloc/splash/splash_cubit.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/ebps.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:flutter/cupertino.dart';
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
          } else if (state is SplashSuccess) {
            myAccounts = await getDecodedAccounts();
            isLoginError = false;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // goToReplace(context, hOMEROUTE);
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => BottomNavBar(
                          SelectedIndex: 0,
                        )),
              );
            });
          } else if (state is SplashError) {
            isLoginError = true;
            // WidgetsBinding.instance?.addPostFrameCallback((_) {
            //   Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context) => BottomNavBar()),
            //   );
            // });
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
                colors: const [
                  CLR_BLUESHADE,
                  Colors.white,
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
                        child: Image.asset(
                          LOGO_BBPS_FULL_PNG,
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
                        data: 'Unable to Login BBPS.',
                        size: 13.0.sp,
                        color: CLR_PRIMARY,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 10.h),
                      MyAppText(
                        data: 'Please Contact Bank for more information.',
                        size: 13.0.sp,
                        color: CLR_PRIMARY,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 40.h),
                      MyAppButton(
                          onPressed: () {
                            AppTrigger.instance.goBackCallback!.call();
                          },
                          buttonText: "Go Back",
                          buttonTxtColor: BTN_CLR_ACTIVE,
                          buttonBorderColor: Colors.transparent,
                          buttonColor: CLR_PRIMARY,
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
    );
  }
}
