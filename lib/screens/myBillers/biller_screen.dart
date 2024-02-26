import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Container/MyBillers/mybiller_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/models/upcoming_dues_model.dart';
import 'package:ebps/screens/nodataFound.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillerScreen extends StatefulWidget {
  const BillerScreen({super.key});

  @override
  State<BillerScreen> createState() => _BillerScreenState();
}

class _BillerScreenState extends State<BillerScreen> {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MybillersCubit(repository: apiClient)),
        BlocProvider(create: (_) => HistoryCubit(repository: apiClient)),
      ],
      child: const BillerScreenUI(),
    );
  }
}

class BillerScreenUI extends StatefulWidget {
  const BillerScreenUI({super.key});

  @override
  State<BillerScreenUI> createState() => _BillerScreenUIState();
}

class _BillerScreenUIState extends State<BillerScreenUI> {
  List<SavedBillersData>? savedBillerData = [];
  List<UpcomingDuesData>? upcomingDuesData = [];
  List<UpcomingPaymentsData>? upcomingPaymentList = [];
  List<AllConfigurations>? allautoPaymentList = [];

  bool isUpcomingDuesLoading = true;
  bool isUpcomingAutopaymentLoading = true;
  bool isSavedBillerLoading = true;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<MybillersCubit>(context).getAllUpcomingDues();
    BlocProvider.of<MybillersCubit>(context).getAutopay();
    BlocProvider.of<MybillersCubit>(context).getSavedBillers();
  }

  @override
  Widget build(BuildContext context) {
    getBillerDataWithUpcomingFirst(billerResponseData) {
      try {
        List billerData = billerResponseData!;
        List tempUpcomingDuedata;
        List tempBillerData;
        List<UpcomingPaymentsData>? upcomingReversed =
            upcomingPaymentList!.reversed.toList();

        List<UpcomingDuesData>? upcomingReversedAgain =
            upcomingDuesData!.reversed.toList();

        for (var i = 0; i < upcomingReversedAgain.length; i++) {
          tempUpcomingDuedata = billerData
              .where((element) =>
                  element.cUSTOMERBILLID ==
                  upcomingReversedAgain[i].customerBillID)
              .toList();

          for (var j = 0; j < tempUpcomingDuedata.length; j++) {
            billerData.remove(tempUpcomingDuedata[j]);
            billerData.insert(0, tempUpcomingDuedata[j]);
          }
        }

        for (var i = 0; i < upcomingReversed.length; i++) {
          tempBillerData = billerData
              .where((element) =>
                  element.cUSTOMERBILLID == upcomingReversed[i].cUSTOMERBILLID)
              .toList();
          for (var j = 0; j < tempBillerData.length; j++) {
            billerData.remove(tempBillerData[j]);
            billerData.insert(0, tempBillerData[j]);
          }
        }

        return billerData;
      } catch (e) {}
    }

    getupcomingAutoPaymentList(customerBILLID) {
      try {
        List<UpcomingPaymentsData>? find = upcomingPaymentList!
            .where((items) => items.cUSTOMERBILLID == customerBILLID)
            .toList();

        return (find.isNotEmpty ? find[0] : "");
      } catch (e) {
        return e;
      }
    }

    getUpcmoingDueData(customerBILLID) {
      List<UpcomingDuesData>? find = upcomingDuesData!
          .where((items) => items.customerBillID == customerBILLID)
          .toList();

      return (find.isNotEmpty ? find[0] : "");
    }

    getUpcmoingDueList(customerBILLID) {
      List<UpcomingDuesData>? find = upcomingDuesData!
          .where((items) => items.customerBillID == customerBILLID)
          .toList();

      return find;
    }

    getAllAutopayList(customerBILLID) {
      try {
        List<AllConfigurationsData>? autopayData = [];
        for (int i = 0; i < allautoPaymentList!.length; i++) {
          for (int j = 0; j < allautoPaymentList![i].data!.length; j++) {
            autopayData.add(allautoPaymentList![i].data![j]);
          }
        }

        List<AllConfigurationsData>? find = autopayData
            .where((item) => item.cUSTOMERBILLID == customerBILLID)
            .toList();

        return (find.isNotEmpty ? find[0].iSACTIVE : null);
      } catch (e) {}
    }

    getDueAmount(customerBILLID) {
      try {
        List<UpcomingDuesData>? find = upcomingDuesData!
            .where((items) => items.customerBillID == customerBILLID)
            .toList();
        return (find.isNotEmpty ? find[0].dueAmount : "");
      } catch (e) {}
    }

    showAutopayButtonContent(SavedBillersData savedBiller) {
      if (savedBiller.aUTOPAYID == null &&
          (savedBiller.tRANSACTIONSTATUS == "success" ||
              getUpcmoingDueData(savedBiller.cUSTOMERBILLID) != "") &&
          savedBiller.bILLERACCEPTSADHOC == "N") {
        return false;
      } else {
        return true;
      }
    }

    showAutopayBtn(SavedBillersData savedBiller) {
      if (((savedBiller.aUTOPAYID != null) ||
          (savedBiller.aUTOPAYID == null &&
              savedBiller.cUSTOMERBILLID != null &&
              (savedBiller.tRANSACTIONSTATUS == "success" ||
                  getUpcmoingDueData(savedBiller.cUSTOMERBILLID) != "") &&
              savedBiller.bILLERACCEPTSADHOC == "N"))) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'My Billers',
        onLeadingTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
          // goToReplace(context, hOMEROUTE);
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => BottomNavBar(
                      SelectedIndex: 0,
                    )),
          );
        }),
        actions: [
          Tooltip(
            textStyle: TextStyle(color: Colors.white),
            decoration: BoxDecoration(
                color: CLR_BLUE_LITE,
                borderRadius: BorderRadius.circular(8.0.r)),
            triggerMode: TooltipTriggerMode.tap,
            showDuration: Duration(milliseconds: 20000),
            padding: EdgeInsets.all(20.r),
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            message:
                "Auto Pay is supported only for selected billers and is enabled after you pay a bill atleast once for a  biller or if the biller has an due.",
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.info_outline,
                color: CLR_PRIMARY,
              ),
            ),
          ),
        ],
        showActions: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocConsumer<MybillersCubit, MybillersState>(
          listener: (context, state) {
            if (state is UpcomingDuesLoading) {
              setState(() {
                isUpcomingDuesLoading = true;
              });
            } else if (state is UpcomingDuesSuccess) {
              upcomingDuesData = state.upcomingDuesData;

              setState(() {
                isUpcomingDuesLoading = false;
              });
            } else if (state is UpcomingDuesFailed) {
              setState(() {
                isUpcomingDuesLoading = false;
              });
            } else if (state is UpcomingDuesError) {
              setState(() {
                isUpcomingDuesLoading = false;
              });
            }
            if (state is AutoPayLoading) {
              setState(() {
                isUpcomingAutopaymentLoading = true;
              });
            } else if (state is AutopaySuccess) {
              allautoPaymentList = state.autoScheduleData!.allConfigurations!;
              upcomingPaymentList =
                  state.autoScheduleData!.upcomingPayments!.isEmpty
                      ? []
                      : state.autoScheduleData!.upcomingPayments![0].data;

              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            } else if (state is AutopayFailed) {
              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            } else if (state is AutopayError) {
              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            }
            if (state is SavedBillerLoading) {
              setState(() {
                isSavedBillerLoading = true;
              });
            } else if (state is SavedBillersSuccess) {
              savedBillerData = state.savedBillersData;
              setState(() {
                isSavedBillerLoading = false;
              });
            } else if (state is SavedBillersFailed) {
              setState(() {
                isSavedBillerLoading = false;
              });
            } else if (state is SavedBillersError) {
              setState(() {
                isSavedBillerLoading = false;
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (!isUpcomingDuesLoading &&
                    !isUpcomingAutopaymentLoading &&
                    !isSavedBillerLoading)
                  Container(
                    child: getBillerDataWithUpcomingFirst(savedBillerData)!
                                .length ==
                            0
                        ? NoDataFound(
                            message: "No Billers Found",
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                                getBillerDataWithUpcomingFirst(savedBillerData)!
                                    .length,
                            physics: const BouncingScrollPhysics(),
                            // controller: infiniteScrollController,
                            itemBuilder: (context, index) {
                              return MyBillersContainer(
                                  upcomingDueData: getUpcmoingDueList(
                                      savedBillerData![index].cUSTOMERBILLID),
                                  buttonText:
                                      getAllAutopayList(savedBillerData![index].cUSTOMERBILLID) ==
                                              0
                                          ? "Autopay Paused"
                                          : showAutopayButtonContent(
                                              savedBillerData![index],
                                            )
                                              ? 'Autopay Enabled'
                                              : "Enable Autopay",
                                  iconPath: BILLER_LOGO(savedBillerData![index]
                                      .bILLERNAME
                                      .toString()),
                                  upcomingText: getupcomingAutoPaymentList(
                                              savedBillerData![index]
                                                  .cUSTOMERBILLID) !=
                                          ''
                                      ? 'Upcoming Autopay'
                                      : getUpcmoingDueData(savedBillerData![index]
                                                  .cUSTOMERBILLID) !=
                                              ""
                                          ? "Upcoming Due"
                                          : "",
                                  upcomingTXT_CLR_DEFAULT: getupcomingAutoPaymentList(
                                              savedBillerData![index].cUSTOMERBILLID) !=
                                          ''
                                      ? Color(0xff00AB44)
                                      : getUpcmoingDueData(savedBillerData![index].cUSTOMERBILLID) != ""
                                          ? CLR_ASTRIX
                                          : Colors.black,
                                  showButton: showAutopayBtn(savedBillerData![index]),
                                  containerBorderColor: Color(0xffD1D9E8),
                                  buttonColor: Color.fromARGB(255, 255, 255, 255),
                                  buttonTxtColor: getAllAutopayList(savedBillerData![index].cUSTOMERBILLID) == 0
                                      ? Color.fromARGB(255, 171, 39, 30)
                                      : showAutopayButtonContent(
                                          savedBillerData![index],
                                        )
                                          ? Color.fromARGB(255, 16, 113, 55)
                                          : Color(0xff768eb9),
                                  buttonTextWeight: FontWeight.bold,
                                  buttonBorderColor: showAutopayButtonContent(
                                    savedBillerData![index],
                                  )
                                      ? Color(0xff00AB44)
                                      : Color(0xff768eb9),
                                  SavedinputParameters: savedBillerData![index].pARAMETERS,
                                  savedBillersData: savedBillerData![index],
                                  allautoPaymentList: allautoPaymentList);
                            },
                          ),
                  ),
                if (isUpcomingDuesLoading ||
                    isUpcomingAutopaymentLoading ||
                    isSavedBillerLoading)
                  Center(
                    child: Container(
                      height: 500.h,
                      child: FlickrLoader(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
