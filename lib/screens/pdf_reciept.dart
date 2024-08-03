import 'dart:convert';

import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class pdfReciept extends StatefulWidget {
  const pdfReciept({super.key});

  @override
  State<pdfReciept> createState() => _pdfRecieptState();
}

class _pdfRecieptState extends State<pdfReciept> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Transaction Receipt',
        onLeadingTap: () => {
          GoBack(context),
        },
        showActions: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 40.h, 0, 0),
        child: PdfPreview(
          allowPrinting: false,
          scrollViewDecoration: BoxDecoration(color: Colors.white),
          pdfPreviewPageDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0.r),
            border: Border.all(
              color: AppColors.CLR_GREY,
              width: 2.0,
            ),
          ),
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          initialPageFormat: PdfPageFormat.a4,
          loadingWidget: Loader(),
          build: (format) => _generatePdf(format, "title"),
        ),
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: MyAppButton(
                    onPressed: () async {
                      final result = await Printing.sharePdf(
                        bytes: await _generatePdf(PdfPageFormat.a4, 'title'),
                        filename: 'Transaction_Receipt.pdf',
                      );
                      if (result) {
                        print('Shared');
                      }
                    },
                    buttonText: "Share",
                    buttonTxtColor: AppColors.CLR_PRIMARY,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: AppColors.BTN_CLR_ACTIVE,
                    buttonSizeX: 10.h,
                    buttonSizeY: 40.w,
                    buttonTextSize: 14.sp,
                    buttonTextWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 40.w,
              ),
              Expanded(
                child: MyAppButton(
                    onPressed: () {
                      Printing.layoutPdf(
                        name: "Transaction Receipt",
                        onLayout: (PdfPageFormat format) async =>
                            _generatePdf(format, "title"),
                      );
                    },
                    buttonText: "Download",
                    buttonTxtColor: AppColors.BTN_CLR_ACTIVE,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: AppColors.CLR_PRIMARY,
                    buttonSizeX: 10.h,
                    buttonSizeY: 40.w,
                    buttonTextSize: 14.sp,
                    buttonTextWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );
  final font = await PdfGoogleFonts.nunitoExtraLight();

  final Uint8List imageBytes = base64Decode("s");
  final pw.Image image =
      pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain);

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            alignment: pw.Alignment.center,
            // height: 200,
            child: image,
          ),
        );
      }));

  return pdf.save();
}
