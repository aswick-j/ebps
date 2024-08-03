import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ebps/widget/centralized_grid_view.dart';
import 'package:ebps_example/GenerateRequestBody.dart';
import 'package:ebps_example/MockDatas.dart';
import 'package:ebps_example/PluginScreen.dart';
import 'package:ebps_example/aes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({
    super.key,
  });

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen>
    with TickerProviderStateMixin {
  late bool isPrd = false;

  String API_DATA = '';
  String flavor = "uat";
  bool isLoading = false;
  bool? eliteTheme = null;
  int randomNumber = 3667;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        _animationValue = (sin(timer.tick / 60) + 1) / 2;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchData(val) async {
    try {
      var RequestData = RequestBody(
          val["accounts"],
          val["otpPreference"],
          val["gndr"],
          val["mblNb"],
          val["dob"],
          val["custId"],
          val["emailId"],
          eliteTheme == null
              ? val["eliteFlag"]
              : eliteTheme == true
                  ? "Y"
                  : "N");

      dynamic datas = await encryptingData(json.encode(RequestData), isPrd);
      var encRequestBody = EncRequestBody(datas);
      String jsonString = json.encode(RequestData);

      isLoading = true;
      //MB HASHING KEY
      String hashKey = "ahsdfjkhaklsdf657";
      String dataToHash = "$jsonString$hashKey";
      Digest sha512Digest = sha512.convert(utf8.encode(dataToHash));
      String sha512HashHex = sha512Digest.toString();
      final checkSum = sha512HashHex;
      print(sha512HashHex);
      final response = await http.post(
        Uri.parse(isPrd
            ? 'https://digiservices.equitasbank.com/bbps/api/auth/redirect'
            : 'https://digiservicesuat.equitasbank.com/bbps/api/auth/redirect'),
        body: json.encode(encRequestBody),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'checkSum': checkSum,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String EN_API_DATA =
            await dencryptingData(data["response"].toString(), isPrd);
        var DC_API_DATA = jsonDecode(jsonDecode(EN_API_DATA));
        API_DATA = DC_API_DATA["data"];
        isLoading = false;
        if (API_DATA.isNotEmpty) {
          await Future.delayed(Duration.zero);
          // print(API_DATA);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PluginScreen(apiData: API_DATA, flavor: flavor),
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
    const Color(0xff1B438B).withOpacity(0.2),
    Color.fromRGBO(161, 249, 255, 1).withOpacity(0.2),
    const Color.fromARGB(255, 202, 255, 171).withOpacity(0.2),
    const Color.fromARGB(255, 255, 253, 155).withOpacity(0.2),
    Color.fromARGB(255, 255, 202, 155).withOpacity(0.2),
    const Color.fromARGB(255, 153, 255, 153).withOpacity(0.2),
    const Color(0xff1B438B).withOpacity(0.2),
    const Color.fromARGB(255, 212, 151, 255).withOpacity(0.2),
  ];
  double _animationValue = 0.0;
  void toggle() {
    setState(() {
      randomNumber = Random().nextInt(1000);

      isPrd = !isPrd;
      flavor = isPrd ? "prd" : "uat";

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     behavior: SnackBarBehavior.floating,
      //     margin: const EdgeInsets.all(24),
      //     elevation: 0,
      //     duration: const Duration(seconds: 2),
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //     content: Center(
      //         child: Text(
      //       'Environment Changed to ${isPrd ? "Production" : "UAT"}',
      //       style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      //     ))));
    });
  }

  handleSnackbar() {}

  @override
  Widget build(BuildContext context) {
    Color _interpolateColor(double t) {
      final index1 = (t * (_colors.length - 1)).floor();
      final index2 = (index1 + 1) % _colors.length;
      final color1 = _colors[index1];
      final color2 = _colors[index2];
      final factor = t * (_colors.length - 1) - index1;
      return Color.lerp(color1, color2, factor)!;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        elevation: 2,
        backgroundColor: Color(0xff1B438B),
        title: Text(
          "BBPS Demo Application - ${isPrd ? "Production" : "UAT"}",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSwitch(
                applyTheme: true,
                trackColor: Color.fromARGB(255, 108, 136, 186),
                activeColor: Color.fromARGB(255, 255, 8, 0),
                // activeColor: Colors.white,
                value: isPrd,
                onChanged: (val) {
                  toggle();

                  setState(() {
                    isPrd = val;
                  });
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isPrd)
              Container(
                color: Colors.red,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "Your in Production Mode",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            if (eliteTheme != null)
              Container(
                color: Colors.orange.shade100,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "All Themes are Overided by ${eliteTheme == true ? "Elite" : "Default"} Theme",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _interpolateColor(_animationValue),
                    _interpolateColor((_animationValue + 0.1) % 1.0),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: isPrd ? PRD.length : UAT.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        itemCount: isPrd ? PRD.length : UAT.length,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            fetchData(isPrd ? PRD[index] : UAT[index]);
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(Icons.star)
                                  // child: Image.network(
                                  //     "https://api.multiavatar.com/${index + randomNumber}.png")
                                  ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  isPrd
                                      ? PRD[index]["name"].toString()
                                      : UAT[index]["name"].toString(),
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.refresh),
              backgroundColor: Color(0xff1B438B),
              onPressed: () {
                setState(() {
                  randomNumber = Random().nextInt(1000);
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              heroTag: "Ss",
              label: Text("Hard Theme"),
              icon: Icon(Icons.change_circle_rounded),
              // child: Icon(Icons.change_circle_rounded),
              backgroundColor: Color(0xff1B438B),
              onPressed: () {
                setState(() {
                  eliteTheme = eliteTheme == null ? true : !eliteTheme!;
                  // handleSnackbar();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
