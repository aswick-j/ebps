import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/data/models/account_info_model.dart';
import 'package:ebps/data/models/add_biller_model.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/Home/BillerDetailsContainer.dart';
import 'package:ebps/presentation/screens/otp/OtpScreen.dart';
import 'package:ebps/presentation/widget/getBillerDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PaymentDetails extends StatefulWidget {
  int? billID;
  String? billerName;
  String? billName;
  String? categoryName;
  bool isSavedBill;
  BillersData? billerData;
  String? amount;
  List<AddbillerpayloadModel>? inputParameters;

  PaymentDetails(
      {Key? key,
      required this.billID,
      required this.billerName,
      required this.isSavedBill,
      this.billName,
      this.billerData,
      this.inputParameters,
      this.categoryName,
      this.amount})
      : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  bool isAccLoading = true;
  List<AccountsData>? accountInfo = [];

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: widget.billerName.toString(),
          onLeadingTap: () => Navigator.pop(context),
          showActions: false,
        ),
        body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
          if (state is AccountInfoLoading) {
            isAccLoading = true;
          } else if (state is AccountInfoSuccess) {
            accountInfo = state.accountInfo;

            isAccLoading = false;
          } else if (state is AccountInfoFailed) {
            isAccLoading = false;
          } else if (state is AccountInfoError) {}
        }, builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 20.0, right: 20, top: 20, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0 + 2),
                      border: Border.all(
                        color: Color(0xffD1D9E8),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              stops: [0.001, 19],
                              colors: [
                                Color(0xff768EB9).withOpacity(.7),
                                Color(0xff463A8D).withOpacity(.7),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Payment Details",
                                style: TextStyle(
                                  fontSize: TXT_SIZE_LARGE(context),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffffffff),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        BillerDetailsContainer(
                          icon: 'packages/ebps/assets/icon/logo_bbps.svg',
                          billerName: widget.billerName.toString(),
                          categoryName: widget.categoryName.toString(),
                        ),
                        Container(
                            width: double.infinity,
                            height: 100,
                            color: Colors.white,
                            child: GridView.count(
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 2,
                              children: [
                                billerDetail(
                                    widget.inputParameters![0].pARAMETERNAME,
                                    widget.inputParameters![0].pARAMETERVALUE
                                        .toString(),
                                    context),
                                billerDetail("Bill Name",
                                    widget.billName.toString(), context),
                              ],
                            )),
                        // Container(
                        //   width: double.infinity,
                        //   height: 80,
                        //   color: Colors.white,
                        //   child: GridView.builder(
                        //       shrinkWrap: true,
                        //       itemCount: 2,
                        //       physics: NeverScrollableScrollPhysics(),
                        //       gridDelegate:
                        //           SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 2,
                        //         // mainAxisSpacing: 10,
                        //       ),
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             // margin: EdgeInsets.all(10),
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(2),
                        //             ),
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               children: [
                        //                 Padding(
                        //                     padding: const EdgeInsets.fromLTRB(
                        //                         8, 10, 0, 0),
                        //                     child: Text(
                        //                       "Subscriber ID",
                        //                       style: const TextStyle(
                        //                         fontSize: 13,
                        //                         fontWeight: FontWeight.w400,
                        //                         color: Color(0xff808080),
                        //                       ),
                        //                       textAlign: TextAlign.center,
                        //                     )),
                        //                 Padding(
                        //                     padding: const EdgeInsets.fromLTRB(
                        //                         8, 10, 0, 0),
                        //                     child: Text(
                        //                       "1155552343",
                        //                       style: const TextStyle(
                        //                         fontSize : TXT_SIZE_LARGE(context),
                        //                         fontWeight: FontWeight.w500,
                        //                         color: Color(0xff1b438b),
                        //                       ),
                        //                       textAlign: TextAlign.left,
                        //                     ))
                        //               ],
                        //             ));
                        //       }),
                        // ),
                        Divider(
                          height: 10,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount",
                                style: TextStyle(
                                  fontSize: TXT_SIZE_LARGE(context),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff808080),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "₹ ${widget.amount}",
                                style: TextStyle(
                                  fontSize: TXT_SIZE_XL(context),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1b438b),
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: Text(
                    "Select Payment Account",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: TXT_SIZE_LARGE(context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1b438b),
                      height: 23 / 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (!isAccLoading && myAccounts!.length > 0)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: accountInfo!.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                              clipBehavior: Clip.hardEdge,
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20, top: 20, bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0 + 2),
                                border: Border.all(
                                  color: Color(0xffD1D9E8),
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 0, 0),
                                      child: Text(
                                        accountInfo![index]
                                            .accountNumber
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: TXT_SIZE_NORMAL(context),
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff808080),
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 0, 0),
                                      child: Text(
                                        "Balance Amount",
                                        style: TextStyle(
                                          fontSize: TXT_SIZE_SMALL(context),
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff808080),
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 0, 0),
                                      child: Text(
                                        "₹ ${accountInfo![index].balance.toString()}",
                                        style: TextStyle(
                                          fontSize: TXT_SIZE_XL(context),
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff0e2146),
                                        ),
                                        textAlign: TextAlign.left,
                                      ))
                                ],
                              ));
                        }),
                  ),
                Container(
                    height: 30, width: 30, child: SvgPicture.asset(LOGO_BBPS))
              ],
            ),
          );
        }),
        bottomSheet: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: MyAppButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OtpScreen()));
                      },
                      buttonText: "Proceed to Pay",
                      buttonTXT_CLR_DEFAULT: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: CLR_PRIMARY,
                      buttonSizeX: 10,
                      buttonSizeY: 40,
                      buttonTextSize: 14,
                      buttonTextWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ));
  }
}
