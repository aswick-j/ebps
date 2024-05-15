import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/Container/Home/categories_container.dart';
import 'package:ebps/helpers/getBillerCategory.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillCategories extends StatefulWidget {
  final void Function(bool) isCategoryLoading;
  const BillCategories({super.key, required this.isCategoryLoading});

  @override
  State<BillCategories> createState() => _BillCategoriesState();
}

class _BillCategoriesState extends State<BillCategories> {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(repository: apiClient),
      child: BillerCategoriesUI(
        isCategoryLoading: (bool) {
          widget.isCategoryLoading(bool);
        },
      ),
    );
  }
}

class BillerCategoriesUI extends StatefulWidget {
  final void Function(bool) isCategoryLoading;
  const BillerCategoriesUI({super.key, required this.isCategoryLoading});

  @override
  State<BillerCategoriesUI> createState() => _BillerCategoriesUIState();
}

class _BillerCategoriesUIState extends State<BillerCategoriesUI>
    with AutomaticKeepAliveClientMixin {
  //Storing the categories Data
  List<CategorieData>? categoriesData = [];
  List<CategorieData> MoreCategories = [];

  //Category Loading

  bool isCategoryLoading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is CategoriesLoading) {
          isCategoryLoading = true;
          widget.isCategoryLoading(true);
        } else if (state is CategoriesSuccess) {
          categoriesData = state.CategoriesList;
          if (categoriesData != null) {
            MoreCategories = categoriesData!
                .where((item) => ExcludedCategories.every(
                    (value) => !item.cATEGORYNAME!.contains(value)))
                .toList();
          }
          isCategoryLoading = false;
          widget.isCategoryLoading(false);
        } else if (state is CategoriesFailed) {
          isCategoryLoading = false;
          widget.isCategoryLoading(false);
        } else if (state is CategoriesError) {
          isCategoryLoading = false;
          widget.isCategoryLoading(false);
        }
      },
      builder: (context, state) {
        return !isCategoryLoading
            ? categoriesData!.isNotEmpty
                ? Column(
                    children: [
                      CategoriesContainer(
                        headerName: "Bill Categories",
                        categoriesCount: 8,
                        categoriesData: categoriesData,
                        viewall: true,
                      ),
                      CategoriesContainer(
                        headerName: "More Services",
                        categoriesCount: MoreCategories.length,
                        categoriesData: MoreCategories,
                      ),
                    ],
                  )
                : Container()
            : Container(height: 200.h, child: Center(child: Loader()));
      },
    );
  }
}
