// import 'ebps_platform_interface.dart';

// class Ebps {
//   Future<String?> getPlatformVersion() {
//     return EbpsPlatform.instance.getPlatformVersion();
//   }
// }
import 'package:ebps/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EbpsScreen extends StatelessWidget {
  String apiData;
  EbpsScreen({Key? key, required this.apiData}) : super(key: key);

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
      initialRoute: sPLASHROUTE,
      onGenerateInitialRoutes: (initialRoute) => [
        router.generateRoute(
          RouteSettings(name: sPLASHROUTE, arguments: apiData),
        )!
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      // home: splashScreen(apiData: apiData)
    );
  }
}
