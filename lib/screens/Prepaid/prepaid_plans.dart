import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Prepaid/prepaid_conatiner.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/dot_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrepaidPlans extends StatefulWidget {
  BillersData? billerData;
  SavedBillersData? savedBillerData;

  List<PrepaidPlansData>? prepaidPlans;
  bool isFetchPlans;
  String mobileNumber;
  String operator;
  String circle;
  String billName;
  List<AddbillerpayloadModel>? inputParameters;
  List<PARAMETERS>? SavedinputParameters;
  bool isSavedBill;

  PrepaidPlans(
      {Key? key,
      this.billerData,
      required this.SavedinputParameters,
      required this.billName,
      required this.circle,
      required this.inputParameters,
      required this.isFetchPlans,
      required this.mobileNumber,
      required this.operator,
      this.prepaidPlans,
      required this.isSavedBill})
      : super(key: key);
  @override
  State<PrepaidPlans> createState() => _PrepaidPlansState();
}

class _PrepaidPlansState extends State<PrepaidPlans>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List categoryList = [];
  Map<String, dynamic>? validateBill;
  Map<String, dynamic> billerInputSign = {};

  @override
  void initState() {
    super.initState();
    handleInitial();
    handleCatgeoryList();
    // _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  handleInitial() {
    if (widget.isSavedBill) {
      setState(() {
        validateBill = getBillerType(
            widget.savedBillerData!.fETCHREQUIREMENT,
            widget.savedBillerData!.bILLERACCEPTSADHOC,
            widget.savedBillerData!.sUPPORTBILLVALIDATION,
            widget.savedBillerData!.pAYMENTEXACTNESS);
      });
    } else {
      setState(() {
        validateBill = getBillerType(
            widget.billerData!.fETCHREQUIREMENT,
            widget.billerData!.bILLERACCEPTSADHOC,
            widget.billerData!.sUPPORTBILLVALIDATION,
            widget.billerData!.pAYMENTEXACTNESS);
      });
    }

    if (widget.isSavedBill) {
      if (widget.SavedinputParameters != null) {
        for (var element in widget.SavedinputParameters!) {
          billerInputSign[element.pARAMETERNAME.toString()] =
              element.pARAMETERVALUE.toString();
        }
      }
    } else {
      if (widget.inputParameters != null) {
        for (var element in widget.inputParameters!) {
          billerInputSign[element.pARAMETERNAME.toString()] =
              element.pARAMETERVALUE.toString();
        }
      }
    }
  }

  handleCatgeoryList() {
    var tempCategoryList = [];
    widget.prepaidPlans?.forEach((element) {
      if (!tempCategoryList.contains(element.categoryType!.toString())) {
        tempCategoryList.add(element.categoryType);
      }
    });
    tempCategoryList.insert(0, 'All');
    dynamic SeperatedCategoryList = Map.fromEntries(
            tempCategoryList.map((e) => MapEntry(e.toLowerCase(), e)))
        .values
        .toList();

    setState(() {
      categoryList = SeperatedCategoryList;
      _tabController = TabController(
          length: SeperatedCategoryList.length, vsync: this, initialIndex: 0);
    });
  }

  handlePay({String? amount, PrepaidPlansData? planDetails}) {
    List<AddbillerpayloadModel> inputPayloadData = [];

    if (widget.isSavedBill) {
    } else {
      for (var i = 0; i < widget.inputParameters!.length; i++) {
        AddbillerpayloadModel makeInput;
        makeInput = AddbillerpayloadModel(
            bILLERID: widget.inputParameters![i].bILLERID,
            pARAMETERID: widget.inputParameters![i].pARAMETERID,
            pARAMETERNAME: widget.inputParameters![i].pARAMETERNAME,
            pARAMETERTYPE: widget.inputParameters![i].pARAMETERTYPE,
            mINLENGTH: widget.inputParameters![i].mINLENGTH,
            mAXLENGTH: widget.inputParameters![i].mAXLENGTH,
            // rEGEX:  widget.inputParameters![i].rEGEX,
            rEGEX: null,
            oPTIONAL: widget.inputParameters![i].oPTIONAL,
            eRROR: '',
            pARAMETERVALUE: widget.inputParameters![i].pARAMETERNAME
                        .toString()
                        .toLowerCase() ==
                    'id'
                ? planDetails!.billerPlanId.toString()
                : widget.inputParameters![i].pARAMETERVALUE);
        inputPayloadData.add(makeInput);
      }

      goToData(context, pAYMENTCONFIRMROUTE, {
        "name": widget.billerData!.bILLERNAME,
        "billName": widget.billerData!.bILLERNAME,
        "billerData": widget.billerData,
        "savedBillersData": widget.savedBillerData,
        "inputParameters": widget.inputParameters,
        "SavedinputParameters": widget.SavedinputParameters,
        "categoryName": widget.billerData!.cATEGORYNAME,
        "isSavedBill": false,
        "amount": amount,
        "validateBill": validateBill,
        "billerInputSign": billerInputSign,
        "planDetails": planDetails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    handlePlans(String? PlanCategory) {
      List<PrepaidPlansData>? Plans = widget.prepaidPlans;
      List<PrepaidPlansData>? filteredPlansByCategory = [];

      if (PlanCategory == 'All') {
        filteredPlansByCategory = Plans;
      } else {
        filteredPlansByCategory = Plans!
            .where((element) => element.categoryType == PlanCategory)
            .toList();
      }
      return filteredPlansByCategory;
    }

    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: "Select Plan",
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.start,
                isScrollable: true,
                indicatorColor: CLR_PRIMARY,
                indicator: DotIndicator(),
                labelStyle:
                    TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                unselectedLabelColor: CLR_PRIMARY_LITE,
                labelColor: CLR_PRIMARY,
                controller: _tabController,
                tabs: [
                  for (var item in categoryList)
                    Tab(
                      text: item,
                    ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 550.h,
                  child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: _tabController,
                      children: [
                        for (var item in categoryList)
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: handlePlans(item.toString())!.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return PrepaidPlansContainer(
                                  onPressed: () {
                                    handlePay(
                                        amount:
                                            handlePlans(item.toString())![index]
                                                .amount
                                                .toString(),
                                        planDetails: handlePlans(
                                            item.toString())![index]);
                                  },
                                  billerData: widget.billerData,
                                  prepaidPlans:
                                      handlePlans(item.toString())![index]);
                            },
                          ),
                      ]),
                ),
                SizedBox(height: 10.h)
              ],
            ),
          ],
        ));
  }
}
