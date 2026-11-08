import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:blood_synergy_app/helpers/medical_citation_sources.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/screens/sources_citations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact citations block for Recommendations / report screens (App Review 1.4.1).
class MedicalCitations extends StatelessWidget {
  const MedicalCitations({Key? key, this.compact = false}) : super(key: key);

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final sources = compact
        ? MedicalCitationSources.general.take(4).toList()
        : MedicalCitationSources.general;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sources & Citations',
            style: appTextTheme.giloryBold12Black.copyWith(fontSize: 13.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            compact
                ? 'Educational content is informed by publicly available medical references. Not medical advice.'
                : 'Health and wellness information in this app is for educational purposes only and is informed by publicly available medical research. Always consult a licensed clinician for personal medical advice.',
            style: appTextTheme.giloryRegular12lightGrey,
          ),
          SizedBox(height: 8.h),
          ...sources.map(
            (s) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: InkWell(
                onTap: () => Constants.launchURL(s.url),
                child: Text(
                  s.title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SourcesCitationsScreen(),
                ),
              );
            },
            child: Text(
              'View all pattern-specific research sources →',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color.fromRGBO(207, 27, 33, 1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
