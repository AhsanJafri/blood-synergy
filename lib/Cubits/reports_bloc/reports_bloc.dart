// reports_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/CategoryForms.dart';
import 'package:blood_synergy_app/Models/FormSubmissionModel.dart';
import 'package:blood_synergy_app/Models/ReportDetailsModel.dart';
import 'package:blood_synergy_app/Models/ReportsModel.dart';
import 'package:blood_synergy_app/Repositories/ReportsRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ReportsRepository repo;
  List<ReportsModel> allReports = [];
  bool shouldRefreshReports = false;
  CategoryForm? form;

  List<FormSubmissionModel> reportSubmissionModel = [];
  ReportsBloc(this.repo)
      : super(const ReportsState(screen: ReportsBlocScreens.reportListScreen)) {
    on<ReportsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchReports>(_onFetchReportsEvent);
    on<FetchForm>(_onFetchFormsEvent);
    on<SetForReportsListScreen>(_onSetForReportsListScreenEvent);
    on<FetchReportDetails>(_onFetchReportDetail);
    on<CreateForm>(_createReport);

    on<ResetBloc>(
      (event, emit) {
        emit(ReportsState(screen: event.screen, status: event.status));
      },
    );
  }

  void _onSetForReportsListScreenEvent(
      SetForReportsListScreen event, Emitter<ReportsState> emit) {
    emit(ReportsState(
        reports: allReports,
        status: ReportsStatus.success,
        screen: ReportsBlocScreens.reportListScreen));
  }

  void _onFetchReportsEvent(
      FetchReports event, Emitter<ReportsState> emit) async {
    emit(const ReportsState(
        status: ReportsStatus.loading,
        screen: ReportsBlocScreens.reportListScreen)); // Emit loading state
    shouldRefreshReports = false;
    try {
      final result = await repo.getReports(event.categoryID);
      if (result is RespSuccessStateWithData) {
        if (result.value != null) {
          List<Map<String, dynamic>> mapList = result.value!
              .where((element) => element is Map<String, dynamic>)
              .cast<Map<String, dynamic>>()
              .toList();
          final list =
              mapList.map((map) => ReportsModel.fromJson(map)).toList();
          allReports = list;
          emit(ReportsState(
              reports: list,
              status: ReportsStatus.success,
              screen: ReportsBlocScreens.reportListScreen));
        } else {
          emit(ReportsState(
              reports: allReports,
              status: ReportsStatus.success,
              screen: ReportsBlocScreens.reportListScreen));
        }
      } else if (result is RespSuccessState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.value.toString(),
            screen: ReportsBlocScreens.reportDetailscreen));
      } else if (result is RespErrorState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.failure?.errorMessage ?? '',
            screen: ReportsBlocScreens.reportListScreen));
      }
    } catch (e) {
      emit(ReportsState(
          status: ReportsStatus.error,
          errorMessage: e.toString(),
          screen: ReportsBlocScreens.reportListScreen));
    }
  }

  void _onFetchReportDetail(
      FetchReportDetails event, Emitter<ReportsState> emit) async {
    emit(const ReportsState(
        status: ReportsStatus.loading,
        screen: ReportsBlocScreens.reportDetailscreen)); // Emit loading state

    try {
      final result =
          await repo.getReportDetails(event.categoryID, event.reportID);
      if (result is RespSuccessStateWithData) {
        if (result.value != null) {
          final list = ReportDetail.fromJson(result.value);

          emit(ReportsState(
              reportDetail: list,
              status: ReportsStatus.success,
              screen: ReportsBlocScreens.reportDetailscreen));
        }
      } else if (result is RespSuccessState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.value.toString(),
            screen: ReportsBlocScreens.reportDetailscreen));
      } else if (result is RespErrorState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.failure?.errorMessage ?? '',
            screen: ReportsBlocScreens.reportDetailscreen));
      }
    } catch (e) {
      emit(ReportsState(
          status: ReportsStatus.error,
          errorMessage: e.toString(),
          screen: ReportsBlocScreens.reportDetailscreen));
    }
  }

  void _onFetchFormsEvent(FetchForm event, Emitter<ReportsState> emit) async {
    emit(const ReportsState(
        status: ReportsStatus.loading,
        screen: ReportsBlocScreens.createFormScreen)); // Emit loading state

    try {
      final result = await repo.getForms(event.categoryID);
      if (result is RespSuccessStateWithData) {
        if (result.value != null) {
          // Map<String, dynamic> map = result.value!
          //     .where((element) => element is Map<String, dynamic>)
          //     .cast<Map<String, dynamic>>();
          // print(map);
          CategoryForm resforms = CategoryForm.fromJson(result.value);
          form = resforms;

          emit(ReportsState(
              forms: resforms,
              status: ReportsStatus.success,
              screen: ReportsBlocScreens.createFormScreen));
        } else {
          emit(const ReportsState(
              status: ReportsStatus.success,
              screen: ReportsBlocScreens.createFormScreen));
        }
      } else if (result is RespSuccessState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.value.toString(),
            screen: ReportsBlocScreens.createFormScreen));
      } else if (result is RespErrorState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.failure?.errorMessage ?? '',
            screen: ReportsBlocScreens.createFormScreen));
      }
    } catch (e) {
      emit(ReportsState(
          status: ReportsStatus.error,
          errorMessage: e.toString(),
          screen: ReportsBlocScreens.createFormScreen));
    }
  }

  void _createReport(CreateForm event, Emitter<ReportsState> emit) async {
    emit(const ReportsState(
        status: ReportsStatus.loading,
        screen: ReportsBlocScreens.createFormScreen)); // Emit loading state

    try {
      final result = await repo.createReport(
          reportSubmissionModel.map((model) => model.toJson()).toList());
      if (result is RespSuccessAndNavigateState) {
        shouldRefreshReports = true;

        emit(const ReportsState(
            status: ReportsStatus.navigate,
            screen: ReportsBlocScreens.createFormScreen));
      } else if (result is RespSuccessState) {
        shouldRefreshReports = true;
        form = result.value;
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.value.toString(),
            screen: ReportsBlocScreens.createFormScreen));
      } else if (result is RespErrorState) {
        emit(ReportsState(
            status: ReportsStatus.error,
            errorMessage: result.failure?.errorMessage ?? '',
            screen: ReportsBlocScreens.createFormScreen));
      }
    } catch (e) {
      emit(ReportsState(
          status: ReportsStatus.error,
          errorMessage: e.toString(),
          screen: ReportsBlocScreens.createFormScreen));
    }
  }
}
