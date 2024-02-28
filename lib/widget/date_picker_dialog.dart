import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';

class DateDialog extends StatefulWidget {
  final Function(String) onDateSelected;
  String? defaultDate;

  DateDialog({super.key, required this.onDateSelected, this.defaultDate});

  @override
  _DateDialogState createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  late String selectedDate;

  @override
  void initState() {
    selectedDate = widget.defaultDate.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: TXT_CLR_PRIMARY,
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Select Date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = '${index + 1}';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedDate == '${index + 1}'
                          ? TXT_CLR_PRIMARY
                          : Color(0xffD1D9E8).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(200.0),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: selectedDate == '${index + 1}'
                              ? Colors.white
                              : TXT_CLR_PRIMARY,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 10.0,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1b438b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    widget.onDateSelected(selectedDate);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1b438b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
