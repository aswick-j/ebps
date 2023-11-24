import 'dart:convert';
import 'dart:io';
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

class _MyHomePageState extends State<MyHomePage> {
  final String API_URL =
      'https://digiservicesuat.equitasbank.com/api/auth/redirect';

  String API_DATA = '';
  bool isLoading = false;

  Future<void> fetchData() async {
    try {
      isLoading = true;
      final checkSUm = p8['redirectionRequest']!['checkSum'];
      final response = await http.post(
        Uri.parse(API_URL),
        body: json.encode(p8['redirectionRequest']!['msgBdy']),
        headers: {
          'Content-Type': 'application/json',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              fetchData();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 1 / 14,
              width: MediaQuery.of(context).size.width * 3 / 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.purple,
                    ]),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(""),
                  const Text(
                    "Go to BBPS Screen",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.arrow_right_alt_outlined,
                        size: 25.0,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
