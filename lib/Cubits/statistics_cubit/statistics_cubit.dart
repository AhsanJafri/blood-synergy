import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/StatisticsModel.dart';
import 'package:blood_synergy_app/Repositories/StatisticsRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:flutter/material.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsRepository repo;
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  List<ChartData> data = [];
  StatisticsCubit(this.repo) : super(StatisticsInitial());
  var patternNames = {'': ''};

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<void> getStats(String type) async {
    emit(StatesScreenStates(AppResultState.loading('loading...')));

    try {
      // Perform field validation

      final _response = await repo.getStats(type);
      if (_response is RespSuccessStateWithData) {
        if (_response.value != null) {
          final StatisticsModel chartData = _response.value as StatisticsModel;
          // months.forEach((element) {
          //   chartData.putIfAbsent(element, () => []);
          // });

          Map<String, Map<String, dynamic>> processed = type == 'year'
              ? processStatisticsYear(chartData, type)
              : processStatistics(chartData, type);

          emit(StatesScreenStates(AppResultState.successWithData(processed)));

          return;
        }
        emit(StatesScreenStates(_response));
        return;
      }
      emit(StatesScreenStates(_response));
    } catch (error) {
      // Handle other errors (not related to signup result)
      emit(StatesScreenStates(AppResultState.error(error.toString())));
    }
  }

  Map<String, Map<String, dynamic>> processStatisticsYear(
      StatisticsModel statistics, String type) {
    Map<String, Map<String, dynamic>> result = {};

    if (statistics.data != null) {
      statistics.data!.forEach((year, statsList) {
        List<double> values = [];
        List<Color> colors = [];
        List<String?> colorNames = [];
        List<String?> titles = [];
        List<double> realValues = [];

        // Iterate through each Stats object for the current year
        List<double> allVals = statsList
            .map((e) => double.parse(e.result!.replaceAll('%', '')))
            .toList();

        double sum = allVals.reduce((value, element) => value + element);

        for (var stats in statsList) {
          double resultValue = double.parse(stats.result!.replaceAll('%', ''));
          var divident = resultValue / sum;
          // double rescaledVal =
          //     (resultValue < sum ? (resultValue / sum) * 100 : resultValue);

          values.add(double.parse(resultValue.toStringAsFixed(1)));

          realValues.add(resultValue);
          titles.add(stats.title);
          colorNames.add(stats.patternRangeColor);

          // Add colors corresponding to each value
          colors.add(hexToColor(stats.patternColor ?? '#ffffff'));
        }

        Map<String, dynamic> yearValue = {'values': values};
        yearValue['colors'] = colors;
        yearValue['colorNames'] = colorNames;
        yearValue['titles'] = titles;
        yearValue['realValues'] = realValues;

        // Add the ChartData instance to the result map
        result[year] = yearValue;
      });
    }

    return result;
  }

  Map<String, Map<String, dynamic>> processStatistics(
      StatisticsModel statistics, String type) {
    Map<String, Map<String, dynamic>> result = {};

    // List of all months
    List<String> allMonths = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    // Iterate through the statistics data and update the result map
    if (statistics.data != null) {
      statistics.data!.forEach((month, statsList) {
        List<double> values = [];
        List<Color> colors = [];
        List<String?> colorNames = [];
        List<String?> titles = [];

        List<double> realValues = [];

        // Iterate through each Stats object for the current month
        List<double> allVals = statsList
            .map((e) => double.parse(e.result!.replaceAll('%', '')))
            .toList();

        double sum = allVals.reduce((value, element) => value + element);

        for (var stats in statsList) {
          double resultValue = double.parse(stats.result!.replaceAll('%', ''));

          double rescaledVal = ((resultValue / sum) * 100);
          values.add((values.isEmpty ? 0.0 : values.last) +
              double.parse(rescaledVal.toStringAsFixed(1)) -
              0.5);
          realValues.add(resultValue);
          titles.add(stats.title);

          colorNames.add(stats.patternRangeColor);

          // Add colors corresponding to each value
          // You can customize the colors based on your requirements
          colors.add(hexToColor(stats.patternColor ?? '#ffffff'));
        }

        Map<String, dynamic> monthValue = {'values': values};
        monthValue['colors'] = colors;
        monthValue['colorNames'] = colorNames;
        monthValue['titles'] = titles;
        monthValue['realValues'] = realValues;

        // Add the ChartData instance to the result map
        result[month] = monthValue;
      });
    }

    // Ensure all months are in the result map
    for (String month in allMonths) {
      if (!result.containsKey(month)) {
        Map<String, dynamic> monthValue = {
          'values': List<double>.filled(9, 0.0)
        };
        monthValue['colors'] = List<Color>.filled(9, Colors.transparent);
        monthValue['realValues'] = List<double>.filled(9, 0.0);
        monthValue['colorNames'] = List<String>.filled(9, '');
        monthValue['titles'] = List<String>.filled(9, '');
        // Add the ChartData instance to the result map
        result[month] = monthValue;
      }
    }

    result = Map.fromEntries(result.entries.toList()
      ..sort((a, b) =>
          allMonths.indexOf(b.key).compareTo(allMonths.indexOf(a.key))));

    return result;
  }

  // Map<String, List<double>> processStatistics(StatisticsModel statistics) {
  //   Map<String, List<double>> result = {};

  //   // List of all months
  //   List<String> allMonths = [
  //     "January",
  //     "February",
  //     "March",
  //     "April",
  //     "May",
  //     "June",
  //     "July",
  //     "August",
  //     "September",
  //     "October",
  //     "November",
  //     "December"
  //   ];

  //   // Iterate through the statistics data and update the result map
  //   if (statistics.data != null) {
  //     statistics.data!.forEach((month, statsList) {
  //       List<double> values = [];

  //       List<Color> colors = [];
  //       List<double> realVals = [];

  //       // Iterate through each Stats object for the current month
  //       for (var stats in statsList) {
  //         double resultValue = double.parse(stats.result!.replaceAll('%', ''));
  //         values.add((values.isEmpty ? 0.0 : values.last) + resultValue);
  //       }

  //       // Add the values to the result map
  //       result[month] = values;
  //     });
  //   }

  //   // Ensure all months are in the result map
  //   for (String month in allMonths) {
  //     if (!result.containsKey(month)) {
  //       result[month] = List<double>.filled(9, 0.0);
  //     }
  //   }
  //   result = Map.fromEntries(result.entries.toList()
  //     ..sort((a, b) =>
  //         allMonths.indexOf(b.key).compareTo(allMonths.indexOf(a.key))));

  //   return result;
  // }
}
