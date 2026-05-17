part of 'reports_bloc.dart';

@immutable
class ReportsEvent {}

class FetchReports extends ReportsEvent {
  final int categoryID;
  FetchReports(this.categoryID);
}

class FetchReportDetails extends ReportsEvent {
  final int categoryID;
  final int reportID;

  FetchReportDetails(this.categoryID, this.reportID);
}

class CreateForm extends ReportsEvent {}

class SetForReportsListScreen extends ReportsEvent {
  SetForReportsListScreen();
}

class FetchForm extends ReportsEvent {
  final int categoryID;
  FetchForm(this.categoryID);
}

class ResetBloc extends ReportsEvent {
  final ReportsBlocScreens screen;
  final ReportsStatus status;
  ResetBloc(this.screen, this.status);
}
