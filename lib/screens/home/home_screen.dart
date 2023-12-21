import 'dart:convert';

import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/ebps.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/screens/home/bill_categories.dart';
import 'package:ebps/screens/home/mismatch_notification.dart';
import 'package:ebps/screens/home/upcoming_dues.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MybillersCubit>(context).getAutopay();
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
              allautoPayData: allautoPayData, context: dialogContext);
        },
      );
    }

    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Bill Payment',
        actions: [
          if (allautoPayData!.isNotEmpty)
            GestureDetector(
                onTap: () {
                  handleDialog();
                },
                child: SvgPicture.asset(ICON_BELL)),
          SizedBox(
            width: 5.w,
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
        child: BlocConsumer<MybillersCubit, MybillersState>(
          listener: (context, state) async {
            if (state is AutoPayLoading) {
            } else if (state is AutopaySuccess) {
              setState(() {
                allautoPaymentList = state.autoScheduleData!.allConfigurations!;

                List<AllConfigurationsData>? autopayData = [];
                for (int i = 0; i < allautoPaymentList!.length; i++) {
                  for (int j = 0;
                      j < allautoPaymentList![i].data!.length;
                      j++) {
                    autopayData.add(allautoPaymentList![i].data![j]);
                  }
                }

                List<AllConfigurationsData> newData = autopayData
                    .where(
                        (item) => item.rESETDATE == 1 || item.rESETLIMIT == 1)
                    .toList();

                List<AllConfigurationsData> newData2 = autopayData
                    .where(
                        (item) => item.rESETDATE == 1 && item.rESETLIMIT == 1)
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
              var notifiValue =
                  await getSharedNotificationValue("NOTIFICATION");
              if (notifiValue && allautoPayData!.isNotEmpty) {
                handleDialog();
              }
            } else if (state is AutopayFailed) {
            } else if (state is AutopayError) {}
          },
          builder: (context, state) {
            return Column(
              children: [
                UpcomingDues(),
                // HomeBanners(),

                BillCategories(),
                SizedBox(
                  height: 10.h,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
