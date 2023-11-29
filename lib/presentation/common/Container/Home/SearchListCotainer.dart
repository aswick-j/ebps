import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SearchListContainer extends StatefulWidget {
  SearchListContainer({super.key});

  @override
  State<SearchListContainer> createState() => _SearchListContainerState();
}

class _SearchListContainerState extends State<SearchListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          constraints: const BoxConstraints(
            maxWidth: 340,
          ),
          hintText: 'Search by Billers',
          hintStyle: MaterialStateProperty.all(TextStyle(
              color: Color(0xff1b438b), fontSize: TXT_SIZE_SMALL(context))),
          trailing: [
            IconButton(
              icon: const Icon(Icons.search,
                  color: Color.fromRGBO(164, 180, 209, 100)),
              onPressed: () {},
            ),
          ],
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        Container(
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            // height: height(context) * 0.,
            margin: EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0 + 2),
              border: Border.all(
                color: Color(0xffD1D9E8),
                width: 1.0,
              ),
            ),
            // child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
            // return Column(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                // if (isAllBiller) Text("Loading...."),
                // if (!isAllBiller)
                //   Container(
                //     height: height(context) * 0.65,
                //     child: ListView.builder(
                //       scrollDirection: Axis.vertical,
                //       shrinkWrap: true,
                //       itemCount: Allbiller!.length,
                //       physics: const BouncingScrollPhysics(),
                //       controller: infiniteScrollController,
                //       itemBuilder: (context, index) {
                //         return GestureDetector(
                //           onTap: () {
                //             goToData(context, bILLERPARAMROUTE, {
                //               "BILLER_DATA": Allbiller![index],
                //               "BILLER_INPUT_SIGN": []
                //             });
                //             // Navigator.of(context).push(MaterialPageRoute(
                //             //     builder: (context) => BillParameters()));
                //           },
                //           child: ListTile(
                //               contentPadding:
                //                   EdgeInsets.only(left: 6, right: 6, top: 0),
                //               leading: Container(
                //                 width: 50,
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(15),
                //                   child: SvgPicture.asset(LOGO_BBPS),
                //                 ),
                //               ),
                //               title: Text(
                //                 Allbiller![index].bILLERNAME.toString(),
                //                 // "Airtel Digital TV",
                //                 style: TextStyle(
                //                   fontSize: TXT_SIZE_LARGE(context),
                //                   fontWeight: FontWeight.w400,
                //                   color: Color(0xff4c4c4c),
                //                 ),
                //                 textAlign: TextAlign.left,
                //               )),
                //         );
                //       },
                //     ),
                //   ),
              ],
            )),
      ],
    );
  }
}
