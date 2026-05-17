import 'package:blood_synergy_app/Cubits/home_cubit/home_cubit.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppNetworkImage.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final CurrentUser user = AppStateManagerState.shared.UserData!;

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                height: ((user.firstName?.length ?? 0) +
                            (user.lastName?.length ?? 0)) >
                        15
                    ? 120.h
                    : 120.h,
                width: 375.w,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Color.fromRGBO(207, 27, 33, 1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, top: 50).r,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            height: 60.h,
                            width: 60.h,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: (user.image == null ||
                                    (user.image?.isEmpty == true))
                                ? Image.asset(
                                    'assets/images/profilePlaceHolder.jpg')
                                : AppNetworkImage(
                                    path: user.image,
                                    isCircular: true,
                                  ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10).r,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome,',
                                    style: appTextTheme.giloryRegular14White,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                            top: 0, bottom: 8.0, right: 8.0)
                                        .r,
                                    child: Text(
                                      '${user.firstName} ${user.lastName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: appTextTheme.giloryBold22White
                                          .copyWith(height: 1.1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     bottom: 15.h,
                      //   ),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: const Color.fromRGBO(243, 243, 243, 1),
                      //       borderRadius: BorderRadius.all(
                      //         const Radius.circular(12.0).w,
                      //       ),
                      //     ),
                      //     height: 50.h,
                      //     child: TextField(
                      //       //  controller: _passwordController,
                      //       // textAlign: TextAlign.center,
                      //       inputFormatters: [
                      //         LengthLimitingTextInputFormatter(40)
                      //       ],
                      //       maxLines: 1,
                      //       textAlignVertical: TextAlignVertical.center,
                      //       decoration: InputDecoration(
                      //         hintText: 'Search your Report',
                      //         isDense: true,

                      //         //    filled: true,
                      //         //  fillColor: Colors.white,
                      //         hintStyle: appTextTheme.giloryMedium14lightGrey,
                      //         prefixIcon: Padding(
                      //           padding: EdgeInsetsDirectional.only(
                      //               start: 15.0.r,
                      //               top: 10.r,
                      //               end: 15.r,
                      //               bottom: 10.r),
                      //           child: Image.asset(
                      //             'assets/images/searchImg.png',
                      //             height: 16.h,
                      //             width: 16.w,
                      //           ),
                      //         ),
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(20).w,
                      //           borderSide: BorderSide(
                      //             color: Colors.transparent,
                      //             width: 1.0.w,
                      //           ),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10).w,
                      //           borderSide: BorderSide(
                      //             color: Colors.transparent,
                      //             // color:Color.fromRGBO(73, 162, 237, 1),
                      //             width: 1.0.w,
                      //           ),
                      //         ),
                      //       ),

                      //       // onChanged: (value) => context.read<LoginBloc>().add(
                      //       //   LoginPasswordChanged(password: value)
                      //       // ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ]),
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
              child: GestureDetector(
                  onTap: () {
                    Constants.launchURL('https://www.drtaylorseminars.com');
                  },
                  child: Text(
                    'For more educational content',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: const Color.fromARGB(255, 10, 41, 214),
                        decorationColor:
                            const Color.fromARGB(255, 10, 41, 214)),
                  )),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: GestureDetector(
                  onTap: () {
                    // Constants.launchURL('www.drtaylorseminars.com');
                  },
                  child: Text(
                    'Always consult a doctor for personalized health advice',
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 11.sp),
                  )),
            ),
            SizedBox(
              height: 20.h,
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
