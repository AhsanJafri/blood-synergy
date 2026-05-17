import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class DropdownDay extends StatefulWidget {
  final void Function(String) selectedValue;
  String dropdownValue;
  String month;

  DropdownDay({
    Key? key,
    required this.selectedValue,
    this.dropdownValue = '',
    this.month = '',
  }) : super(key: key);

  @override
  _DropdownDayState createState() => _DropdownDayState();
}

class _DropdownDayState extends State<DropdownDay> {
  List<String> days = [];
  List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
  }

  int parseMonth(String monthAbbreviation) {
    switch (monthAbbreviation.toLowerCase()) {
      case 'jan':
        return 1;
      case 'feb':
        return 2;
      case 'mar':
        return 3;
      case 'apr':
        return 4;
      case 'may':
        return 5;
      case 'jun':
        return 6;
      case 'jul':
        return 7;
      case 'aug':
        return 8;
      case 'sep':
        return 9;
      case 'oct':
        return 10;
      case 'nov':
        return 11;
      case 'dec':
        return 12;
      default:
        return DateTime.now().month; // Use the current month if not recognized
    }
  }

  void generateDaysForMonth() {
    // Clear existing days
    days.clear();

    if (widget.month.isNotEmpty) {
      // Get the current year and month
      int currentYear = DateTime.now().year;
      int currentMonth = DateTime.now().month;

      // Parse the selected month abbreviation to its corresponding integer value
      int selectedMonth = parseMonth(widget.month);

      // Check if the selected month is in the future, otherwise use the current month
      if (selectedMonth < currentMonth) {
        currentYear++; // If the selected month is in the past, use the next year
      }

      // Get the last day of the selected month
      int lastDay = DateTime(currentYear, selectedMonth + 1, 0).day;

      // Generate days
      for (int i = 1; i <= lastDay; i++) {
        days.add(i.toString());
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    generateDaysForMonth();

    return Container(
      child: DropdownButton<String>(
        isExpanded: true,
        menuMaxHeight: 150,
        icon: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 15).r,
            child: Image.asset(
              'assets/images/dropdown_triangle.png',
              height: 4.h,
              width: 8.w,
              color: Colors.black,
            ),
          ),
        ),
        elevation: 16,
        underline: const SizedBox(
          height: 0,
          width: 0,
        ),
        style: appTextTheme.giloryMedium14BlackTheme,
        hint: Padding(
          padding: const EdgeInsets.only(left: 10.0).r,
          child: Text(
            widget.dropdownValue.isNotEmpty ? widget.dropdownValue : 'Day',
            style: widget.dropdownValue.isNotEmpty
                ? appTextTheme.giloryMedium14BlackTheme
                : appTextTheme.giloryMedium14BlackTheme,
          ),
        ),
        onChanged: widget.month.isNotEmpty
            ? (String? value) {
                setState(() {
                  widget.dropdownValue = value!;
                  widget.selectedValue(value);
                });
              }
            : null,
        onTap: widget.month.isNotEmpty
            ? () {} // Do nothing when tapped
            : null,
        items: days.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            onTap: widget.month.isNotEmpty
                ? () {
                    setState(() {
                      widget.dropdownValue = value;
                      widget.selectedValue(value);
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0).r,
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
