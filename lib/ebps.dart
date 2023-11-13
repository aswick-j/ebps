// import 'ebps_platform_interface.dart';

// class Ebps {
//   Future<String?> getPlatformVersion() {
//     return EbpsPlatform.instance.getPlatformVersion();
//   }
// }
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EbpsScreen extends StatelessWidget {
  const EbpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final router = MyRouter();

    return MaterialApp(
        title: "Bill Payment",
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        // initialRoute: "/",
        // onGenerateInitialRoutes: (initialRoute) => [
        //   router.generateRoute(
        //     const RouteSettings(
        //       name: "/",
        //     ),
        //   )!
        // ],
        debugShowCheckedModeBanner: false,
        // onGenerateRoute: router.generateRoute,
        home: BottomNavBar());
  }
}
