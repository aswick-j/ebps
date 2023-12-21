import 'package:ebps/bloc/splash/splash_cubit.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/logger.dart';
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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // goToReplace(context, hOMEROUTE);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
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
                )
                    // Image.asset(
                    //   'packages/ebps/assets/logo/logo_equitas_normal.png',
                    //   height: 57,
                    //   width: 164,
                    // ),
                    ),
                if (isLoginError)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      MyAppText(
                        data: 'Oh no!',
                        size: 14.0,
                        color: CLR_PRIMARY,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 20),
                      MyAppText(
                        data: 'Something went wrong.',
                        size: 14.0,
                        color: CLR_PRIMARY,
                        weight: FontWeight.bold,
                      ),
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
