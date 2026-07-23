import 'package:blood_synergy_app/Cubits/DashboardCubit/dashboard_cubit.dart';
import 'package:blood_synergy_app/Cubits/reports_bloc/reports_bloc.dart';
import 'package:blood_synergy_app/Cubits/home_cubit/home_cubit.dart';
import 'package:blood_synergy_app/Cubits/login_cubit/login_cubit.dart';
import 'package:blood_synergy_app/Cubits/profile_cubit/profile_cubit.dart';
import 'package:blood_synergy_app/Cubits/signup_cubit/signup_cubit.dart';
import 'package:blood_synergy_app/Models/Catergories.dart';
import 'package:blood_synergy_app/Models/RecommendationsModel.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/Repositories/ProfileRepository.dart';
import 'package:blood_synergy_app/Repositories/ReportsRepository.dart';

import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/views/Recommendation/RecommendationScreen.dart';
import 'package:blood_synergy_app/views/chatbot/chatbot_screen.dart';
import 'package:blood_synergy_app/views/home/Dashboard.dart';
import 'package:blood_synergy_app/views/home/homeScreen.dart';
import 'package:blood_synergy_app/views/lipidForm/lipidTestForm.dart';
import 'package:blood_synergy_app/views/lipidPanel/lipidPanel.dart';
import 'package:blood_synergy_app/views/lipidTestReport/lipidTestReport.dart';
import 'package:blood_synergy_app/views/profileSetup/profileSetupScreen.dart';
import 'package:blood_synergy_app/views/editProfile/editProfileScreen.dart';
import 'package:blood_synergy_app/views/screens/Password/ChangePassword.dart';
import 'package:blood_synergy_app/views/screens/Password/ForgotPassword.dart';
import 'package:blood_synergy_app/views/screens/Password/SetNewPassword.dart';
import 'package:blood_synergy_app/views/screens/PrivacyPolicyScreen.dart';
import 'package:blood_synergy_app/views/screens/TermsCondition.dart';
import 'package:blood_synergy_app/views/screens/disclaimer/disclaimer_screen.dart';
import 'package:blood_synergy_app/views/screens/doc_detail_screen.dart';
import 'package:blood_synergy_app/views/screens/faqs_screen.dart';
import 'package:blood_synergy_app/views/screens/loginn/loginScreen.dart';
import 'package:blood_synergy_app/views/screens/otpVerification/otpVerification.dart';
import 'package:blood_synergy_app/views/screens/signup/signup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' show Client;

class AppNavigator {
  static void navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => LoginCubit(AuthenticationRepository(
                    NetworkClient(Client(), dio: NetworkClient.createConfiguredDio()))),
                child: loginScreen(),
              )),
      (route) => false,
    );
  }
// static void navigateToLogin(BuildContext context) {
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(
//       builder: (context) => BlocProvider<LoginCubit>(
//         create: (context) => LoginCubit(
//           AuthenticationRepository(
//             NetworkClient(Client(), dio: Dio()),
//           ),
//         ),
//         child: loginScreen(),
//       ),
//     ),
//     (route) => false,
//   );
// }

  static void navigateToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SignupCubit(AuthenticationRepository(
                    NetworkClient(Client(), dio: NetworkClient.createConfiguredDio()))),
                child: signUpScreen(),
              )),
    );
  }

  static void navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
    );
  }

  static void navigateToFAQs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FaqsScreen()),
    );
  }

  static void navigateToTermsCondition(BuildContext context,
      {bool fromSignup = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Termscondition(fromSignup: fromSignup)),
    );
  }
  static void navigateToDocDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DocDetailScreen()),
    );
  }

  static void navigateToOTP(
      BuildContext context, String phone, bool forgotPassword,
      {SignupCubit? signupCubit}) {
    if (signupCubit == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignupCubit(
                AuthenticationRepository(NetworkClient(
                    Client(), dio: NetworkClient.createConfiguredDio()))),
            child: otpVerificationScreen(phone, forgotPassword),
          ),
        ),
      );
    } else {
      // Use push instead of pushAndRemoveUntil to keep cubit alive
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: signupCubit,
            child: otpVerificationScreen(phone, forgotPassword),
          ),
        ),
      );
    }
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ProfileCubit(
                    ProfileRepository(NetworkClient(Client(), dio: Dio()))),
                child: ProfileSetupScreen(),
              )),
      (route) => false,
    );
  }

  static void navigateToSetNewPassword(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SetPasswordScreen()),
    );
  }

  static void navigateToRecommendations(
      BuildContext context, List<RecommendationsModel>? model) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RecommendationScreen(model)),
    );
  }

  static void navigateToChangePassword(BuildContext context,
      {bool shouldReplace = true}) {
    if (shouldReplace) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
      );
    }
  }
    static void navigateToChatBot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatbotScreen()),
    );
  }

  static void navigateToForgotPassword(
      BuildContext context, LoginCubit loginCubit) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: loginCubit,
          child: ForgotPasswordScreen(),
        ),
      ),
      (route) => true,
    );
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => HomeCubit(
                    HomeRepository(NetworkClient(Client(), dio: Dio()))),
                child: HomeScreen(),
              )),
      (route) => false,
    );
  }

  static void navigateToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DashboardCubit(),
                child: Dashboard(),
              )),
      (route) => false,
    );
  }
    static void navigateToDisclaimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DisclaimerScreen()),
     );
  }

  static void navigateToLipidPanel(
      BuildContext context, Categories categoryID) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ReportsBloc(
                    ReportsRepository(NetworkClient(Client(), dio: Dio()))),
                child: LipidPanelScreen(
                  category: categoryID,
                ),
              )),
    ).then((value) => {});
  }

  static void navigateToCreateForm(
      BuildContext context, Categories category, ReportsBloc bloc) {
    bloc.add(
        ResetBloc(ReportsBlocScreens.createFormScreen, ReportsStatus.initial));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: bloc,
                child: LipidTestFormScreen(
                  categorie: category,
                  bloc: bloc,
                ),
              )),
    ).then((value) => {
          print('going back'),
          bloc.add(ResetBloc(
              ReportsBlocScreens.reportListScreen, ReportsStatus.success)),
        });
  }

  static void navigateToShowReport(BuildContext context, ReportsBloc bloc,
      int categoryID, int reportID, String reportName) {
    bloc.add(ResetBloc(
        ReportsBlocScreens.reportDetailscreen, ReportsStatus.initial));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: bloc,
                child: LipidTestReportScreen(
                  bloc: bloc,
                  reportID: reportID,
                  reportName: reportName,
                  categoryID: categoryID,
                ),
              )),
    ).then((value) => {
          print('going back'),
          bloc.add(ResetBloc(
              ReportsBlocScreens.reportListScreen, ReportsStatus.success)),
        });
  }

  static void navigateToEditProfile(BuildContext context, Function(dynamic) onValue) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ProfileCubit(
                    ProfileRepository(NetworkClient(Client(), dio: Dio()))),
                child: const EditProfileScreen(),
              )),
    ).then((result) {
      print('Returned from Edit Profile Screen with value: $result');
      if (result != null) {
        onValue(result);
      }
    });
  }

  // Add more static methods for other navigations as needed
}
