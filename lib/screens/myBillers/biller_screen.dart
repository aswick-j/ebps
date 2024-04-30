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
import 'package:ebps/widget/no_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<SavedBillersData>? savedBillerDataTemp = [];
  List<SavedBillersData>? savedBillerData = [];
  List<UpcomingDuesData>? upcomingDuesData = [];
  List<UpcomingPaymentsData>? upcomingPaymentList = [];
  List<AllConfigurations>? allautoPaymentList = [];
  final searchController = TextEditingController();

  bool isUpcomingDuesLoading = true;
  bool isUpcomingAutopaymentLoading = true;
  bool isSavedBillerLoading = true;
  bool showSearch = false;
  bool isMyBillersPageError = false;
  @override
  void initState() {
    super.initState();

    BlocProvider.of<MybillersCubit>(context).getAllUpcomingDues();
    BlocProvider.of<MybillersCubit>(context).getAutopay();
    BlocProvider.of<MybillersCubit>(context).getSavedBillers();
  }

  @override
  Widget build(BuildContext context) {
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

    getBillerDataWithUpcomingFirst(billerResponseData) {
      try {
        List billerData = billerResponseData!;

        List TempAutoData = [];
        List TempDueData = [];
        List TempBillData = [];

        for (var i = 0; i < billerData.length; i++) {
          if (getupcomingAutoPaymentList(billerData[i].cUSTOMERBILLID) != '') {
            TempAutoData.add(billerData[i]!);
          } else if (getUpcmoingDueData(billerData[i].cUSTOMERBILLID) != "") {
            TempDueData.add(billerData[i]!);
          } else {
            TempBillData.add(billerData[i]!);
          }
        }
        TempAutoData.sort((a, b) =>
            a.bILLERNAME.toLowerCase().compareTo(b.bILLERNAME.toLowerCase()));
        TempDueData.sort((a, b) =>
            a.bILLERNAME.toLowerCase().compareTo(b.bILLERNAME.toLowerCase()));
        TempBillData.sort((a, b) =>
            a.bILLERNAME.toLowerCase().compareTo(b.bILLERNAME.toLowerCase()));
        return [...TempAutoData, ...TempDueData, ...TempBillData];
        // return billerData;
      } catch (e) {}
    }

    getUpcmoingDueList(customerBILLID) {
      List<UpcomingDuesData>? find = upcomingDuesData!
          .where((items) => items.customerBillID == customerBILLID)
          .toList();

      return find.isNotEmpty ? find[0] : null;
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
      backgroundColor: AppColors.CLR_BACKGROUND,
      appBar: MyAppBar(
        context: context,
        FormField: showSearch ? true : null,
        title: !showSearch
            ? 'My Billers'
            : TextFormField(
                autofocus: true,
                controller: searchController,
                onChanged: (searchTxt) {
                  List<SavedBillersData>? searchData = [];

                  searchData = savedBillerDataTemp!.where((item) {
                    final bILLERNAME = item.bILLERNAME.toString().toLowerCase();
                    final bILLNAME = item.bILLNAME.toString().toLowerCase();
                    final searchLower = searchTxt.toLowerCase();
                    return bILLERNAME.contains(searchLower) ||
                        bILLNAME.contains(searchLower);
                  }).toList();

                  setState(() {
                    savedBillerData = searchData;
                  });
                },
                onFieldSubmitted: (_) {},
                keyboardType: TextInputType.text,
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-z0-9A-Z. ]*'))
                ],
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchController.clear();

                      setState(() {
                        showSearch = false;
                        savedBillerData = savedBillerDataTemp;
                      });
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 26,
                      color: AppColors.CLR_PRIMARY,
                    ),
                  ),
                  hintText: "Search a Biller",
                  hintStyle: TextStyle(color: CLR_GREY),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
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
        actions: showSearch
            ? null
            : [
                IconButton(
                  splashRadius: 25,
                  onPressed: () => setState(() {
                    showSearch = true;
                  }),
                  icon: Icon(
                    Icons.search,
                    color: AppColors.CLR_ICON,
                  ),
                ),
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
                      color: AppColors.CLR_ICON,
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
              isMyBillersPageError = true;
              setState(() {
                isUpcomingDuesLoading = false;
              });
            } else if (state is UpcomingDuesError) {
              isMyBillersPageError = true;

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
              isMyBillersPageError = true;

              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            } else if (state is AutopayError) {
              isMyBillersPageError = true;

              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            }
            if (state is SavedBillerLoading) {
              setState(() {
                isSavedBillerLoading = true;
              });
            } else if (state is SavedBillersSuccess) {
              savedBillerDataTemp = state.savedBillersData;
              savedBillerData = state.savedBillersData;
              setState(() {
                isSavedBillerLoading = false;
              });
            } else if (state is SavedBillersFailed) {
              isMyBillersPageError = true;

              setState(() {
                isSavedBillerLoading = false;
              });
            } else if (state is SavedBillersError) {
              isMyBillersPageError = true;

              setState(() {
                isSavedBillerLoading = false;
              });
            }
          },
          builder: (context, state) {
            return !isMyBillersPageError
                ? Column(
                    children: [
                      if (!isUpcomingDuesLoading &&
                          !isUpcomingAutopaymentLoading &&
                          !isSavedBillerLoading)
                        Container(
                          child: getBillerDataWithUpcomingFirst(
                                              savedBillerData)!
                                          .length ==
                                      0 &&
                                  searchController.text.isEmpty
                              ? NoDataFound(
                                  message: "No Billers Found",
                                )
                              : getBillerDataWithUpcomingFirst(savedBillerData)!
                                              .length ==
                                          0 &&
                                      searchController.text.isNotEmpty
                                  // ? LottieAnimation(
                                  //   aniJsonIndex: 0,
                                  //   secondaryIndex: 0,
                                  //   showTitle: false,
                                  //   titleIndex: 0,
                                  // )
                                  ? NoDataFound(
                                      showRichText: true,
                                      message1: searchController.text,
                                      message2:
                                          "Try checking for typos or using complete words.",
                                      message: "No Billers Found for ",
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: getBillerDataWithUpcomingFirst(
                                              savedBillerData)!
                                          .length,
                                      physics: const BouncingScrollPhysics(),
                                      // controller: infiniteScrollController,
                                      itemBuilder: (context, index) {
                                        return MyBillersContainer(
                                            upcomingDueData: getUpcmoingDueList(
                                                getBillerDataWithUpcomingFirst(
                                                        savedBillerData)![index]
                                                    .cUSTOMERBILLID),
                                            buttonText:
                                                getAllAutopayList(getBillerDataWithUpcomingFirst(savedBillerData)![index].cUSTOMERBILLID) ==
                                                        0
                                                    ? "Autopay Paused"
                                                    : showAutopayButtonContent(
                                                        getBillerDataWithUpcomingFirst(
                                                                savedBillerData)![
                                                            index],
                                                      )
                                                        ? 'Autopay Enabled'
                                                        : "Enable Autopay",
                                            iconPath: BILLER_LOGO(
                                                getBillerDataWithUpcomingFirst(
                                                        savedBillerData)![index]
                                                    .bILLERNAME
                                                    .toString()),
                                            upcomingText: getupcomingAutoPaymentList(
                                                        getBillerDataWithUpcomingFirst(savedBillerData)![index]
                                                            .cUSTOMERBILLID) !=
                                                    ''
                                                ? 'Upcoming Autopay'
                                                : getUpcmoingDueData(getBillerDataWithUpcomingFirst(savedBillerData)![index].cUSTOMERBILLID) != ""
                                                    ? "Upcoming Due"
                                                    : "",
                                            upcomingTXT_CLR_DEFAULT: getupcomingAutoPaymentList(getBillerDataWithUpcomingFirst(savedBillerData)![index].cUSTOMERBILLID) != ''
                                                ? Color(0xff00AB44)
                                                : getUpcmoingDueData(getBillerDataWithUpcomingFirst(savedBillerData)![index].cUSTOMERBILLID) != ""
                                                    ? CLR_ASTRIX
                                                    : Colors.black,
                                            showButton: showAutopayBtn(getBillerDataWithUpcomingFirst(savedBillerData)![index]),
                                            containerBorderColor: Color(0xffD1D9E8),
                                            buttonColor: Color.fromARGB(255, 255, 255, 255),
                                            buttonTxtColor: getAllAutopayList(getBillerDataWithUpcomingFirst(savedBillerData)![index].cUSTOMERBILLID) == 0
                                                ? Color.fromARGB(255, 171, 39, 30)
                                                : showAutopayButtonContent(
                                                    getBillerDataWithUpcomingFirst(
                                                            savedBillerData)![
                                                        index],
                                                  )
                                                    ? Color.fromARGB(255, 16, 113, 55)
                                                    : CLR_PRIMARY,
                                            buttonTextWeight: FontWeight.bold,
                                            buttonBorderColor: showAutopayButtonContent(
                                              getBillerDataWithUpcomingFirst(
                                                  savedBillerData)![index],
                                            )
                                                ? Color(0xff00AB44)
                                                : Color(0xff768eb9),
                                            SavedinputParameters: getBillerDataWithUpcomingFirst(savedBillerData)![index].pARAMETERS,
                                            savedBillersData: getBillerDataWithUpcomingFirst(savedBillerData)![index],
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
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   begin: Alignment.bottomCenter,
                      //   end: Alignment.topCenter,
                      //   colors: [
                      //     CLR_BLUESHADE.withOpacity(0.9),
                      //     Colors.white,
                      //   ],
                      //   stops: const [
                      //     0,
                      //     0.2,
                      //   ],
                      // ),
                      borderRadius: BorderRadius.circular(6.0.r + 2.r),
                      border: Border.all(
                        color: Color(0xffD1D9E8),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: 350.h,
                          child: noResult(
                            showTitle: false,
                            ErrIndex: 10,
                            ImgIndex: 5,
                            width: 130.h,
                          )),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
