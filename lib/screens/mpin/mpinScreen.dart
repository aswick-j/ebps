// import 'package:ebps/bloc/home/home_cubit.dart';
// import 'package:ebps/constants/colors.dart';
// import 'package:ebps/constants/routes.dart';
// import 'package:ebps/constants/sizes.dart';
// import 'package:ebps/data/models/auto_schedule_pay_model.dart';
// import 'package:ebps/helpers/getNavigators.dart';
// import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
// import 'package:ebps/presentation/common/Button/MyAppButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MpinScreen extends StatefulWidget {
//   AllConfigurationsData? autopayData;
//   String? id;

//   Map<String, dynamic>? data;
//   MpinScreen({super.key, this.autopayData, this.id, this.data});

//   @override
//   State<MpinScreen> createState() => _MpinScreenState();
// }

// class _MpinScreenState extends State<MpinScreen> {
//   TextEditingController? contrller1;
//   TextEditingController? contrller2;
//   TextEditingController? contrller3;
//   TextEditingController? contrller4;

//   @override
//   void initState() {
//     super.initState();
//     contrller1 = TextEditingController();
//     contrller2 = TextEditingController();
//     contrller3 = TextEditingController();
//     contrller4 = TextEditingController();
//   }

//   handleSubmit() {
//     BlocProvider.of<HomeCubit>(context).payBill(
//         widget.data!['billerID'],
//         widget.data!['billerName'],
//         widget.data!['billName'],
//         widget.data!['acNo'],
//         widget.data!['billAmount'],
//         widget.data!['customerBillID'],
//         widget.data!['tnxRefKey'],
//         widget.data!['quickPay'],
//         widget.data!['inputSignature'],
//         widget.data!['otherAmount'],
//         false,
//         widget.data!['billerData'],
//         "2222");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(
//         context: context,
//         title: widget.data!['billerName'],
//         onLeadingTap: () => Navigator.pop(context),
//         showActions: false,
//       ),
//       body: BlocConsumer<HomeCubit, HomeState>(
//         listener: (context, state) {
//           if (state is PayBillLoading) {
//           } else if (state is PayBillSuccess) {
//             GoToData(context, tRANSROUTE, {
//               "billName": widget.data!["billName"],
//               "billerName": widget.data!['billerName'],
//               "categoryName": widget.data!["categoryName"],
//               "billerData": state.data,
//               "inputParameters": widget.data!['inputSignature'],
//               "isSavedBill": state.data!['isSavedBill'],
//             });
//           } else if (state is PayBillFailed) {
//             GoToData(context, tRANSROUTE, {
//               "billName": widget.data!["billName"],
//               "billerName": widget.data!['billerName'],
//               "categoryName": widget.data!["categoryName"],
//               "billerData": state.data,
//               "inputParameters": widget.data!['inputSignature'],
//               "isSavedBill": state.data!['isSavedBill'],
//             });
//           } else if (state is PayBillError) {}
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                     clipBehavior: Clip.hardEdge,
//                     width: double.infinity,
//                     margin: EdgeInsets.only(
//                         left: 20.0, right: 20, top: 20, bottom: 0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(6.0 + 2),
//                       border: Border.all(
//                         color: Color(0xffD1D9E8),
//                         width: 1.0,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(6.0),
//                               topLeft: Radius.circular(6.0)),
//                           child: Container(
//                             width: double.infinity,
//                             alignment: Alignment.center,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topRight,
//                                 stops: [0.001, 19],
//                                 colors: [
//                                   Color(0xff768EB9).withOpacity(.7),
//                                   Color(0xff463A8D).withOpacity(.7),
//                                 ],
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "MPIN Verification",
//                                   style: TextStyle(
//                                     fontSize: TXT_SIZE_LARGE(context),
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xffffffff),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "Enter 4-Digit MPIN",
//                           style: TextStyle(
//                             fontSize: TXT_SIZE_XL(context),
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xff1b438b),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 32.0, vertical: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _textFieldOTP(
//                                   first: true,
//                                   last: false,
//                                   controllerr: contrller1,
//                                   context: context),
//                               _textFieldOTP(
//                                   first: false,
//                                   last: false,
//                                   controllerr: contrller2,
//                                   context: context),
//                               _textFieldOTP(
//                                   first: false,
//                                   last: false,
//                                   controllerr: contrller3,
//                                   context: context),
//                               _textFieldOTP(
//                                   first: false,
//                                   last: true,
//                                   controllerr: contrller4,
//                                   context: context),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           "MPIN will keep your account secure from unauthorized access. Do not share this PIN with anyone",
//                           style: TextStyle(
//                             fontSize: TXT_SIZE_NORMAL(context),
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xff808080),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(
//                           height: 20,
//                         )
//                       ],
//                     ))
//               ],
//             ),
//           );
//         },
//       ),
//       bottomSheet: Container(
//         decoration: BoxDecoration(
//             border:
//                 Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Expanded(
//                 child: MyAppButton(
//                     onPressed: () {
//                       // BlocProvider.of<HomeCubit>(context).validateOTP(0000);
//                       handleSubmit();
//                     },
//                     buttonText: "Verify",
//                     buttonTxtColor: BTN_CLR_ACTIVE,
//                     buttonBorderColor: Colors.transparent,
//                     buttonColor: CLR_PRIMARY,
//                     buttonSizeX: 10,
//                     buttonSizeY: 40,
//                     buttonTextSize: 14,
//                     buttonTextWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _textFieldOTP(
//     {bool? first,
//     last,
//     TextEditingController? controllerr,
//     required BuildContext context}) {
//   return SizedBox(
//     height: 70,
//     child: AspectRatio(
//       aspectRatio: 1,
//       child: TextField(
//         controller: controllerr,
//         autofocus: true,
//         onChanged: (value) {
//           if (value.length == 1 && last == false) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.length == 0 && first == false) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         showCursor: false,
//         readOnly: false,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         decoration: InputDecoration(
//           counter: Offstage(),
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.black54),
//               borderRadius: BorderRadius.circular(12)),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.black54),
//               borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     ),
//   );
// }
