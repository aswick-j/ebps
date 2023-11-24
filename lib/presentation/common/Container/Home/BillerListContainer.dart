import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class BillerListContainer extends StatefulWidget {
  dynamic id;

  BillerListContainer({super.key, required this.id});

  @override
  State<BillerListContainer> createState() => _BillerListContainerState();
}

class _BillerListContainerState extends State<BillerListContainer> {
  final infiniteScrollController = ScrollController();

  List<BillersData>? Allbiller = [];
  bool isAllBiller = false;

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id);
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id);
    initScrollController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<HomeCubit, HomeState>(builder: (context, state)  {
    //   if (state is AllbillerListLoading && state.isFirstFetch) {}
    //   if (state is AllbillerListLoading) {
    //     Allbiller = state.prevData;
    //   } else if (state is AllbillerListSuccess) {
    //     Allbiller = state.allbillerList;
    //   } else if (state is AllbillerListFailed) {
    //   } else if (state is AllbillerListError) {}
    // }
    return Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0 + 2),
          border: Border.all(
            color: Color(0xffD1D9E8),
            width: 1.0,
          ),
        ),
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          if (state is AllbillerListLoading && state.isFirstFetch) {}
          bool isLoading = false;
          // isAllBiller = true;
          if (state is AllbillerListLoading) {
            Allbiller = state.prevData;
            // isLoading = true;
            isAllBiller = false;
          } else if (state is AllbillerListSuccess) {
            Allbiller = state.allbillerList;
            isLoading = false;
          } else if (state is AllbillerListFailed) {
            isAllBiller = false;
          } else if (state is AllbillerListError) {
            if (state.message!.contains('Invalid')) {
              // goTo(context, sESSIONEXPIRED);
            }
            isAllBiller = false;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6.0),
                    topLeft: Radius.circular(6.0)),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.menu, color: Color(0xffffffff)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "All Billers",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
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
                ),
              ),
              SizedBox(height: 15),
              if (isAllBiller) Text("Loading...."),
              if (!isAllBiller)
                Container(
                  height: 600,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: Allbiller!.length,
                    physics: const BouncingScrollPhysics(),
                    controller: infiniteScrollController,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          goToData(context, bILLERPARAMROUTE, {
                            "BILLER_DATA": Allbiller![index],
                            "BILLER_INPUT_SIGN": []
                          });
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => BillParameters()));
                        },
                        child: ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 6, right: 6, top: 0),
                            leading: Container(
                              width: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: SvgPicture.asset(LOGO_BBPS),
                              ),
                            ),
                            title: Text(
                              Allbiller![index].bILLERNAME.toString(),
                              // "Airtel Digital TV",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff4c4c4c),
                              ),
                              textAlign: TextAlign.left,
                            )),
                      );
                    },
                  ),
                )
            ],
          );
        }));
  }
}
