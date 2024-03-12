import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/bbps_settings_model.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class TermsAndConditions extends StatefulWidget {
  bbpsSettingsData? BbpsSettingInfo;
  TermsAndConditions({super.key, required this.BbpsSettingInfo});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final ScrollController _controller = ScrollController();

  bool reachEnd = false;

  _listener() {
    final maxScroll = _controller.position.maxScrollExtent;
    final minScroll = _controller.position.minScrollExtent;
    if (_controller.offset >= maxScroll) {
      setState(() {
        reachEnd = true;
      });
    }

    // if (_controller.offset <= minScroll) {
    //   setState(() {
    //     reachEnd = false;
    //   });
    // }
  }

  @override
  void initState() {
    _controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        left: true,
        top: true,
        right: true,
        maintainBottomViewPadding: true,
        minimum: EdgeInsets.zero,
        child: Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                  left: 16.0.w, top: 8.h, right: 16.w, bottom: 60.h),
              child: Container(
                height: 1000.h,
                child: SingleChildScrollView(
                    controller: _controller,
                    child: HtmlWidget(
                        textStyle: TextStyle(fontSize: 14.sp),
                        widget.BbpsSettingInfo!.tERMSANDCONDITIONS.toString())),
              ),
            ),
            bottomSheet: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: MyAppButton(
                          onPressed: reachEnd
                              ? () {
                                  goBack(context);
                                }
                              : () {},
                          buttonText: "Okay",
                          buttonTxtColor: BTN_CLR_ACTIVE,
                          buttonBorderColor: Colors.transparent,
                          buttonColor: reachEnd ? CLR_PRIMARY : Colors.grey,
                          buttonSizeX: 10.h,
                          buttonSizeY: 40.w,
                          buttonTextSize: 14.sp,
                          buttonTextWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )));
  }
}
