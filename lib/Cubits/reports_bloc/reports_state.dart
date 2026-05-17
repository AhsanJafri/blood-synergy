// reports_state.dart

part of 'reports_bloc.dart';

enum ReportsStatus { initial, loading, success, error, reporscreen, navigate }

enum ReportsBlocScreens {
  reportListScreen,
  reportDetailscreen,
  createFormScreen
}

extension ReportsStatusX on ReportsStatus {
  bool get isInitial => this == ReportsStatus.initial;
  bool get isLoading => this == ReportsStatus.loading;
  bool get isSuccess => this == ReportsStatus.success;
  bool get isError => this == ReportsStatus.error;
  bool get shouldNavigate => this == ReportsStatus.navigate;
}

// class ReportsState extends Equatable {
//   final ReportsBlocScreens screen;
//   ReportsState(this.screen);
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }

@immutable
class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportsStatus.initial,
    required this.screen,
    reports,
    forms,
    reportDetail,
    String? errorMessage,
  })  : reports = reports ?? const [],
        form = forms,
        reportDetail = reportDetail,
        errorMessage = errorMessage ?? '';

  final List<ReportsModel> reports;
  final CategoryForm? form;
  final ReportsStatus status;
  final String errorMessage;
  final ReportsBlocScreens screen;
  final ReportDetail? reportDetail;
  @override
  List<Object?> get props =>
      [status, reports, errorMessage, screen, reportDetail];
}
 
 
 
// @immutable
// class CategoryFormState extends ReportsState {
//   final CategoryForm? forms;
//   final ReportsStatus status;
//   final String errorMessage;
//   final ReportsBlocScreens screen;

//   CategoryFormState({
//     this.status = ReportsStatus.initial,
//     this.screen = ReportsBlocScreens.reportListScreen,
//     this.forms,
//     String? errorMessage,
//   })  : errorMessage = errorMessage ?? '',
//         super(ReportsBlocScreens.createFormScreen);

//   @override
//   List<Object?> get props => [status, forms, errorMessage];
// }
