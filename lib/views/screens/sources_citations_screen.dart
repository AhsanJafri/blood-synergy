import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:blood_synergy_app/helpers/medical_citation_sources.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SourcesCitationsScreen extends StatefulWidget {
  const SourcesCitationsScreen({Key? key}) : super(key: key);

  @override
  State<SourcesCitationsScreen> createState() => _SourcesCitationsScreenState();
}

class _SourcesCitationsScreenState extends State<SourcesCitationsScreen> {
  int? _expandedPattern;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromRGBO(207, 27, 33, 1),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                        ),
                        Expanded(
                          child: Text(
                            'Sources & Citations',
                            textAlign: TextAlign.center,
                            style: appTextTheme.gilorySemiBold16White,
                          ),
                        ),
                        SizedBox(width: 40.w),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 4.w, top: 4.h),
                      child: Text(
                        'Educational references only — not medical advice. Tap any source to open it.',
                        style: appTextTheme.gilorySemiBold16White.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
              children: [
                Text(
                  'General foundations',
                  style:
                      appTextTheme.giloryBold16Black.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 10.h),
                ...MedicalCitationSources.general.map(
                  (link) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _LinkTile(
                      title: link.title,
                      subtitle: link.host,
                      accent: const Color.fromRGBO(207, 27, 33, 1),
                      onTap: () => Constants.launchURL(link.url),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Pattern research',
                  style:
                      appTextTheme.giloryBold16Black.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Research used for each educational wellness pattern.',
                  style: appTextTheme.giloryRegular12lightGrey,
                ),
                SizedBox(height: 10.h),
                ...MedicalCitationSources.patterns.map(
                  (pattern) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _PatternBlock(
                      pattern: pattern,
                      expanded: _expandedPattern == pattern.number,
                      onToggle: () {
                        setState(() {
                          _expandedPattern =
                              _expandedPattern == pattern.number
                                  ? null
                                  : pattern.number;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternBlock extends StatelessWidget {
  const _PatternBlock({
    required this.pattern,
    required this.expanded,
    required this.onToggle,
  });

  final CitationPattern pattern;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final accent = Color(pattern.accentColor);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: expanded ? accent.withOpacity(0.45) : const Color(0xFFE6E6E8),
          width: expanded ? 1.5 : 1,
        ),
        boxShadow: expanded
            ? [
                BoxShadow(
                  color: accent.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${pattern.number}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pattern.shortName,
                          style: appTextTheme.giloryBold12Black
                              .copyWith(fontSize: 15.sp),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Pattern ${pattern.number}  ·  ${pattern.sources.length} sources',
                          style: appTextTheme.giloryRegular12lightGrey
                              .copyWith(fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: accent,
                    size: 26.sp,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: accent.withOpacity(0.2)),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Column(
                children: pattern.sources
                    .map(
                      (link) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _LinkTile(
                          title: link.title,
                          subtitle: link.host,
                          accent: accent,
                          onTap: () => Constants.launchURL(link.url),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F7F8),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.open_in_new_rounded,
                  size: 16.sp,
                  color: accent,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextTheme.gilorySemiBold12Black
                          .copyWith(fontSize: 12.sp, height: 1.3),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appTextTheme.giloryRegular12lightGrey
                          .copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
