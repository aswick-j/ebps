import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Container/Home/BillerListContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillerList extends StatefulWidget {
  dynamic id;
  String name;
  BillerList({super.key, required this.id, required this.name});

  @override
  State<BillerList> createState() => _BillerListState();
}

class _BillerListState extends State<BillerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: widget.name,
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: Column(children: [
          SearchBar(
            constraints: const BoxConstraints(
              maxWidth: 340,
            ),
            hintText: 'Search by Billers',
            hintStyle: MaterialStateProperty.all(
                const TextStyle(color: Color(0xff1b438b))),
            trailing: [
              IconButton(
                icon: const Icon(Icons.search,
                    color: Color.fromRGBO(164, 180, 209, 100)),
                onPressed: () {},
              ),
            ],
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          BillerListContainer(
            id: widget.id,
          )
        ]));
  }
}
