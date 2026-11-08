import 'package:blood_synergy_app/Cubits/home_cubit/home_cubit.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppNetworkImage.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/widgets/app_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final CurrentUser user = AppStateManagerState.shared.UserData!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        AppTabHeader(
          title: '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim().isEmpty
              ? 'Welcome'
              : '${user.firstName} ${user.lastName}',
          subtitle:
              'Track lab markers and explore educational wellness patterns.',
          leading: Container(
            clipBehavior: Clip.hardEdge,
            height: 40.h,
            width: 40.h,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: (user.image == null || (user.image?.isEmpty == true))
                ? Image.asset('assets/images/profilePlaceHolder.jpg')
                : AppNetworkImage(
                    path: user.image,
                    isCircular: true,
                  ),
          ),
        ),
        Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text( 
                'Click the chatbot icon below to upload or manually input your lab results. Information provided is for educational and research purposes only and is not medical advice',           
                style: appTextTheme.giloryRegular13lightGrey,
                textAlign: TextAlign.center,
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                print("${state.runtimeType} Home here");
                EasyLoading.dismiss();
                var cubit = BlocProvider.of<HomeCubit>(context);
                if (state is HomeInitial) {
                  EasyLoading.show(status: 'Loading Data');
                  cubit.getCategories();
                  //  print("you can call api");
                }
                if (state is HomeScreenStates) {
                  var resultState = state.result as AppResultState;
                  if (resultState is LoadingState) {
                    return const Center(
                      child: Text("This is loading"),
                    );
                  } else if (resultState is RespErrorState) {
                    if ((resultState.failure?.errorMessage ?? '') ==
                        "Unauthenticated") {
                      AppNavigator.navigateToLogin(context);
                    }
                    return Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Text(
                          resultState.failure?.errorMessage ?? '',
                          style: appTextTheme.giloryMedium12lightGrey,
                        ),
                      ),
                    );
                  } else if (resultState is RespSuccessState) {
                    // Data loaded successfully, proceed to show grid
                    return Expanded(child: _gridView(context, cubit));
                  }
                }
                // Default case - show grid view (this covers initial load and other states)
                return Expanded(child: _gridView(context, cubit));
              },
            ),
        Center(
          child: Text(
            'Always consult a doctor for personalized health advice',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11.sp),
          ),
            ),
            SizedBox(
          height: 12.h,
            )
          ]),
    );
  }

  Widget _gridView(BuildContext context, HomeCubit homeCubit) {
    // Check if categories list is empty before accessing .first
    var categories = homeCubit.cats.isNotEmpty ? [homeCubit.cats.first] : [];

    // If no categories, show an empty state
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No categories available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // If there is exactly one item, center it on the screen
    if (categories.length == 1) {
      return Center(
        child: _buildChatbotTile(context),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding:
          const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10).r,
      crossAxisSpacing: 15.w,
      mainAxisSpacing: 15.w,
      childAspectRatio: 9.w / 8.w,
      children: List.generate((1), (index) {
        // var item = categories[index];

        return _buildChatbotTile(context);
      }),
    );
  }

  Widget _buildChatbotTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0).r,
      child: InkWell(
        onTap: () {
          AppNavigator.navigateToChatBot(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(243, 243, 243, 1),
            borderRadius: BorderRadius.all(const Radius.circular(22).w),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                   padding: const EdgeInsets.only(
                          bottom: 12, left: 8, right: 8)
                      .r,
                  child: Text(
                    'Click',
                    style: appTextTheme.giloryBold16Black,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(const Radius.circular(30).w),
                  ),
                  child: Image.asset(
                    'assets/images/chatbot.png',
                    height: 55.h,
                    width: 55.w,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                          top: 15, left: 8, right: 8, bottom: 0)
                      .r,
                  child: Text(
                    'Chatbot',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: appTextTheme.giloryBold12Black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
