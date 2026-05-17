import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class DropdownMonth extends StatefulWidget {
  String dropdownValue;
  final void Function(String) selectedValue;
  final bool showDisabled;

  DropdownMonth({
    Key? key,
    this.dropdownValue = '',
    required this.selectedValue,
    this.showDisabled = false,
  }) : super(key: key);

  @override
  _DropdownMonthState createState() => _DropdownMonthState();
}

class _DropdownMonthState extends State<DropdownMonth> {
  List<String> list = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        menuMaxHeight: 150,
        isExpanded: true,
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
            widget.dropdownValue.isNotEmpty ? widget.dropdownValue : 'Month',
            style: widget.dropdownValue.isNotEmpty
                ? appTextTheme.giloryMedium14BlackTheme
                : appTextTheme.giloryMedium14BlackTheme,
          ),
        ),
        onChanged: widget.showDisabled
            ? null
            : (String? value) {
                setState(() {
                  widget.dropdownValue = value!;
                });
              },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            onTap: widget.showDisabled
                ? null
                : () {
                    setState(() {
                      widget.dropdownValue = value;
                      widget.selectedValue(list[list.indexOf(value)]);
                    });
                  },
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
