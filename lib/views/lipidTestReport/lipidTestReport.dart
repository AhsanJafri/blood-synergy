// ignore_for_file: must_be_immutable

import 'package:blood_synergy_app/Cubits/reports_bloc/reports_bloc.dart';
import 'package:blood_synergy_app/Cubits/statistics_cubit/statistics_cubit.dart';
import 'package:blood_synergy_app/Models/ReportDetailsModel.dart';
import 'package:blood_synergy_app/Repositories/StatisticsRepository.dart';
import 'package:blood_synergy_app/helpers/utils.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/Widgets/ExpansionTiles.dart';
import 'package:blood_synergy_app/views/screens/statistics/statistic.dart';
import 'package:blood_synergy_app/views/screens/widgets/MsgWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' show Client;

class LipidTestReportScreen extends StatefulWidget {
  ReportsBloc bloc;
  final int reportID;
  final int categoryID;
  final String reportName;

  LipidTestReportScreen(
      {required this.bloc,
      Key? key,
      required this.reportID,
      required this.reportName,
      required this.categoryID})
      : super(key: key);

  @override
  State<LipidTestReportScreen> createState() => _LipidTestReportScreenState();
}

class _LipidTestReportScreenState extends State<LipidTestReportScreen> {
  List<String> colouredImgs = [
    // "assets/images/circleOrange.png",
    "assets/images/circleRed.png",
    // "assets/images/circleYellow.png",
    "assets/images/circleGreen.png",
    // "assets/images/circleOrange.png",
    // "assets/images/circleGreen.png"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, left: 15).r,
                      height: 46.h,
                      width: 46.w,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Image.asset(
                        'assets/images/back.png',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Util.push(
                          context,
                          BlocProvider(
                            create: (context) => StatisticsCubit(
                                StatisticsRepository(
                                    NetworkClient(Client(), dio: Dio()))),
                            child: StatisticsScreen(),
                          ));
                    },
                    child: Container(
                      height: 43.h,
                      width: 91.w,
                      //  margin: EdgeInsets.only(left: 0, right: 0, top: 20).r,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(243, 243, 243, 1),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(12.0).w,
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0xffe2e2e2),
                        //     offset: const Offset(
                        //       1.0,
                        //       1.0,
                        //     ),
                        //     blurRadius: 10.0,
                        //     spreadRadius: 2.0,
                        //   ), //BoxShadow

                        //   //BoxShadow
                        // ]
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'View Stats',
                          style: appTextTheme.giloryBold12Black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 17, left: 15, right: 35).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reportName,
                            style: appTextTheme.giloryBold28WBlack,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                            //  'Please enter 6-digit code we have sent you on your phone ${barnoliAppStateManager.showNum}',
                            style: appTextTheme.giloryRegular14lightGrey,

                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14, left: 15).r,
                      child: Text(
                        'Lab Markers',
                        style: appTextTheme.giloryBold16Black,
                      ),
                    ),
                    Container(
                      height: 60.h,
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 8).r,
                      width: 345.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(244, 244, 244, 1),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(18.0).w,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0).r,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: hexToColor('#5CAE41'),
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(16.0).w,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0).r,
                                  child:
                                      Image.asset('assets/images/negative.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 18.w,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: hexToColor('#FF5A5A'),
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(18.0).w,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0).r,
                                  child: Image.asset(
                                    'assets/images/positive.png',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 14).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report Results',
                            style: appTextTheme.giloryBold18Black,
                          ),
                          Text(
                            'Here are your results based on our analysis',
                            style: appTextTheme.giloryRegular12lightGrey,
                          ),
                        ],
                      ),
                    ),
                    _reportDetail(),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 40).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pattern Results',
                            style: appTextTheme.giloryBold18Black,
                          ),
                          Text(
                            'Your report is falling under these patterns.',
                            style: appTextTheme.giloryRegular12lightGrey,
                          ),
                        ],
                      ),
                    ),
                    jobListing(),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 345.w,
                          height: 50.h,
                          margin: const EdgeInsets.only(
                                  top: 30, left: 10, right: 10, bottom: 20)
                              .r,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(92, 174, 65, 1),
                            borderRadius:
                                BorderRadius.all(const Radius.circular(18).w),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Save Report',
                              style: appTextTheme.gilorySemiBold16White,
                            ),
                          ),
                        )),
                  ]),
            )),
          ],
        ),
      ),
    );
  }

  Widget _reportDetail() {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        if (state.screen == ReportsBlocScreens.reportDetailscreen) {
          print("Report Detail observing");
          EasyLoading.dismiss();
          if (state.status.isInitial) {
            BlocProvider.of<ReportsBloc>(context)
                .add(FetchReportDetails(widget.categoryID, widget.reportID));
          } else if (state.status.isLoading) {
            EasyLoading.show(status: "Loading Reports...");
          } else if (state.status.isError) {
            return MsgWidget(msg: state.errorMessage);
          } else if (state.status.isSuccess && state.reportDetail != null) {
            return _listing(context, state.reportDetail!);
          }
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _listing(BuildContext context, ReportDetail reportDetail) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reportDetail.formAnswers?.length,
      itemBuilder: (context, i) {
        // return (context.read<TGTaskBloc>().state.TGTaskModelView?.jobPosted?[i].tasker != null) ?
        FormAnswer? item = reportDetail.formAnswers?[i];
        return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: SizedBox(
              width: 345.w,
              child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 8, top: 10).r,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item?.label ?? '',
                                style: appTextTheme.gilorySemiBold16Black,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                '${item?.range ?? ''} ${item?.unit ?? ''}',
                                style: appTextTheme.giloryRegular12lightGrey,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 2.5).r,
                                child: Image.asset(
                                  (item?.isPositive ?? 0) == 1
                                      ? colouredImgs[0]
                                      : colouredImgs[1],
                                  height: 12.h,
                                  width: 12.w,
                                ),
                              ),
                              SizedBox(
                                width: 90.w,
                                child: Text(
                                  '${item?.answer ?? ''} ${item?.unit ?? ''}',
                                  textAlign: TextAlign.end,
                                  style: appTextTheme.gilorySemiBold12Black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10).r,
                        height: 1.h,
                        width: 338.w,
                        color: const Color.fromRGBO(226, 226, 226, 1),
                      )
                    ],
                  )),
            ));
      },
    );
  }

  int getListCount(ReportDetail? detail) {
    int count = 0;
    if (detail?.allPatterns?.primary != null &&
        (detail?.allPatterns?.primary?.isNotEmpty ?? false)) {
      count += 1;
    }
    if (detail?.allPatterns?.secondary != null &&
        (detail?.allPatterns?.secondary?.isNotEmpty ?? false)) {
      count += 1;
    }
    if (detail?.allPatterns?.tertiary != null &&
        !(detail?.allPatterns?.tertiary?.isEmpty ?? true)) {
      count += 1;
    }
    return count;
  }

  // String getTitle(int index, ReportDetail? detail) {
  //   if (index == 0) {
  //     return (detail?.primary ?? []).map((person) => person.title).join(', ');
  //   } else if (index == 1) {
  //     return (detail?.secondary ?? []).map((person) => person.title).join(', ');
  //   } else if (index == 2) {
  //     return (detail?.tertiary ?? []).map((person) => person.title).join(', ');
  //   }
  //   return '';
  // }

  // String getColor(int index, ReportDetail? detail) {
  //   if (index == 0) {
  //     return (detail?.primary ?? []).map((person) => person.title).join(', ');
  //   } else if (index == 1) {
  //     return (detail?.secondary ?? []).map((person) => person.title).join(', ');
  //   } else if (index == 2) {
  //     return (detail?.tertiary ?? []).map((person) => person.title).join(', ');
  //   }
  //   return '';
  // }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Widget jobListing() {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        if (state.status.isSuccess && state.reportDetail != null) {
          var cnt = getListCount(state.reportDetail);
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: cnt == 0 ? 1 : cnt,
              itemBuilder: (context, index) {
                if (getListCount(state.reportDetail) == 0) {
                  return const Center(
                      child: Text(
                          'No Patterns matched or found against your report'));
                }
                List<Pattern>? currentItem = (index == 0
                        ? state.reportDetail?.allPatterns?.primary
                        : index == 1
                            ? state.reportDetail?.allPatterns?.secondary
                            : state.reportDetail?.allPatterns?.tertiary)
                    ?.cast<Pattern>();

                return CustomExpansionTile(
                  title: Text(
                    (currentItem ?? [])
                        .map((person) => person.title)
                        .join(', '),
                    style: appTextTheme.giloryBold18Black,
                  ), // Replace with the actual title property
                  trailingGridView: [
                    ...List.generate(
                        currentItem?.length ?? 0,
                        (index) => _getLinearGauge(hexToColor(
                            (currentItem?[index] as Pattern).color ?? '')))
                  ],
                  children: [
                    ...List.generate(
                        currentItem?.length ?? 0,
                        (rindex) => jobListingTwo(
                            (currentItem?[rindex] as Pattern),
                            index < (currentItem?.length ?? 0) - 1))
                  ],
                );
              });
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _getLinearGauge(Color color) {
    return CircularPercentIndicator(
      circularStrokeCap: CircularStrokeCap.round,
      // arcBackgroundColor: Colors.grey,
      // arcType: ArcType.FULL_REVERSED,
      radius: 25.0.w,

      lineWidth: 8.0,
      percent: 0.4,
      // header: new Text("Icon header"),
      center: Text(
        '40%',
        style: appTextTheme.giloryBold12Black.copyWith(fontSize: 11.sp),
      ),
      backgroundColor: Colors.grey.shade400,
      progressColor: color,
    );
  }

  Widget jobListingTwo(Pattern pattern, bool showDivider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pattern.title ?? 'N/A',
          style: appTextTheme.giloryBold14Black,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 11, right: 15).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remarks',
                style: appTextTheme.gilorySemiBold12Black,
              ),
              Text(
                pattern.remarks ?? 'N/A',
                style: appTextTheme.giloryRegular12lightGrey,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 11, right: 15).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Possible symptoms:',
                style: appTextTheme.gilorySemiBold12Black,
              ),
              Text(
                pattern.symptoms ?? 'N/A',
                style: appTextTheme.giloryRegular12lightGrey,
              ),
            ],
          ),
        ),
        showDivider ? Divider() : SizedBox.shrink()
      ],
    );
  }
}
