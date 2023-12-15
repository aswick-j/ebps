import 'package:ebps/domain/models/complaints_model.dart';
import 'package:ebps/domain/services/api_client.dart';
import 'package:ebps/shared/common/AppBar/MyAppBar.dart';
import 'package:ebps/shared/common/Container/Complaint/complaint_container.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/widget/flickr_loader.dart';
import 'package:ebps/ui/controllers/bloc/complaint/complaint_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Raised Complaints',
        actions: [],
        onLeadingTap: () => Navigator.pop(context),
        showActions: true,
        onSearchTap: () => Navigator.pop(context),
      ),
      body: BlocProvider(
        create: (context) => ComplaintCubit(repository: apiClient),
        child: ComplaintList(),
      ),
    );
  }
}

class ComplaintList extends StatefulWidget {
  const ComplaintList({super.key});

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  List<ComplaintsData> ComplaintList = [];
  bool isComplaintDetailsLoading = true;

  @override
  void initState() {
    BlocProvider.of<ComplaintCubit>(context).getAllComplaints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
      if (state is ComplaintLoading) {
        isComplaintDetailsLoading = true;
      } else if (state is ComplaintSuccess) {
        ComplaintList = state.ComplaintList!;
        isComplaintDetailsLoading = false;
      } else if (state is ComplaintFailed) {
        isComplaintDetailsLoading = false;
      } else if (state is ComplaintError) {
        isComplaintDetailsLoading = false;
      }
    }, builder: (context, state) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            !isComplaintDetailsLoading
                ? ComplaintList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: ComplaintList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ComplaintContainer(
                            titleText:
                                ComplaintList[index].bILLERNAME.toString(),
                            subtitleText:
                                ComplaintList[index].cOMPLAINTID.toString(),
                            dateText: DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(ComplaintList[index]
                                        .cREATEDON
                                        .toString())
                                    .toLocal()),
                            amount:
                                "₹ ${NumberFormat('#,##,##0.00').format(double.parse(ComplaintList[index].bILLAMOUNT.toString()))}",
                            statusText: ComplaintList[index].sTATUS,
                            complaintData: ComplaintList[index],
                            iconPath: LOGO_BBPS,
                            containerBorderColor: Color(0xffD1D9E8),
                          );
                        },
                      )
                    : Center(child: Text("No Complaints Raised"))
                : Container(
                    height: 500,
                    width: double.infinity,
                    child: Center(child: FlickrLoader())),
          ],
        ),
      );
    });
  }
}
