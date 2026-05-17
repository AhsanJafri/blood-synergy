import 'dart:io';

import 'package:blood_synergy_app/Cubits/DashboardCubit/dashboard_cubit.dart';
import 'package:blood_synergy_app/Cubits/profile_cubit/profile_cubit.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppNetworkImage.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/app_ImagePicker.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/helpers/dropdownGender.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  CurrentUser user = AppStateManagerState.shared.UserData!;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate all fields with existing user data
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';
    _ageController.text = user.age ?? '';
    _medicalHistoryController.text = user.medicalHistory ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: appTextTheme.giloryBold22Black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileCubit, ProfileScreenState>(
          listener: (context, state) {
            if (state is GetProfileState) {
              EasyLoading.dismiss();
              if (state.profileResult is LoadingState) {
                EasyLoading.show(
                    status: ((state.profileResult as LoadingState).msg));
              } else if (state.profileResult is RespSuccessAndNavigateState) {
                AppLoader.showSnackbar(context, 'Profile updated successfully!', true);
                Navigator.of(context).pop(); // Return to previous screen
              } else if (state.profileResult is RespErrorState) {
                AppLoader.showSnackbar(
                    context,
                    (state.profileResult as RespErrorState)
                            .failure
                            ?.errorMessage ??
                        'Failed to update profile',
                    false);
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                                    Container(
                        height: 110.h,
                        width: 110.h,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
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
                      SizedBox(width: 25.w),
                      Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start, children: [
        
                      SizedBox(height: 10.h),
               Text('${user.firstName ?? ''} ${user.lastName ?? ''}',style: TextStyle(color: Colors.black,fontSize: 22.sp,fontWeight: FontWeight.bold),),
               Text('${user.email}',style: TextStyle(color: Colors.black,fontSize: 14.sp ),),
SizedBox(height: 8.h,),
                      InkWell(
                        onTap: () {
                          _showImagePickerDialog();
                        },
                        child: Container(
                          width: 110.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(92, 174, 65, 1),
                            borderRadius: BorderRadius.all(
                                const Radius.circular(16).w),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Change Photo',
                              style: appTextTheme.gilorySemiBold12White.copyWith(fontSize: 11.sp),
                            ),
                          ),
                        ),
                      ),
                      ],),
                    ],
                  ),
                  
                  SizedBox(height: 30.h),
                  
                  // Personal Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: appTextTheme.giloryBold22Black,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Update your personal details',
                          style: appTextTheme.giloryRegular12lightGrey,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // First Name and Last Name Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          hintText: 'First Name',
                          onChanged: (value) {
                            user.firstName = value;
                            isChanged = true;
                          },
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          hintText: 'Last Name',
                          onChanged: (value) {
                            user.lastName = value;
                            isChanged = true;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                   
        
                  SizedBox(height: 15.h),
                  
                  // Gender and Age Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 51.h,
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
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildTextField(
                          controller: _ageController,
                          hintText: 'Age',
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          onChanged: (value) {
                            user.age = value;
                            isChanged = true;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  // SizedBox(height: 15.h),
                  
                  // // Medical History Field
                  // _buildTextField(
                  //   controller: _medicalHistoryController,
                  //   hintText: 'Medical History',
                  //   maxLines: 3,
                  //   onChanged: (value) {
                  //     user.medicalHistory = value;
                  //     isChanged = true;
                  //   },
                  // ),
                  
                  SizedBox(height: 40.h),
                  
                  // Update Button
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(
                                  const Radius.circular(18).w),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: appTextTheme.gilorySemiBold16Black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (isChanged) {
                              BlocProvider.of<ProfileCubit>(context)
                                  .verifyAndUpdateProfile(user);
                            } else {
                              AppLoader.showSnackbar(
                                  context, 'No changes made', false);
                            }
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: isChanged 
                                  ? const Color.fromRGBO(92, 174, 65, 1)
                                  : const Color.fromRGBO(92, 174, 65, 0.5),
                              borderRadius: BorderRadius.all(
                                  const Radius.circular(18).w),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Update Profile',
                                style: appTextTheme.gilorySemiBold16White,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    bool enabled = true,
    required Function(String) onChanged,
  }) {
    return Container(
      height: maxLines > 1 ? null : 51.h,
      decoration: BoxDecoration(
        color: enabled 
            ? const Color.fromRGBO(243, 243, 243, 1)
            : const Color.fromRGBO(243, 243, 243, 0.6),
        borderRadius: BorderRadius.all(
          const Radius.circular(12.0).w,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        enabled: enabled,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: appTextTheme.giloryMedium14lightGrey,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: maxLines > 1 ? 16.h : 0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromRGBO(92, 174, 65, 1),
              width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _showImagePickerDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext childContext) {
        return AlertDialog(
          title: const Text('Change Profile Picture'),
          content: const Text('Choose how you want to update your profile picture'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                AppImagePicker.pick(AppImageSource.gallery).then((value) {
                  if (value == null) {
                    Navigator.pop(childContext);
                  } else {
                    isChanged = true;
                    Navigator.pop(childContext);
                    setState(() {
                      user.imagePath = value.path;
                    });
                  }
                }).onError((error, stackTrace) {
                  Navigator.pop(childContext);
                });
              },
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                AppImagePicker.pick(AppImageSource.camera).then((value) {
                  if (value == null) {
                    Navigator.pop(childContext);
                  } else {
                    isChanged = true;
                    Navigator.pop(childContext);
                    if (mounted) {
                      setState(() {
                        user.imagePath = value.path;
                      });
                    }
                  }
                }).onError((error, stackTrace) {
                  Navigator.pop(childContext);
                });
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(childContext);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}