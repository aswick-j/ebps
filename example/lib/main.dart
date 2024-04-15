import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:ebps/widget/centralized_grid_view.dart';
import 'package:ebps_example/Mock_Params.dart';
import 'package:ebps_example/PluginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MB Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final String API_URL =
      'https://digiservicesuat.equitasbank.com/api/auth/redirect';

  String API_DATA = '';
  bool isLoading = false;

  Future<void> fetchData(val) async {
    try {
      isLoading = true;
      String jsonString = json.encode(val['redirectionRequest']!['msgBdy']);
      //MB HASHING KEY
      String hashKey = "ahsdfjkhaklsdf657";
      String dataToHash = "$jsonString$hashKey";

      Digest sha512Digest = sha512.convert(utf8.encode(dataToHash));
      String sha512HashHex = sha512Digest.toString();
      // final checkSUm = val['redirectionRequest']!['checkSum'];
      final checkSUm = sha512HashHex;
      print(sha512HashHex);
      final response = await http.post(
        Uri.parse(API_URL),
        body: json.encode(val['redirectionRequest']!['msgBdy']),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'checkSum': checkSUm as String,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        API_DATA = data["data"].toString();
        isLoading = false;
        if (API_DATA.isNotEmpty) {
          await Future.delayed(Duration.zero);
          // print(API_DATA);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PluginScreen(apiData: API_DATA),
            ),
          );
        } else {
          print('API_DATA is empty');
        }
      } else {
        throw Exception('Failed ==== >');
      }
    } catch (e) {
      isLoading = false;

      print(e.toString());
    }
  }

  late Timer _timer;
  final List<Color> _colors = [
    const Color.fromARGB(255, 161, 173, 255).withOpacity(0.2),
    const Color.fromARGB(255, 161, 249, 255).withOpacity(0.2),
    const Color.fromARGB(255, 161, 173, 255).withOpacity(0.2),
    const Color.fromARGB(255, 202, 255, 171).withOpacity(0.2),
    const Color.fromARGB(255, 255, 253, 155).withOpacity(0.2),
    const Color.fromARGB(255, 153, 255, 153).withOpacity(0.2),
    const Color.fromARGB(255, 150, 150, 255).withOpacity(0.2),
    const Color.fromARGB(255, 212, 151, 255).withOpacity(0.2),
    const Color.fromARGB(255, 223, 147, 255).withOpacity(0.5),
  ];
  double _animationValue = 0.0;

  // List value = [p13, p13];
  // List Name = ["Dhivya", "Nithiya"];
  // List Img = [
  //   // "https://cdn.iconscout.com/icon/free/png-512/free-avatar-378-456330.png?f=webp&w=512",
  //   "https://cdn.iconscout.com/icon/free/png-512/free-avatar-369-456321.png?f=webp&w=512"
  // ];
  List value = [p3, p7, p19, p21];
  List Name = ["Balaji", "Aswick", "Nithiya", "Divya"];
  List Img = [
    "https://cdn.iconscout.com/icon/free/png-512/free-avatar-366-456318.png?f=webp&w=512",
    //"https://cdn.iconscout.com/icon/free/png-512/free-avatar-371-456323.png?f=webp&w=512",
    "https://cdn.iconscout.com/icon/free/png-512/free-avatar-370-456322.png?f=webp&w=512",
    //"https://cdn.iconscout.com/icon/free/png-512/free-avatar-378-456330.png?f=webp&w=512",
    "https://cdn.iconscout.com/icon/free/png-512/free-avatar-373-456325.png?f=webp&w=512",
    "https://cdn.iconscout.com/icon/free/png-512/free-avatar-369-456321.png?f=webp&w=512",
    // "https://cdn.iconscout.com/icon/free/png-512/free-avatar-369-456321.png?f=webp&w=512",
  ];

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        _animationValue = (sin(timer.tick / 60) + 1) / 2;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _interpolateColor(_animationValue),
            _interpolateColor((_animationValue + 0.1) % 1.0),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: value.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    itemCount: value.length,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        fetchData(value[index]);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: Image.network(Img[index])),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Name[index],
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Color _interpolateColor(double t) {
    final index1 = (t * (_colors.length - 1)).floor();
    final index2 = (index1 + 1) % _colors.length;
    final color1 = _colors[index1];
    final color2 = _colors[index2];
    final factor = t * (_colors.length - 1) - index1;
    return Color.lerp(color1, color2, factor)!;
  }
}
