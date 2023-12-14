import 'package:ebps/domain/models/categories_model.dart';
import 'package:ebps/domain/services/api_client.dart';
import 'package:ebps/shared/helpers/getBillerCategory.dart';
import 'package:ebps/shared/common/Container/Home/categories_container.dart';
import 'package:ebps/shared/widget/flickr_loader.dart';
import 'package:ebps/ui/controllers/bloc/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillCategories extends StatefulWidget {
  const BillCategories({super.key});

  @override
  State<BillCategories> createState() => _BillCategoriesState();
}

class _BillCategoriesState extends State<BillCategories> {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(repository: apiClient),
      child: const BillerCategoriesUI(),
    );
  }
}

class BillerCategoriesUI extends StatefulWidget {
  const BillerCategoriesUI({super.key});

  @override
  State<BillerCategoriesUI> createState() => _BillerCategoriesUIState();
}

class _BillerCategoriesUIState extends State<BillerCategoriesUI> {
  //Storing the categories Data
  List<CategorieData>? categoriesData = [];
  List<CategorieData> MoreCategories = [];

  //Category Loading

  bool isCategoryLoading = true;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is CategoriesLoading) {
          isCategoryLoading = true;
        } else if (state is CategoriesSuccess) {
          categoriesData = state.CategoriesList;
          if (categoriesData != null) {
            MoreCategories = categoriesData!
                .where((item) => ExcludedCategories.every(
                    (value) => !item.cATEGORYNAME!.contains(value)))
                .toList();
          }
          isCategoryLoading = false;
        } else if (state is CategoriesFailed) {
          isCategoryLoading = false;
        } else if (state is CategoriesError) {
          isCategoryLoading = false;
        }
      },
      builder: (context, state) {
        return !isCategoryLoading
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
            : Center(
                child:
                    Container(height: 200, width: 200, child: FlickrLoader()),
              );
      },
    );
  }
}
