import 'package:ebps/constants/assets.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(
    PdfPageFormat format,
    String BillerName,
    String BillerId,
    String BillName,
    String ParamName,
    String ParamValue,
    String TransactionID,
    String fromAccount,
    String billAmount,
    String status,
    String channel,
    TransactionDate) async {
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );
  final font = await PdfGoogleFonts.poppinsMedium();

  final ByteData bbpsbytes = await rootBundle.load(LOGO_BBPS_FULL_PNG);
  Uint8List bbpsbyteList = bbpsbytes.buffer.asUint8List();
  final ByteData equitasbytes = await rootBundle.load(LOGO_EQUITAS);
  Uint8List equitasList = equitasbytes.buffer.asUint8List();
  final ByteData bbpsAssuredbytes = await rootBundle.load(LOGO_BBPS_ASSURED_BW);
  Uint8List bbpsAssuredList = bbpsAssuredbytes.buffer.asUint8List();
  final ByteData equitasFooterbytes = await rootBundle.load(EQUITAS_FOOTER);
  Uint8List equitasFooterList = equitasFooterbytes.buffer.asUint8List();

  final PdfColor primaryColor = PdfColor.fromHex('#a9bbdb');
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
            margin: pw.EdgeInsets.symmetric(vertical: 64),
            decoration: pw.BoxDecoration(
              image: pw.DecorationImage(
                image: pw.MemoryImage(bbpsAssuredList),

                fit: pw.BoxFit.contain,

                // colorFilter: ColorFilter.mode(
                //     Colors.white.withOpacity(0.9), BlendMode.screen),
              ),
              border: pw.Border.all(color: primaryColor, width: 1),
            ),
            // decoration: pw.BoxDecoration(
            //   border: pw.Border.all(color: primaryColor, width: 1),

            //   // borderRadius: pw.BorderRadius.circular(5),
            // ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // height: 20,
                  // margin: pw.EdgeInsets.only(
                  //     left: 18.0, right: 18, top: 10, bottom: 10),
                  color: primaryColor,
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(pw.MemoryImage(equitasList),
                          height: 70, width: 70),
                      pw.Image(pw.MemoryImage(bbpsbyteList),
                          height: 70, width: 70),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(
                      left: 20, top: 25.0, bottom: 10.0),
                  child: pw.Text(
                    'Payment Receipt',
                    style: pw.TextStyle(
                      fontSize: 24.0,
                      font: font,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#1B438B"),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(
                      left: 20, top: 5.0, bottom: 10.0, right: 20),
                  child: pw.Text(
                    'Thank you for payment through Equitas Small Finance Bank.\nPlease quote your Transaction Reference ID below for payment queries',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 12.0,
                      color: PdfColor.fromHex("#1B438B"),
                    ),
                  ),
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        left: 20, top: 5.0, bottom: 10.0),
                    child: pw.Row(children: [
                      pw.Text(
                        'Bill Name :',
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          font: font,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex("#1B438B"),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        BillName,
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          font: font,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColor.fromHex("#1B438B"),
                        ),
                      ),
                    ])),
                // pw.Padding(
                //     padding: const pw.EdgeInsets.only(
                //         left: 20, top: 5.0, bottom: 10.0),
                //     child: pw.Row(children: [
                //       pw.Text(
                //         'Transaction Time :',
                //         style: pw.TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: pw.FontWeight.bold,
                //           color: PdfColor.fromHex("#1B438B"),
                //         ),
                //       ),
                //       pw.SizedBox(width: 10),
                //       pw.Text(
                //         '10-MAR-2015 6.20 PM',
                //         style: pw.TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: pw.FontWeight.normal,
                //           color: PdfColor.fromHex("#1B438B"),
                //         ),
                //       ),
                //     ])),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(
                      left: 20, right: 20.0, bottom: 10.0, top: 20.0),
                  child: pw.TableHelper.fromTextArray(
                      context: context,
                      headers: <dynamic>['Transaction Details', ""],
                      border: pw.TableBorder.all(color: primaryColor, width: 1),

                      // rowDecoration:
                      //     pw.BoxDecoration(color: PdfColor.fromHex("f0f7ff")),
                      cellStyle: pw.TextStyle(
                          font: font,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColor.fromHex("#1B438B")),
                      headerStyle: pw.TextStyle(
                          font: font,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex("#1B438B")),
                      // headerDecoration:
                      //     pw.BoxDecoration(color: PdfColor.fromHex("f0f7ff")),

                      data: <List>[
                        [
                          'Name of the Biller',
                          BillerName,
                        ],
                        [
                          'Biller Id',
                          BillerId,
                        ],
                        [
                          ParamName,
                          ParamValue,
                        ],
                        [
                          'Transaction Reference Id',
                          TransactionID != "null" ? TransactionID : "-",
                        ],
                        [
                          'Payment Channel ',
                          channel,
                        ],
                        [
                          'Debited Account',
                          fromAccount,
                        ],
                        ['Paid Amount', billAmount],
                        [
                          'Transaction Date and Time',
                          TransactionDate,
                        ],
                        [
                          'Status',
                          status,
                        ],
                      ]),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 20),
                  child: pw.Image(pw.MemoryImage(equitasFooterList)),
                )
              ],
            ));
      }));

  return pdf.save();
}
