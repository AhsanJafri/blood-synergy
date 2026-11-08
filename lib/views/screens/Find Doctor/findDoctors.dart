import 'package:blood_synergy_app/Cubits/doctors_cubit/doctors_cubit.dart';
import 'package:blood_synergy_app/Models/DoctorsModel.dart';
import 'package:blood_synergy_app/helpers/GeneralStates.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/AppNetworkImage.dart';
import '../../../themes/textTheme.dart';
import '../../../Repositories/HomeRepository.dart';
import '../../../network_helpers/network.dart';
import 'package:http/http.dart';
import 'package:blood_synergy_app/views/screens/Find%20Doctor/doctor_detail.dart';
import 'package:blood_synergy_app/widgets/app_tab_header.dart';

class FindDoctorScreen extends StatefulWidget {
  @override
  _FindDoctorScreenState createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  TextEditingController _searchController = TextEditingController();
  List<DoctorModel> filteredDoctors = [];
  List<DoctorModel> allDoctors = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDoctors = allDoctors;
      } else {
        filteredDoctors = allDoctors.where((doctor) {
          return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
                 doctor.city.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

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
            AppTabHeader(
              title: 'Practitioners',
              subtitle:
                  'Connect for educational 1-on-1 consultations. Practitioners practice only where they are licensed.',
              bottom: Container(
                height: 36.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: _searchController,
                  inputFormatters: [LengthLimitingTextInputFormatter(40)],
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  style: appTextTheme.giloryMedium14BlackTheme
                      .copyWith(fontSize: 13.sp),
                  decoration: InputDecoration(
                    hintText: 'Search practitioners',
                    isDense: true,
                    hintStyle: appTextTheme.giloryMedium14lightGrey
                        .copyWith(fontSize: 13.sp),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                    prefixIcon: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      child: Image.asset(
                        'assets/images/searchImg.png',
                        height: 14.h,
                        width: 14.w,
                      ),
                    ),
                  ),
                  onChanged: _filterDoctors,
                ),
              ),
            ),
            Expanded(child: _gridView(context)),
          ],
        ),
      ),
    );
  }

  Widget _gridView(BuildContext context) {
    // var supplements = dummyDoctors;
    // return GridView.count(
    //   crossAxisCount: 2,
    //   shrinkWrap: true,
    //   padding:
    //       const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10).r,
    //   crossAxisSpacing: 15.w,
    //   mainAxisSpacing: 15.w,
    //   childAspectRatio: 9.w / 10.w,
    //   children: List.generate((1), (index) {
    //     return InkWell(
    //       splashColor: Colors.transparent,
    //       onTap: () {},
    //       child: Container(
    //         clipBehavior: Clip.hardEdge,
    //         decoration: BoxDecoration(
    //           color: const Color.fromRGBO(243, 243, 243, 1),
    //           borderRadius: BorderRadius.all(const Radius.circular(22).w),
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Container(
    //                 height: MediaQuery.of(context).size.width / 4,
    //                 width: double.infinity,
    //                 padding: const EdgeInsets.symmetric(vertical: 10),
    //                 decoration: const BoxDecoration(color: Colors.transparent
    //                     // borderRadius:
    //                     //     BorderRadius.all(const Radius.circular(30).w),
    //                     ),
    //                 child: Container(
    //                   width: 60.0, // Set the width of the circle
    //                   height: 60.0, // Set the height of the circle
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.circle, // Make the container circular
    //                     image: DecorationImage(
    //                       image:
    //                           AssetImage('assets/images/dummy_doc_image.png'),
    //                       fit: BoxFit
    //                           .contain, // Ensure the image covers the circle
    //                     ),
    //                   ),
    //                 )
    //                 // AppNetworkImage(
    //                 //   // isProfile: true,
    //                 //   path: item.image,
    //                 //   isCircular: true,
    //                 // ),
    //                 ),
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                       top: 5, left: 5, right: 5, bottom: 0)
    //                   .r,
    //               child: Text(
    //                 'Dr. Brandon Brock',
    //                 maxLines: 2,
    //                 overflow: TextOverflow.ellipsis,
    //                 textAlign: TextAlign.start,
    //                 style: appTextTheme.giloryBold12Black,
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                       top: 2.5, left: 5, right: 5, bottom: 0)
    //                   .r,
    //               child: Text(
    //                 'Texas',
    //                 maxLines: 2,
    //                 overflow: TextOverflow.ellipsis,
    //                 textAlign: TextAlign.start,
    //                 style: appTextTheme.giloryRegular14lightGrey
    //                     .copyWith(fontSize: 11),
    //               ),
    //             ),
    //             const Spacer(),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 25.0),
    //               child: detailBtn(context, () {
    //                 AppNavigator.navigateToDocDetail(context);
    //               }),
    //             )
    //           ],
    //         ),
    //       ),
    //     );
    //   }),
    // );
     return BlocBuilder<DoctorsCubit, DoctorsState>(
       builder: (context, state) {
         if (state.status.isInitial) {
           context.read<DoctorsCubit>().getDoctors();
         } else if (state.status.isError) {
           return Center(
             child: Text((state as RespErrorState).failure?.errorMessage ?? ''),
           );
         } else if (state.status.isSuccess) {
           var docs = context.read<DoctorsCubit>().docs;
           
           // Update allDoctors and filteredDoctors when data is loaded
           if (allDoctors.isEmpty && docs.isNotEmpty) {
             allDoctors = docs;
             filteredDoctors = docs;
           }
           
           // Use filtered doctors for display
           var displayDoctors = filteredDoctors.isEmpty && _searchController.text.isNotEmpty 
               ? <DoctorModel>[] 
               : filteredDoctors.isEmpty 
                   ? docs 
                   : filteredDoctors;
    
           if (displayDoctors.isEmpty && _searchController.text.isNotEmpty) {
             return const Center(
               child: Text('No doctors found matching your search.'),
             );
           }
           
           if (displayDoctors.isEmpty) {
             return const Center(
               child: Text('No Doctors Found!'),
             );
           }

           return GridView.count(
             crossAxisCount: 2,
             shrinkWrap: true,
             padding:
                 const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10)
                     .r,
             crossAxisSpacing: 15.w,
             mainAxisSpacing: 15.w,
             childAspectRatio: 9.w / 11.w,
             children: List.generate((displayDoctors.length), (index) {
               var item = displayDoctors[index];
               return InkWell(
                 splashColor: Colors.transparent,
                 onTap: () {},
                 child: Container(
                   clipBehavior: Clip.hardEdge,
                   decoration: BoxDecoration(
                     color: const Color.fromRGBO(243, 243, 243, 1),
                     borderRadius: BorderRadius.all(const Radius.circular(22).w),
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Container(
                         height: MediaQuery.of(context).size.width / 4,
                         width: double.infinity,
                         padding: const EdgeInsets.symmetric(vertical: 10),
                         decoration: const BoxDecoration(
                             color: Colors.transparent
                             // borderRadius:
                             //     BorderRadius.all(const Radius.circular(30).w),
                             ),
                         child: AppNetworkImage(
                           // isProfile: true,
                           path: item.image,
                           isCircular: true,
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(
                                 top: 5, left: 5, right: 5, bottom: 0)
                             .r,
                         child: Text(
                           item.name,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.center,
                           style: appTextTheme.giloryBold12Black,
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(
                                 top: 2.5, left: 5, right: 5, bottom: 0)
                             .r,
                         child: Text(
                           item.city,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.start,
                           style: appTextTheme.giloryRegular14lightGrey
                               .copyWith(fontSize: 11),
                         ),
                       ),
                       const Spacer(),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
                         child: detailBtn(context, (){
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (_) => DoctorDetail(doctorId: item.id),
                             ),
                           );
                         }
                         ),
                       )
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
