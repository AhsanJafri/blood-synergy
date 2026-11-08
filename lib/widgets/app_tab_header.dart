import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact shared red header for Home / Wellness / Practitioners.
class AppTabHeader extends StatelessWidget {
  const AppTabHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.bottom,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(207, 27, 33, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: 10.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTextTheme.giloryBold22White.copyWith(
                            fontSize: 22.sp,
                            height: 1.15,
                          ),
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: appTextTheme.giloryBold22White.copyWith(
                              fontSize: 13.sp,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.92),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (bottom != null) ...[
                SizedBox(height: 8.h),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
