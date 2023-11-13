import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Home/BillerListContainer.dart';
import 'package:flutter/material.dart';

class BillerList extends StatefulWidget {
  const BillerList({super.key});

  @override
  State<BillerList> createState() => _BillerListState();
}

class _BillerListState extends State<BillerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'Category  Name',
          onLeadingTap: () => Navigator.pop(context),
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
          BillerListContainer()
        ]));
  }
}
