import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppNetworkImage.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import '../../../Cubits/DashboardCubit/dashboard_cubit.dart';

class MenuItem {
  final String title;
  final int tag;

  MenuItem({required this.title, required this.tag});
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<MenuItem> menuItems = [
    MenuItem(title: 'Edit Profile', tag: 1),
    MenuItem(title: 'Push Notification', tag: 2),
    MenuItem(title: 'Frequently Asked Questions', tag: 3),
    MenuItem(title: 'Change Password', tag: 4),
    MenuItem(title: 'Terms and Conditions', tag: 5),
    MenuItem(title: 'Privacy Policy', tag: 6),
    MenuItem(title: 'Delete account', tag: 7),
  ];

  void handleMenuAction(MenuItem item) {
    switch (item.tag) {
      case 1:
        print('Action for: ${item.title}');
        // TODO: Navigate to edit profile screen
        AppNavigator.navigateToEditProfile(context, (_){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
 
        });
        break;
      case 2:
        print('Action for: ${item.title}');
        break;
      case 3:
        print('Action for: ${item.title}');
         AppNavigator.navigateToFAQs(context);
        //Constants.launchURL('https://bloodsynergybackend.trangotech.dev/faqs');

        break;
      case 4:
        print('Action for: ${item.title}');
        // AppNavigator.navigateToChangePassword(context, shouldReplace: false);
        AppNavigator.navigateToChangePassword( context,shouldReplace: false);
        break;
      case 5:
        print('Action for: ${item.title}');
        // AppNavigator.navigateToTermsCondition(context);
        AppNavigator.navigateToTermsCondition( context);

        break;
      case 6:
        print('Action for: ${item.title}');
        // Constants.launchURL(
        //     'https://bloodsynergybackend.trangotech.dev/privacy-policy');
                    AppNavigator.navigateToPrivacyPolicy( context);


        break;
      case 7:
        print('Action for: ${item.title}');
        _showDeleteAccountConfirmation();
        break;
      // Add more cases as needed
      default:
        print('Unknown action for: ${item.title}');
    }
  }

  Future<void> _performLogout() async {
    EasyLoading.show();
    final _response =
        await AuthenticationRepository(NetworkClient(Client(), dio: Dio()))
            .logout();
    EasyLoading.dismiss();

    if (_response is RespSuccessState) {
      AppNavigator.navigateToLogin(context);
    } else {
      AppLoader.showSnackbar(context, 'An Error Occured!', false);
    }
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: appTextTheme.gilorySemiBold16Black.copyWith(fontSize: 18),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
            style: appTextTheme.giloryMedium14BlackTheme,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: appTextTheme.gilorySemiBold16Black.copyWith(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performDeleteAccount();
              },
              child: Text(
                'Delete',
                style: appTextTheme.gilorySemiBold16Black.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeleteAccount() async {
    EasyLoading.show(status: 'Deleting account...');
    try {
      final _response =
          await AuthenticationRepository(NetworkClient(Client(), dio: Dio()))
              .deleteAccount();
      EasyLoading.dismiss();

      if (_response is RespSuccessState) {
        // Show success message
        AppLoader.showSnackbar(context, 'Account deleted successfully', true);
        // Navigate to login screen after a short delay
        Future.delayed(Duration(seconds: 1), () {
          AppNavigator.navigateToLogin(context);
        });
      } else {
        AppLoader.showSnackbar(context, 'Failed to delete account', false);
      }
    } catch (error) {
      EasyLoading.dismiss();
      AppLoader.showSnackbar(context, 'An error occurred while deleting account', false);
    }
  }

  Future<void> updateNotificationStatus(int status) async {
    try {
      // Update the user's notification status locally
      final currentUser = AppStateManagerState.shared.UserData!;
      
      // Create a new Settings object with updated pushNotification value
      final updatedSettings = Settings(
        pushNotification: status,
      );
      
      // Create a new CurrentUser object with updated settings
      final updatedUser = CurrentUser(
        id: currentUser.id,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        email: currentUser.email,
        phone: currentUser.phone,
        image: currentUser.image,
        gender: currentUser.gender,
        age: currentUser.age,
        month: currentUser.month,
        day: currentUser.day,
        year: currentUser.year,
        medicalHistory: currentUser.medicalHistory,
        fcmToken: currentUser.fcmToken,
        stripeToken: currentUser.stripeToken,
        deviceId: currentUser.deviceId,
        deviceType: currentUser.deviceType,
        isVerify: currentUser.isVerify,
        isActive: currentUser.isActive,
        createdAt: currentUser.createdAt,
        updatedAt: currentUser.updatedAt,
        deletedAt: currentUser.deletedAt,
        settings: updatedSettings,
      );
      
      // Update AppStateManager
      AppStateManagerState.shared.UserData = updatedUser;
      
      // Persist updated user data to preferences
      final userJson = jsonEncode(updatedUser.toJson());
      UserPref.persistUserData(userJson);
      
      // Update DashboardCubit user reference
      context.read<DashboardCubit>().user = updatedUser;
      AppLoader.showSnackbar(context, 'Notification settings updated', true);
      
      print('Notification status updated successfully to: $status');
      
 
      
    } catch (error) {
      print('Error updating notification status: $error');
      AppLoader.showSnackbar(context, 'Failed to update notification settings', false);
    }
  }

  @override
  Widget build(BuildContext context) {
         context.read<DashboardCubit>().user = AppStateManagerState.shared.UserData!;

    var user = context.read<DashboardCubit>().user;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Profile'),
      //   centerTitle: true,
      // ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              // Profile Image, Name, and Email
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: (user.image == null ||
                              (user.image?.isEmpty == true))
                          ? Image.asset('assets/images/profilePlaceHolder.jpg')
                          : AppNetworkImage(
                              path: user.image,
                              isCircular: true,
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${(user.firstName ?? 'John') + " " + (user.lastName ?? 'Doe')}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email ?? 'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 10),

              // List of items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          menuItems[index].title,
                          style: appTextTheme.giloryBold12Black
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        // leading: const Icon(Icons.person),
                        trailing: index == 1
                            ? Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  thumbColor:
                                      const Color.fromRGBO(207, 27, 33, 1),
                                  trackColor:
                                      Color.fromARGB(255, 188, 188, 188),
                                  activeColor:
                                      const Color.fromARGB(255, 255, 188, 188),
                                  onChanged: (bool value) {
                                    context
                                        .read<DashboardCubit>()
                                        .toggleNotification();
                                    Future.delayed(Duration(seconds: 2));
                                    setState(() {});

                                    updateNotificationStatus(
                                        value == true ? 1 : 0);
                                  },
                                  value: (user.settings?.pushNotification) == 0
                                      ? false
                                      : true,
                                ),
                              )
                            : null,
                        onTap: () {
                          // Handle item tap
                          handleMenuAction(menuItems[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Logout Button
              GestureDetector(
                onTap: () {
                  _performLogout();
                },
                child: Container(
                  width: double.infinity,
                  // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  height: 45,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20),
                      child: Text(
                        'Logout',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
