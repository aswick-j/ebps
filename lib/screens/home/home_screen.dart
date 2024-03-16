import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Home/home_banners.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/ebps.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/models/upcoming_dues_model.dart';
import 'package:ebps/screens/home/bill_categories.dart';
import 'package:ebps/screens/home/mismatch_notification.dart';
import 'package:ebps/screens/home/upcoming_dues.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MybillersCubit(repository: apiClient)),
      ],
      child: const HomeScreenUI(),
    );
  }
}

class HomeScreenUI extends StatefulWidget {
  const HomeScreenUI({super.key});

  @override
  State<HomeScreenUI> createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  List<AllConfigurations>? allautoPaymentList = [];
  List<AllConfigurationsData>? allautoPayData = [];
  List<SavedBillersData>? SavedBiller = [];
  List<Map<String, dynamic>> allUpcomingDues = [];
  List<UpcomingDuesData>? upcomingDuesData = [];
  List<UpcomingPaymentsData>? upcomingAutoPaymentData = [];
  bool isUpcomingDuesLoading = true;
  bool isUpcomingAutopaymentLoading = true;
  bool isSavedBillerLoading = true;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MybillersCubit>(context).getAutopay();
    BlocProvider.of<MybillersCubit>(context).getAllUpcomingDues();
    BlocProvider.of<MybillersCubit>(context).getSavedBillers();
  }

  bool isDataExist(List list, int? value) {
    var data = list.where((row) => (row["customerBillId"] == value));
    if (data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void generateDuesList() {
    allUpcomingDues = [];
    if (upcomingDuesData!.isNotEmpty) {
      upcomingDuesData?.forEach((item) {
        final tempUpcoming = {
          "itemType": "upcomingDue",
          "billName": item.billName ?? "",
          "billerName": item.billerName ?? "",
          "dueAmount": item.dueAmount ?? "",
          "dueDate": item.dueDate ?? "",
          "paymentDate": "",
          "customerBillId": item.customerBillID ?? "-",
          "categoryName": item.categoryName,
          "iSACTIVE": "",
          "billerParams": item.billerParams
        };

        if (!isDataExist(
            allUpcomingDues, int.parse(item.customerBillID.toString()))) {
          allUpcomingDues.add(tempUpcoming);
        }
      });
    }

    if (upcomingAutoPaymentData!.isNotEmpty) {
      upcomingAutoPaymentData?.forEach((item) {
        final tempUpcomingAutoPayment = {
          "itemType":
              item.iSACTIVE == 1 ? "upcomingPayments" : "upcomingAutopaused",
          "billName": item.bILLNAME ?? "",
          "billerName": item.bILLERNAME ?? "",
          "dueAmount": item.dUEAMOUNT ?? "",
          "dueDate": item.dUEDATE ?? "",
          "paymentDate": item.pAYMENTDATE ?? "",
          "categoryName": item.cATEGORYNAME ?? "",
          "iSACTIVE": item.iSACTIVE ?? "",
          "customerBillId": item.cUSTOMERBILLID ?? "",
          "billerParams": ""
        };

        if (isDataExist(
            allUpcomingDues, int.parse(item.cUSTOMERBILLID.toString()))) {
          allUpcomingDues.removeWhere(
              (element) => element["customerBillId"] == item.cUSTOMERBILLID);
        }
        allUpcomingDues.add(tempUpcomingAutoPayment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BuildContext dialogContext = context;
    handleDialog() {
      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return MismatchNotification(
              allautoPayData: allautoPayData,
              context: dialogContext,
              savedBiller: SavedBiller!);
        },
      );
    }

    handleSlider() async {
      var notifiValue = await getSharedNotificationValue("NOTIFICATION");
      if (!isUpcomingAutopaymentLoading &&
          !isUpcomingDuesLoading &&
          !isSavedBillerLoading &&
          notifiValue &&
          allautoPayData!.isNotEmpty) {
        handleDialog();
      }
    }

    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Bill Payment',
        actions: [
          if (!isUpcomingAutopaymentLoading &&
              !isUpcomingDuesLoading &&
              !isSavedBillerLoading &&
              allautoPayData!.isNotEmpty)
            IconBadge(
              notificationCount: allautoPayData!.length,
              onTap: () {
                handleDialog();
              },
            ),
          InkWell(
              onTap: () => {goTo(context, sEARCHROUTE)},
              child: Container(
                  margin: EdgeInsets.only(right: 15.w),
                  // width: 40.w,
                  // height: 40.h,
                  decoration: ShapeDecoration(
                    color: CLR_SECONDARY,
                    shape: CircleBorder(),
                  ),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )))
        ],
        onLeadingTap: () {
          //
          AppTrigger.instance.goBack();
        },
        showActions: true,
        onSearchTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: MultiBlocListener(
            listeners: [
              BlocListener<MybillersCubit, MybillersState>(
                listener: (context, state) async {
                  if (state is UpcomingDuesLoading) {
                    setState(() {
                      isUpcomingDuesLoading = true;
                    });
                  } else if (state is UpcomingDuesSuccess) {
                    List<UpcomingDuesData>? tempUpcomingDuesData =
                        state.upcomingDuesData;

                    List<UpcomingDuesData>? NullTemp = [];
                    List<UpcomingDuesData>? DueDateTemp = [];
                    List<UpcomingDuesData>? ExpiredDueDateTemp = [];

                    bool isDateExpired(DateTime date) {
                      DateTime currentDate = DateTime.now();
                      return date.isBefore(currentDate);
                    }

                    for (var i = 0; i < tempUpcomingDuesData!.length; i++) {
                      if (tempUpcomingDuesData[i].dueDate == null) {
                        NullTemp.add(tempUpcomingDuesData[i]);
                      } else if (isDateExpired(DateTime.parse(
                          tempUpcomingDuesData[i].dueDate.toString()))) {
                        ExpiredDueDateTemp.add(tempUpcomingDuesData[i]);
                      } else {
                        DueDateTemp.add(tempUpcomingDuesData[i]);
                      }
                    }

                    ExpiredDueDateTemp.sort((a, b) =>
                        DateTime.parse(a.dueDate.toString())
                            .compareTo(DateTime.parse(b.dueDate.toString())));
                    DueDateTemp.sort((a, b) =>
                        DateTime.parse(a.dueDate.toString())
                            .compareTo(DateTime.parse(b.dueDate.toString())));

                    List<UpcomingDuesData>? sortedData = [
                      ...DueDateTemp,
                      ...ExpiredDueDateTemp,
                      ...NullTemp
                    ];

                    setState(() {
                      upcomingDuesData = sortedData;
                      isUpcomingDuesLoading = false;
                    });
                    generateDuesList();
                    handleSlider();
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
                    isUpcomingAutopaymentLoading = true;
                  } else if (state is AutopaySuccess) {
                    allautoPaymentList =
                        state.autoScheduleData!.allConfigurations!;
                    if (state.autoScheduleData!.upcomingPayments!.isNotEmpty) {
                      upcomingAutoPaymentData =
                          state.autoScheduleData!.upcomingPayments![0].data;
                    }

                    generateDuesList();
                    setState(() {
                      isUpcomingAutopaymentLoading = false;

                      List<AllConfigurationsData>? autopayData = [];
                      for (int i = 0; i < allautoPaymentList!.length; i++) {
                        for (int j = 0;
                            j < allautoPaymentList![i].data!.length;
                            j++) {
                          autopayData.add(allautoPaymentList![i].data![j]);
                        }
                      }

                      List<AllConfigurationsData> newData = autopayData
                          .where((item) => item.rESETDATE == 1)
                          .toList();

                      List<AllConfigurationsData> newData2 = autopayData
                          .where((item) => item.rESETLIMIT == 1)
                          .toList();

                      List<AllConfigurationsData> modifiedData = newData2
                          .map((item) => AllConfigurationsData(
                              rESETDATE: 0,
                              rESETLIMIT: item.rESETLIMIT,
                              aCCOUNTNUMBER: item.aCCOUNTNUMBER,
                              aCTIVATESFROM: item.aCTIVATESFROM,
                              aMOUNTLIMIT: item.aMOUNTLIMIT,
                              bILLERICON: item.bILLERICON,
                              bILLERID: item.bILLERID,
                              bILLERNAME: item.bILLERNAME,
                              bILLNAME: item.bILLNAME,
                              cUSTOMERBILLID: item.cUSTOMERBILLID,
                              dUEAMOUNT: item.dUEAMOUNT,
                              cUSTOMERID: item.cUSTOMERID,
                              dUEDATE: item.dUEDATE,
                              iD: item.iD,
                              iSACTIVE: item.iSACTIVE,
                              iSBIMONTHLY: item.iSBIMONTHLY,
                              mAXIMUMAMOUNT: item.mAXIMUMAMOUNT,
                              pAID: item.pAID,
                              pAYMENTDATE: item.pAYMENTDATE))
                          .toList();

                      allautoPayData = [...newData, ...modifiedData];
                    });
                    handleSlider();
                  } else if (state is AutopayFailed) {
                    isUpcomingAutopaymentLoading = false;
                  } else if (state is AutopayError) {
                    isUpcomingAutopaymentLoading = false;
                  }
                  if (state is SavedBillerLoading) {
                    setState(() {
                      isSavedBillerLoading = true;
                    });
                  } else if (state is SavedBillersSuccess) {
                    SavedBiller = state.savedBillersData;
                    setState(() {
                      isSavedBillerLoading = false;
                    });
                    handleSlider();
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
              )
            ],
            child: Column(
              children: [
                if (!isUpcomingAutopaymentLoading &&
                    !isUpcomingDuesLoading &&
                    !isSavedBillerLoading)
                  UpcomingDues(
                    allUpcomingDues: allUpcomingDues,
                    SavedBiller: SavedBiller,
                    allautoPaymentList: allautoPaymentList,
                  ),
                BillCategories(),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: Text(
                    "V 0.0.32",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4c4c4c),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            )),
      ),
    );
  }
}
