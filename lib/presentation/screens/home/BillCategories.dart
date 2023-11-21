import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/presentation/common/Container/Home/CategoriesContainer.dart';
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
                    categoriesCount: 4,
                    categoriesData: categoriesData,
                  ),
                ],
              )
            : Text("Loading");
      },
    );
    ;
  }
}
