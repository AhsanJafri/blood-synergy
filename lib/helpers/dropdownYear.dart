import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class DropdownYear extends StatefulWidget {
  final void Function(String) selectedValue;
  String dropdownValue;
  DropdownYear({
    Key? key,
    this.dropdownValue = '',
    required this.selectedValue,
  }) : super(key: key);
  // final TextEditingController? myController;

  @override
  _DropdownYearState createState() => _DropdownYearState();
}

class _DropdownYearState extends State<DropdownYear> {
  List<String> list = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int currentYear = DateTime.now().year;

    // Generate a list of years from 1950 to the current year
    list = List.generate(currentYear - 1949, (index) {
      return (currentYear - index).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        menuMaxHeight: 150.h,
        isExpanded: true,
        icon: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 15).r,
            child: Image.asset('assets/images/dropdown_triangle.png',
                height: 4.h, width: 8.w, color: Colors.black),
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
            widget.dropdownValue != '' ? widget.dropdownValue : 'Birth Year',
            style: widget.dropdownValue != ''
                ? appTextTheme.giloryMedium14BlackTheme
                : appTextTheme.giloryMedium14BlackTheme,
          ),
        ),
        onChanged: (String? value) {
          setState(() {
            widget.dropdownValue = list[list.indexOf(value!)];
            // widget.selectedValue(value);
            // Constants.currentUserType = dropdownValue.toLowerCase() == "customer" ? UserType.sailor : UserType.serviceProvider;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            onTap: () {
              setState(() {
                widget.dropdownValue = list[list.indexOf(value)];
                widget.selectedValue(list[list.indexOf(value)]);

                // Constants.currentUserType = dropdownValue.toLowerCase() == "customer" ? UserType.sailor : UserType.serviceProvider;
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
