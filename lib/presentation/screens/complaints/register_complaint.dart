import 'package:ebps/constants/colors.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterComplaint extends StatefulWidget {
  const RegisterComplaint({super.key});

  @override
  State<RegisterComplaint> createState() => _RegisterComplaintState();
}

class _RegisterComplaintState extends State<RegisterComplaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Register Complaint',
        actions: [
          InkWell(
              // onTap: () => {goTo(context, sEARCHROUTE)},
              child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20, right: 15),
                  width: 40,
                  decoration: ShapeDecoration(
                    color: CLR_SECONDARY,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Container(
                    width: 20,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
        onLeadingTap: () => Navigator.pop(context),
        showActions: true,
        onSearchTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
