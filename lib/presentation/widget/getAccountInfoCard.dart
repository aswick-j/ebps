import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountInfoCard extends StatelessWidget {
  String accountNumber;
  String balance;
  int? isSelected;
  int index;
  Function onAccSelected;

  AccountInfoCard({
    required this.accountNumber,
    required this.onAccSelected,
    required this.balance,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("======");
        onAccSelected(index);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected == index ? Colors.green : Color(0xffD1D9E8),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 0, 0),
              child: Text(
                accountNumber,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: isSelected == index ? Colors.green : Color(0xff808080),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 0, 0),
              child: Text(
                "Balance Amount",
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff808080),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
              child: Text(
                balance != "Unable to fetch balance"
                    ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(balance))}"
                    : "-",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff0e2146),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
