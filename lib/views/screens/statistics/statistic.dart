import 'package:blood_synergy_app/Cubits/statistics_cubit/statistics_cubit.dart';
import 'package:blood_synergy_app/Models/StatisticsModel.dart';
import 'package:blood_synergy_app/Repositories/StatisticsRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' show Client;
// import 'package:syncfusion_flutter_gauges/gauges.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var countryPhoneCode = '';
  bool monthly = true;
  bool yearly = false;
  bool odometer = false;
  late List<ChartData> data;
  late List<ChartData> dataForYear;
  var selectedMonth = '';
  double selectedValue = 0.0;
  String selectedPatternName = '';
  String selectedColorName = '';
  String selectedColrRange = '';

  Color patternColr = Colors.transparent;
  Map<String, String> colorMap = {
    '#CE2027': 'Red',
    '#5CAC41': 'Green',
    '#FF8845': 'Orange',
    '#FFC839': 'Yellow',
    '#0044C9': 'Dark Blue',
    '#39B8EE': 'Light Blue',
    '#8D4BF9': 'Purple',
    '#F23891': 'Pink',
    '#9B7235': 'Brown',
    '#818589': 'Grey',
    '#000000': 'Black'
  };

  // RemoteDataSource _apiResponce = RemoteDataSource();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  StatisticsCubit? cubit;
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      resizeToAvoidBottomInset: true,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 15).r,
                // padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0).w,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/back.png',
                    height: 46.h,
                    width: 46.w,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 45).r,
                child: Text(
                  'Statistics',
                  style: appTextTheme.giloryBold22Black,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 38.h,
              width: 350.w,
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15).r,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(244, 244, 244, 1),
                borderRadius: BorderRadius.all(const Radius.circular(18).w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            monthly = true;
                            yearly = false;
                            odometer = false;
                            EasyLoading.show(status: 'loading...');
                            clearData();
                            BlocProvider.of<StatisticsCubit>(context)
                                .emit(StatisticsInitial());
                          });
                        }
                      },
                      child: Container(
                        // height: 42.h,
                        // width: 96.w,
                        // margin: EdgeInsets.only(top: 0, bottom: 0),
                        decoration: BoxDecoration(
                          color: (monthly == true)
                              ? const Color.fromRGBO(207, 27, 33, 1)
                              : const Color.fromRGBO(244, 244, 244, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Monthly',
                              style: (monthly == true)
                                  ? appTextTheme.gilorySemiBold16White
                                  : appTextTheme.giloryRegular14lightGrey,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            monthly = false;
                            yearly = true;
                            odometer = false;
                            EasyLoading.show(status: 'loading...');
                            clearData();
                            BlocProvider.of<StatisticsCubit>(context)
                                .emit(StatisticsInitial());
                          });
                        }
                      },
                      child: Container(
                        // height: 42.h,
                        // width: 96.w,
                        // margin: EdgeInsets.only(top: 0, bottom: 0),
                        decoration: BoxDecoration(
                          color: (yearly == true)
                              ? const Color.fromRGBO(207, 27, 33, 1)
                              : const Color.fromRGBO(244, 244, 244, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Yearly',
                              style: (yearly == true)
                                  ? appTextTheme.gilorySemiBold16White
                                  : appTextTheme.giloryRegular14lightGrey,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10).r,
            child: Text(
              'Patterns',
              style: appTextTheme.giloryBold16Black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Image.asset('assets/images/pattern_colors.png'),
          ),
          Expanded(
            child: BlocBuilder<StatisticsCubit, StatisticsState>(
              builder: (context, state) {
                EasyLoading.dismiss();
                if (state is StatisticsInitial) {
                  context
                      .read<StatisticsCubit>()
                      .getStats(monthly == true ? 'month' : 'year');
                  return const Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()));
                } else if (state is StatesScreenStates) {
                  if (state.result is RespErrorState)
                    return Center(
                        child: Text((state.result as RespErrorState)
                                .failure
                                ?.errorMessage ??
                            ''));

                  if (state.result is RespSuccessStateWithData) {
                    EasyLoading.dismiss();
                    Map<String, Map<String, dynamic>> charts =
                        (state.result as RespSuccessStateWithData).value
                            as Map<String, Map<String, dynamic>>;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              padding: EdgeInsets.zero,
                              child: _checkCond(charts)),

                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10)
                                .r,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(244, 244, 244, 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18).r,
                                    topRight: Radius.circular(18).r)),
                            // height: 150.h,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Odometer',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          selectedMonth,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 25.0).r,
                                      child: SizedBox(
                                        width: 180,
                                        height: 100, //height and width of guage
                                        child: SfRadialGauge(
                                            enableLoadingAnimation: true,
                                            //show meter pointer movement while loading
                                            animationDuration:
                                                4500, //pointer movement speed
                                            axes: <RadialAxis>[
                                              //Radial Guage Axix, use other Guage type here
                                              RadialAxis(
                                                minimum: 0, maximum: 100,
                                                showLabels: true,
                                                showTicks: false,
                                                showFirstLabel: false,
                                                axisLabelStyle: GaugeTextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black),
                                                labelOffset: 70.h,
                                                labelFormat:
                                                    '${selectedValue.toInt()}%',
                                                startAngle: 180,
                                                endAngle: 360,
                                                radiusFactor: 1.2,
                                                ranges: <GaugeRange>[
                                                  //Guage Ranges
                                                  GaugeRange(
                                                      startValue: 0,
                                                      endValue:
                                                          20, //start and end point of range
                                                      color: Colors.green,
                                                      startWidth: 10,
                                                      endWidth: 10),
                                                  GaugeRange(
                                                      startValue: 21,
                                                      endValue: 34,
                                                      color: Colors.yellow,
                                                      startWidth: 10,
                                                      endWidth: 10),
                                                  GaugeRange(
                                                      startValue: 35,
                                                      endValue: 49,
                                                      color: Colors.orange,
                                                      startWidth: 10,
                                                      endWidth: 10),
                                                  GaugeRange(
                                                      startValue: 50,
                                                      endValue: 100,
                                                      color: Colors.red,
                                                      startWidth: 10,
                                                      endWidth: 10)

                                                  //add more Guage Range here
                                                ],
                                                pointers: <GaugePointer>[
                                                  NeedlePointer(
                                                      // value: getRangeValue(),

                                                      value: selectedValue,
                                                      needleEndWidth: 1.5,
                                                      needleStartWidth: 0.1,
                                                      tailStyle: TailStyle(
                                                          color: Colors.black,
                                                          length:
                                                              10)) //add needlePointer here
                                                  //set value of pointer to 80, it will point to '80' in guage
                                                ],
                                                // annotations: <GaugeAnnotation>[
                                                //   GaugeAnnotation(
                                                //       widget: Container(
                                                //           child: Text('80.0',style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold))
                                                //       ),
                                                //       angle: 90,
                                                //       positionFactor: 0.5),
                                                //   //add more annotations 'texts inside guage' here
                                                // ]
                                              )
                                            ]),
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(5.sp),
                                            decoration: BoxDecoration(
                                                color: patternColr,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.sp))),
                                            child: Text(
                                              'Pattern Color: ${selectedColorName}',
                                              style: TextStyle(
                                                  fontSize: 9.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                        Text(
                                          selectedPatternName,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 8.sp,
                                    // ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10)
                                      .r,
                                  child: Image.asset(
                                      'assets/images/guageLabels.png'),
                                ),
                              ],
                            ),
                          ),

                          // Expanded(child: _monthlyGraph()),
                        ],
                      ),
                    );
                  }
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkCond(Map<String, Map<String, dynamic>> charts) {
    return _monthlyGraphh(charts);

    // return SizedBox.shrink();
  }

  double getRangeValue() {
    if (selectedColrRange.toLowerCase() == 'green') {
      return 15.0;
    } else if (selectedColrRange.toLowerCase() == 'yellow') {
      return 28.0;
    } else if (selectedColrRange.toLowerCase() == 'orange') {
      return 43.0;
    } else if (selectedColrRange.toLowerCase() == 'red') {
      return 80.0;
    }
    return 0.0;
    ;
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  String colorToHexCode(Color color) {
    String hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    return hex;
  }

  List<ChartData> mapDataToChartData(Map<String, Map<String, dynamic>> data) {
    List<ChartData> chartDataList = [];

    data.forEach((category, values) {
      chartDataList.add(ChartData(
          category,
          List<double>.from(values['values']),
          List<Color>.from(values['colors']),
          List<double>.from(values['realValues']),
          List<String>.from(values['colorNames']),
          List<String>.from(values['titles'])));
    });

    return chartDataList;
  }

  void onTap(
      ChartPointDetails pointInteractionDetails, List<ChartData> dataList) {
    int seriesIndex = pointInteractionDetails.seriesIndex ?? 0;
    int pointIndex = pointInteractionDetails.pointIndex ?? 0;

    if (seriesIndex >= 0 && seriesIndex < dataList.length) {
      ChartData selectedChartData = dataList[pointIndex];

      Color nselectedColor = selectedChartData.colr[seriesIndex];
      double nselectedRealValue = selectedChartData.realValues[seriesIndex];
      String colorRangeName = selectedChartData.patternColorNames[seriesIndex];
      String selectedPatternTitle = selectedChartData.titles[seriesIndex];

      String hex = colorToHexCode(nselectedColor);

      // String? selectedPatternName =
      //     selectedChartData.patternName?[pointIndex];
      selectedColrRange = colorRangeName;
      selectedMonth = selectedChartData.category;
      selectedColorName = colorMap[hex] ?? '#ffffff';
      patternColr = nselectedColor;
      selectedPatternName = selectedPatternTitle;
      selectedValue = nselectedRealValue;
      print('Selected Value: $selectedValue');
      print('Selected Color: $nselectedColor');
      print('Selected Real Value: $nselectedRealValue');
      setState(() {});
      // print('Selected Pattern Name: $selectedPatternName');
    }
  }

  List<CartesianSeries<ChartData, String>> getSeries(List<ChartData> dataList) {
    List<CartesianSeries<ChartData, String>> seriesList = [];
    int maxCount = dataList.isNotEmpty
        ? dataList
            .map((chartData) => chartData.values.length)
            .reduce((a, b) => a > b ? a : b)
        : 0;
    if (maxCount > 0) {
      for (int i = 0; i < maxCount; i++) {
        seriesList.add(
          StackedBarSeries<ChartData, String>(
            isVisibleInLegend: true,
            dataSource: dataList,
            xValueMapper: (ChartData sales, _) {
              return monthly ? sales.category.substring(0, 3) : sales.category;
            },
            yValueMapper: (ChartData sales, _) =>
                i < sales.values.length ? sales.values[i] : 0.0,
            enableTooltip: true,
            name: '',
            onPointTap: (pointInteractionDetails) {
              onTap(pointInteractionDetails, dataList);
            },
            sortFieldValueMapper: (ChartData sales, _) =>
                i < sales.realValues.length ? sales.realValues[i] : 0.0,
            dataLabelMapper: (ChartData sales, index) =>
                i < sales.realValues.length
                    ? '${sales.realValues[i].toString()}%'
                    : '',
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
            ),
            pointColorMapper: (datum, index) =>
                i < datum.colr.length ? datum.colr[i] : Colors.transparent,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        );
      }
    }

    return seriesList;
  }

  double calculateMaximumValue(List<ChartData> dataList) {
    double sum = dataList.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.realValues.reduce((a, b) => a + b));
    return sum < 120 ? sum + 120 : sum + 50;
  }

  Widget _monthlyGraphh(Map<String, Map<String, dynamic>> charts) {
    var chartData = mapDataToChartData(charts);

    return SfCartesianChart(
      borderColor: Colors.transparent,
      plotAreaBorderColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      borderWidth: 0,
      primaryXAxis: CategoryAxis(
          labelStyle:
              TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
          minimum: null,
          maximum: null,
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        isVisible: true,
        desiredIntervals: 4,
        minimum: 0,
        labelStyle: TextStyle(color: Colors.white),
        majorGridLines: MajorGridLines(),
        maximum: calculateMaximumValue(chartData),
      ),
      series: <CartesianSeries<dynamic, dynamic>>[...getSeries(chartData)],
    );
  }

  void clearData() {
    selectedMonth = '';
    selectedColorName = '';
    patternColr = Colors.transparent;
    selectedPatternName = '';
    selectedValue = 0.0;
    selectedColrRange = '';
  }
}
