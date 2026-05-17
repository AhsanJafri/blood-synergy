import 'dart:io';

import 'package:blood_synergy_app/Cubits/profile_cubit/profile_cubit.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppNetworkImage.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/app_ImagePicker.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/helpers/dropdownGender.dart';
import 'package:blood_synergy_app/helpers/dropdownYear.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  CurrentUser user = AppStateManagerState.shared.UserData!;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  bool isChanged = false;
  @override
  void initState() {
    super.initState();
    _ageController.text = user.age ?? '';
    _medicalHistoryController.text = user.medicalHistory ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileCubit, ProfileScreenState>(
          listener: (context, state) {
            if (state is GetProfileState) {
              EasyLoading.dismiss();
              if (state.profileResult is LoadingState) {
                EasyLoading.show(
                    status: ((state.profileResult as LoadingState).msg));
              } else if (state.profileResult is RespSuccessAndNavigateState) {
                AppNavigator.navigateToDisclaimer(context);
                print(state);
              } else if (state.profileResult is RespErrorState) {
                // Handle error state, e.g., show an error message
                AppLoader.showSnackbar(
                    context,
                    (state.profileResult as RespErrorState)
                            .failure
                            ?.errorMessage ??
                        '',
                    false);
              }
            }
          },
          builder: (context, state) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 35, right: 35).r,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Profile Set up',
                        style: appTextTheme.giloryBold22Black,
                      ),
                    ),
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        height: 100.h,
                        width: 100.h,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: (user.imagePath != null &&
                                  (user.imagePath?.isNotEmpty ?? false))
                              ? Image.file(
                                  File(user.imagePath ?? ''),
                                  fit: BoxFit.cover,
                                )
                              : AppNetworkImage(
                                path: user.image,
                                  isCircular: true,
                                   
                                ),
                        ),
                      ),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          // Container(
                          //   color: Colors.amber,
                          //   width: MediaQuery.of(context).size.width * 0.6,
                          //   // color: Colors.amber,
                          //   child: Text(
                          //     '${user.firstName ?? ''} ${user.lastName ?? ' '}',
                          //     style: appTextTheme.giloryBold22Black,
                          //     maxLines: 2,
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                          Text(
                            user.email ?? '',
                            style: appTextTheme.giloryRegular12lightGrey,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext childContext) {
                                    return AlertDialog(
                                      title: const Text('Pick a Image'),
                                      content: const Text(
                                          'Pick a image for the profile picture'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            AppImagePicker.pick(
                                                    AppImageSource.gallery)
                                                .then((value) {
                                              print(value);
                                              if (value == null) {
                                                Navigator.pop(childContext);
                                                //do nothing
                                              } else {
                                                isChanged = true;
                                                Navigator.pop(childContext);

                                                setState(() {
                                                  user.imagePath = value.path;
                                                });
                                              }
                                            }).onError((error, stackTrace) {
                                              print(error);
                                              Navigator.pop(childContext);
                                            });
                                          },
                                          child: const Text('Gallery'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            AppImagePicker.pick(
                                                    AppImageSource.camera)
                                                .then((value) {
                                              if (value == null) {
                                                Navigator.pop(childContext);
                                                //do nothing
                                              } else {
                                                isChanged = true;
                                                Navigator.pop(childContext);
                                                if (mounted) {
                                                  user.imagePath = value.path;
                                                  setState(() {});
                                                }
                                              }
                                            }).onError((error, stackTrace) {
                                              print(error);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text('Camera'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              width: 116.w,
                              height: 28.h,
                              margin: const EdgeInsets.only(top: 8).r,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(92, 174, 65, 1),
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(18).w),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Upload Photo',
                                  style: appTextTheme.gilorySemiBold12White,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 30).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: appTextTheme.giloryBold22Black,
                        ),
                        Text(
                          'Please enter your personal details',
                          style: appTextTheme.giloryRegular12lightGrey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150.w,
                              height: 51.h,
                              margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 20)
                                  .r,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(243, 243, 243, 1),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(12.0).w,
                                ),
                              ),
                              child: DropdownGender(
                                dropdownValue: user.gender ?? '',
                                selectedValue: (p0) {
                                  isChanged = true;
                                  user.gender = p0;
                                },
                              ),
                            ),
                            Container(
                              width: 150.w,
                              height: 51.h,
                              margin: const EdgeInsets.only(
                                      left: 0, right: 15, top: 20)
                                  .r,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(243, 243, 243, 1),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(10.0).w,
                                ),
                              ),
                              child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2)
                                  ],
                                  // controller: _lastNameController,
                                  decoration: InputDecoration(
                                    // labelText: 'Yards',
                                    floatingLabelStyle: const TextStyle(
                                      color: Color.fromRGBO(92, 174, 65, 1),
                                    ),

                                    hintText: 'Enter Your Age',
                                    hintStyle:
                                        appTextTheme.giloryMedium14lightGrey,

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(92, 174, 65, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    user.age = value;
                                    isChanged = true;
                                  }),
                            ),
                          ],
                        ),
                        // Row(
                        //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     // Container(
                        //     //   width: 105.w,
                        //     //   height: 51.h,
                        //     //   margin: const EdgeInsets.only(
                        //     //           left: 0, right: 0, top: 10)
                        //     //       .r,
                        //     //   decoration: BoxDecoration(
                        //     //     color: const Color.fromRGBO(243, 243, 243, 1),
                        //     //     borderRadius: BorderRadius.all(
                        //     //       const Radius.circular(12.0).w,
                        //     //     ),
                        //     //     // boxShadow: [
                        //     //     //   BoxShadow(
                        //     //     //     color: Color.fromRGBO(243, 243, 243, 1),
                        //     //     //     offset: const Offset(
                        //     //     //       1.0,
                        //     //     //       1.0,
                        //     //     //     ),
                        //     //     //     blurRadius: 1.0,
                        //     //     //     spreadRadius: 1.0,
                        //     //     //   ), //BoxShadow

                        //     //     //   //BoxShadow
                        //     //     // ]
                        //     //   ),
                        //     //   child: DropdownMonth(
                        //     //     dropdownValue: user.month ?? '',
                        //     //     selectedValue: (p0) {
                        //     //       user.month = p0;
                        //     //       isChanged = true;
                        //     //       setState(() {});
                        //     //     },
                        //     //   ),
                        //     // ),
                        //     // Container(
                        //     //   width: 105.w,
                        //     //   height: 50.h,
                        //     //   margin: const EdgeInsets.only(
                        //     //           left: 0, right: 0, top: 10)
                        //     //       .r,
                        //     //   decoration: BoxDecoration(
                        //     //     color: const Color.fromRGBO(243, 243, 243, 1),
                        //     //     borderRadius: BorderRadius.all(
                        //     //       const Radius.circular(12.0).w,
                        //     //     ),
                        //     //   ),
                        //     //   child: DropdownDay(
                        //     //     dropdownValue: user.day ?? '',
                        //     //     month: user.month ?? '',
                        //     //     selectedValue: (p0) {
                        //     //       isChanged = true;
                        //     //       user.day = p0;
                        //     //     },
                        //     //   ),
                        //     // ),
                        //     Expanded(
                        //       child: Container(
                        //         width: 105.w,
                        //         height: 51.h,
                        //         margin: const EdgeInsets.only(
                        //                 left: 0, right: 15, top: 10)
                        //             .r,
                        //         decoration: BoxDecoration(
                        //           color: const Color.fromRGBO(243, 243, 243, 1),
                        //           borderRadius: BorderRadius.all(
                        //             const Radius.circular(12.0).w,
                        //           ),
                        //         ),
                        //         child: DropdownYear(
                        //           dropdownValue: user.year ?? '',
                        //           selectedValue: (p0) {
                        //             user.year = p0;
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Container(
                        //   width: 345.w,
                        //   height: 51.h,
                        //   margin:
                        //       const EdgeInsets.only(left: 0, right: 15, top: 10)
                        //           .r,
                        //   decoration: BoxDecoration(
                        //     color: const Color.fromRGBO(243, 243, 243, 1),
                        //     borderRadius: BorderRadius.all(
                        //       const Radius.circular(10.0).w,
                        //     ),
                        //   ),
                        //   child: TextField(
                        //       textCapitalization: TextCapitalization.words,
                        //       keyboardType: TextInputType.text,
                        //       controller: _medicalHistoryController,
                        //       // controller: _lastNameController,
                        //       decoration: InputDecoration(
                        //         // labelText: 'Yards',
                        //         floatingLabelStyle: const TextStyle(
                        //           color: Color.fromRGBO(92, 174, 65, 1),
                        //         ),
                        //         hintText: 'Any Medical History',
                        //         hintStyle: appTextTheme.giloryMedium14lightGrey,

                        //         enabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(20),
                        //           borderSide: const BorderSide(
                        //             color: Colors.transparent,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //           borderSide: const BorderSide(
                        //             color: Color.fromRGBO(92, 174, 65, 1),
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //       ),
                        //       onChanged: (value) {
                        //         user.medicalHistory = value;
                        //         isChanged = true;
                        //       }),
                        // ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (isChanged) {
                          BlocProvider.of<ProfileCubit>(context)
                              .verifyAndUpdateProfile(user);
                        }
                      },
                      child: Container(
                        width: 345.w,
                        height: 50.h,
                        margin: const EdgeInsets.only(
                                top: 30, left: 15, right: 15, bottom: 20)
                            .r,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(92, 174, 65, 1),
                          borderRadius:
                              BorderRadius.all(const Radius.circular(18).w),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Continue',
                            style: appTextTheme.gilorySemiBold16White,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]);
          },
        ),
      ),
    );
  }

  void shouldClearAllTextFields() {}
}
