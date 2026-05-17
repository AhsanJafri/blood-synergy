import 'package:blood_synergy_app/Cubits/DashboardCubit/dashboard_cubit.dart';
import 'package:blood_synergy_app/Cubits/doctors_cubit/doctors_cubit.dart';
import 'package:blood_synergy_app/Cubits/supplements_cubit/supplements_cubit.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/GeneralStates.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/SupplementsModel.dart';
import '../../../helpers/AppNetworkImage.dart';
import '../../../themes/textTheme.dart';
import '../../../network_helpers/network.dart';
import 'package:http/http.dart';

class SupplementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorsCubit(HomeRepository(NetworkClient(Client(), dio: Dio()))),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(context),
            Expanded(child: _gridView(context)),
          ],
        ),
      ),
    );
  }

  Container headerWidget(BuildContext context) {
    var user = context.read<DashboardCubit>().user;
    return Container(
      height: 125.h,
      width: 375.w,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        color: Color.fromRGBO(207, 27, 33, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                                  top: 0, bottom: 8.0, right: 8.0)
                              .r,
                          child: Text(
                            'Explore Wellness Patterns',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: appTextTheme.giloryBold22White
                                .copyWith(height: 1.1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                                  top: 0, bottom: 8.0, right: 8.0)
                              .r,
                          child: Text(
                            'Explore educational resources, videos and wellness options to support your journey. Always consult a doctor for personalized advice',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: appTextTheme.giloryBold22White.copyWith(
                                height: 1.1,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal),
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
            //     bottom: 12.h,
            //   ),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: const Color.fromRGBO(243, 243, 243, 1),
            //       borderRadius: BorderRadius.all(
            //         const Radius.circular(12.0).w,
            //       ),
            //     ),
            //     height: 42.h,
            //     child: TextField(
            //       //  controller: _passwordController,
            //       // textAlign: TextAlign.center,
            //       inputFormatters: [LengthLimitingTextInputFormatter(40)],
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
            //               start: 15.0.r, top: 10.r, end: 15.r, bottom: 10.r),
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
    );
  }

  Widget _gridView(BuildContext context) {
    return BlocBuilder<SupplementsCubit, SupplementsState>(
      builder: (context, state) {
        if (state.status.isInitial) {
          context.read<SupplementsCubit>().getDoctors();
        } else if (state.status.isError) {
          return Center(
            child: Text((state as RespErrorState).failure?.errorMessage ?? ''),
          );
        } else if (state.status.isSuccess) {
          var supplements = context.read<SupplementsCubit>().supplements;

          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 8)
                    .r,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.w,
            childAspectRatio: 9.w / 7.w,
            children: List.generate((supplements.length), (index) {
              if (supplements.isEmpty) {
                return const Center(
                  child: Text('No Supplements Found!'),
                );
              }
              var item = supplements[index];
              return InkWell(
                onTap: () {},
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(243, 243, 243, 1),
                    borderRadius: BorderRadius.all(const Radius.circular(22).w),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width / 7,
                        width: double.infinity,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: hexToRgba(item.color, 1),
                          // borderRadius:
                          //     BorderRadius.all(const Radius.circular(30).w),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: appTextTheme.giloryBold22White
                                .copyWith(height: 1.1),
                          ),
                        ),
                        // child: AppNetworkImage(
                        //   path: item.color,
                        // ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5, bottom: 0)
                            .r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: item.links.map((link) {
                            return GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(
                                    Uri.parse(item.links.first.link))) {
                                  throw Exception(
                                      'Could not launch ${item.links.first.link}');
                                }
                                // Handle link tap event
                              },
                              child: Text(
                                '${item.links.first.title}',
                                // 'SupplementLink.com',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: appTextTheme.giloryMedium9White
                                    .copyWith(color: Colors.blue, fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }
        return const Center(
            child: SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator()));
      },
    );
  }

  Widget detailBtn(BuildContext context, Function()? onTap) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        // width: 345.w,
        height: 25.h,
        margin: const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 8).r,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(207, 27, 33, 1),
          borderRadius: BorderRadius.all(const Radius.circular(18).w),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'View Details',
            style: appTextTheme.gilorySemiBold16White.copyWith(fontSize: 12),
          ),
        ),
      ),
    );
  }
}

Color hexToRgba(String hex, double opacity) {
  // Remove the leading # if it's there
  hex = hex.replaceAll("#", "");

  // Convert the hex to an integer and parse it as RGB values
  int hexColor = int.parse(hex, radix: 16);

  // Calculate the red, green, blue values
  int red = (hexColor >> 16) & 0xFF;
  int green = (hexColor >> 8) & 0xFF;
  int blue = hexColor & 0xFF;

  // Create the color with the specified opacity
  return Color.fromRGBO(red, green, blue, opacity);
}
