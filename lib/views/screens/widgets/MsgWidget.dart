import 'package:flutter/material.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';

class MsgWidget extends StatelessWidget {
  final String msg;
  const MsgWidget({
    Key? key,
    required this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        msg,
        style: appTextTheme.giloryRegular12lightGrey,
      ),
    );
  }
}
