// import 'package:ebps/constants/routes.dart';
// import 'package:ebps/constants/sizes.dart';
// import 'package:ebps/helpers/getNavigators.dart';
// import 'package:flutter/material.dart';

// final GlobalKey _dialogKey = GlobalKey();

// customDialog({
//   context,
//   message,
//   title,
// }) {
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) {
//       return Dialog(
//         key: _dialogKey,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         elevation: 16,
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           height: height(context) / 2,
//           child: Container(
//             alignment: Alignment.center,
//             margin: EdgeInsets.symmetric(
//                 horizontal: width(context) * 0.04,
//                 vertical: width(context) * 0.04),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Navigator.of(context).pop();
//                 goTo(context, hOMEROUTE)],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
