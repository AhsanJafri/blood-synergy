import 'package:blood_synergy_app/helpers/utils.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppCountryInputTextField extends StatefulWidget {
  const AppCountryInputTextField({
    Key? key,
    required this.hintLabel,
    required this.imageName,
    required this.shouldObscure,
    this.imgWidth,
    this.imgHeight,
    this.isUserEnabled = true,
    this.floatingBehavior = false,
    this.textFieldFocusNode,
    this.myController,
    this.onValidator,
    this.onChangedOccured,
    this.onCountryChanged,
  }) : super(key: key);

  final String hintLabel;
  final String? imageName;
  final bool shouldObscure;
  final double? imgWidth;
  final double? imgHeight;
  final bool? isUserEnabled;
  final FocusNode? textFieldFocusNode;
  final bool floatingBehavior;
  final TextEditingController? myController;
  final void Function(String)? onChangedOccured;
  final String? Function(String?)? onValidator;
  final void Function(String)? onCountryChanged;

  @override
  _AppCountryInputTextFieldState createState() =>
      _AppCountryInputTextFieldState();
}

class _AppCountryInputTextFieldState extends State<AppCountryInputTextField> {
  var countryPhoneCode = "1"; //default us country code
  var countryCode = "US";
  var flagEmoji = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flagEmoji = Util.countryCodeToFlagEmoji(countryCode);

    widget.onCountryChanged!("+" + countryPhoneCode);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                print('Select country: ${country.displayName}');
                print('Select country: ${country.phoneCode}');
                print('Select country: ${country.flagEmoji}');
                widget.onCountryChanged!("+" + country.phoneCode);
                setState(() {
                  flagEmoji = country.flagEmoji;
                  countryPhoneCode = country.phoneCode;
                  // Constants.countryCode = country.phoneCode;
                });
              },
            );
          },
          child: Container(
            height: 50,
            width: 106,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 243, 243, 1),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 14),
                  child: Text(
                    flagEmoji, //+ " +" + countryPhoneCode,
                    style: const TextStyle(fontSize: 20),
                    //style: AhoynTheme.textfieldTextBold,
                  ),
                ),

                // Container(
                //   margin: EdgeInsets.only(left: 14),
                //    decoration: BoxDecoration(
                //                   color: Colors.red, shape: BoxShape.circle),
                //               child: ClipOval(
                //                 child: SizedBox.fromSize(
                //                     size: Size.fromRadius(15),
                //                     child:Align(
                //                       alignment: Alignment.center,
                //                       child: Text(
                //                                         flagEmoji,
                //                                         style: TextStyle(fontSize: 25),

                //                                       ),
                //                     ), // Image radius

                //                     ),
                //               ),

                // ),
                const SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/images/dropdown_triangle.png',
                  height: 6,
                  width: 10,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '+$countryPhoneCode ',
                  style: appTextTheme.giloryMedium14lightGrey,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
          color: const Color.fromRGBO(228, 228, 228, 1),
          height: 37,
          width: 1,
        ),
        Expanded(
          child: TextFormField(
            //style: AhoynTheme.textfieldTextBold,

            obscureText: widget.shouldObscure,
            keyboardType: TextInputType.phone,
            enabled: widget.isUserEnabled ?? false,
            focusNode: widget.textFieldFocusNode,
            controller: widget.myController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(12),
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
            ],
            onEditingComplete: () {
              // This callback will be triggered when editing is complete (e.g., user presses Done key)
              // You can dismiss the keyboard here
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
              errorStyle: const TextStyle(height: 0),
              border: InputBorder.none,
              labelText: widget.hintLabel,
              hintStyle: appTextTheme.giloryMedium14lightGrey,
              floatingLabelStyle: appTextTheme.giloryMedium14lightGrey,
              floatingLabelBehavior: widget.floatingBehavior == false
                  ? FloatingLabelBehavior.never
                  : FloatingLabelBehavior.never,
              labelStyle: appTextTheme.giloryMedium14lightGrey,
            ),
            validator: widget.onValidator,
            onChanged: widget.onChangedOccured,
          ),
        ),
      ],
    );
  }
}
