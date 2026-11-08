import 'package:blood_synergy_app/Cubits/doctors_cubit/doctors_cubit.dart';
import 'package:blood_synergy_app/Cubits/supplements_cubit/supplements_cubit.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/GeneralStates.dart';
import '../../../themes/textTheme.dart';
import '../../../network_helpers/network.dart';
import 'package:blood_synergy_app/widgets/app_tab_header.dart';
import 'package:http/http.dart';

class SupplementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorsCubit(HomeRepository(NetworkClient(Client(), dio: Dio()))),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF7F7F8),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTabHeader(
              title: 'Wellness',
              subtitle:
                  'Educational resources, videos, and wellness options. Always consult a doctor for personalized advice.',
            ),
            Expanded(child: _gridView(context)),
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

          if (supplements.isEmpty) {
            return const Center(child: Text('No Wellness Patterns Found!'));
          }

          return GridView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.88,
            ),
            itemCount: supplements.length,
            itemBuilder: (context, index) {
              final item = supplements[index];
              final accent = hexToRgba(item.color, 1);
              // Do not open external video/store purchase links (App Review 3.1.1).
              const footerLabel = 'Educational pattern overview';

              return Material(
                color: Colors.white,
                elevation: 0,
                borderRadius: BorderRadius.circular(18.r),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: const Color(0xFFE8E8EA)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 55,
                        child: Container(
                          color: accent,
                          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    _iconForTitle(item.title, index),
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                item.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: appTextTheme.giloryBold22White.copyWith(
                                  fontSize: 14.sp,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 40,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  size: 16.sp,
                                  color: accent,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  footerLabel,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style:
                                      appTextTheme.giloryMedium9White
                                        .copyWith(
                                    color: const Color(0xFF1A1A1A),
                                    fontSize: 11.sp,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

/// Maps wellness category titles to icons. Extra keyword coverage + index
/// fallback so new categories still get a distinct icon.
IconData _iconForTitle(String title, int index) {
  final t = title.toLowerCase();
  if (t.contains('energy') || t.contains('vitality') || t.contains('fatigue')) {
    return Icons.bolt_rounded;
  }
  if (t.contains('digest') || t.contains('gut') || t.contains('stomach')) {
    return Icons.restaurant_rounded;
  }
  if (t.contains('cellular repair') ||
      t.contains('repair') ||
      t.contains('recover')) {
    return Icons.healing_rounded;
  }
  if (t.contains('metabolic') ||
      t.contains('metabolism') ||
      t.contains('weight')) {
    return Icons.local_fire_department_rounded;
  }
  if (t.contains('endocrine') || t.contains('hormone')) {
    return Icons.science_rounded;
  }
  if (t.contains('cognitive') ||
      t.contains('brain') ||
      t.contains('memory') ||
      t.contains('focus')) {
    return Icons.psychology_rounded;
  }
  if (t.contains('immune') || t.contains('immunity') || t.contains('virus')) {
    return Icons.shield_rounded;
  }
  if (t.contains('cellular development') ||
      t.contains('growth') ||
      t.contains('development')) {
    return Icons.spa_rounded;
  }
  if (t.contains('inflamm') || t.contains('joint') || t.contains('pain')) {
    return Icons.water_drop_rounded;
  }
  if (t.contains('blood sugar') ||
      t.contains('glucose') ||
      t.contains('sugar') ||
      t.contains('diabetes')) {
    return Icons.monitor_heart_rounded;
  }
  if (t.contains('hashimoto')) return Icons.biotech_rounded;
  if (t.contains('hypothyroid') || t.contains('thyroid')) {
    return Icons.favorite_rounded;
  }
  if (t.contains('anemia') || t.contains('iron') || t.contains('folate')) {
    return Icons.bloodtype_rounded;
  }
  if (t.contains('hepatic') || t.contains('liver') || t.contains('detox')) {
    return Icons.eco_rounded;
  }
  if (t.contains('heart') || t.contains('cardio') || t.contains('lipid')) {
    return Icons.favorite_border_rounded;
  }
  if (t.contains('sleep') || t.contains('rest')) return Icons.bedtime_rounded;
  if (t.contains('stress') || t.contains('anxiety') || t.contains('mood')) {
    return Icons.self_improvement_rounded;
  }
  if (t.contains('bone') || t.contains('calcium') || t.contains('mineral')) {
    return Icons.accessibility_new_rounded;
  }
  if (t.contains('skin') || t.contains('hair') || t.contains('beauty')) {
    return Icons.face_retouching_natural_rounded;
  }
  if (t.contains('kidney') || t.contains('renal')) return Icons.opacity_rounded;
  if (t.contains('vitamin') ||
      t.contains('nutrient') ||
      t.contains('supplement')) {
    return Icons.medication_rounded;
  }
  if (t.contains('fitness') || t.contains('exercise') || t.contains('muscle')) {
    return Icons.fitness_center_rounded;
  }
  if (t.contains('hydration') || t.contains('water')) {
    return Icons.water_rounded;
  }
  if (t.contains('inflam')) return Icons.whatshot_rounded;

  // Stable fallbacks for future / unknown categories
  const fallbacks = <IconData>[
    Icons.health_and_safety_rounded,
    Icons.volunteer_activism_rounded,
    Icons.medical_services_rounded,
    Icons.monitor_heart_outlined,
    Icons.bubble_chart_rounded,
    Icons.insights_rounded,
    Icons.auto_awesome_rounded,
    Icons.nightlife_rounded,
    Icons.grass_rounded,
    Icons.air_rounded,
  ];
  return fallbacks[index % fallbacks.length];
}

Color hexToRgba(String hex, double opacity) {
  hex = hex.replaceAll("#", "");
  int hexColor = int.parse(hex, radix: 16);
  int red = (hexColor >> 16) & 0xFF;
  int green = (hexColor >> 8) & 0xFF;
  int blue = hexColor & 0xFF;
  return Color.fromRGBO(red, green, blue, opacity);
}
