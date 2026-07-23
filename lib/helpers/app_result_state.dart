import 'dart:async';
import 'dart:io';

import 'package:blood_synergy_app/helpers/network_error_message.dart';
import 'package:dio/dio.dart';

class AppResultState<T> {
  AppResultState._();
  factory AppResultState.loading(T msg) = LoadingState<T>;

  factory AppResultState.success(T value) = RespSuccessState<T>;

  factory AppResultState.successNavigate(T value) =
      RespSuccessAndNavigateState<T>;
  factory AppResultState.successWithData(T value) = RespSuccessStateWithData<T>;

  factory AppResultState.error(T failure) = RespErrorState<T>;
}

class LoadingState<T> extends AppResultState<T> {
  LoadingState(this.msg) : super._();
  final T msg;
}

class RespErrorState<T> extends AppResultState<T> {
  Failure? failure;
  RespErrorState(T error) : super._() {
    if (error is Failure) {
      failure = error;
      if (failure?.errorCode == 401) {
        print(
            "Unauthenticated: ${failure?.errorCode}: ${failure?.errorMessage}");
        // Util.unauthenticatedUser(build);
      }
    } else if (error is DioException) {
      failure = Failure(
        errorMessage: friendlyNetworkError(error),
        errorCode: isNetworkFailure(error) ? 2 : 5,
      );
    } else if (error is HttpException) {
      failure = Failure(
          errorMessage: (error as HttpException).message.toString(),
          errorCode: 1);
    } else if (error is SocketException || error is TimeoutException) {
      failure = Failure(
          errorMessage: friendlyNetworkError(error),
          errorCode: 2);
    } else if (error is FormatException) {
      failure = Failure(
          errorMessage: (error as FormatException).message.toString(),
          errorCode: 3);
    } else {
      failure = Failure(
        errorMessage: friendlyNetworkError(error),
        errorCode: isNetworkFailure(error) ? 2 : 5,
      );
    }
  }

// void setError(T msg) {
//   if (msg is SocketException) {
//     message = (msg as SocketException).osError.message;
//   }
// }
}

class RespSuccessState<T> extends AppResultState<T> {
  final T value;
  RespSuccessState(this.value) : super._();
}

class RespSuccessStateWithData<T> extends AppResultState<T> {
  final T value;
  RespSuccessStateWithData(this.value) : super._();
}

class RespSuccessAndNavigateState<T> extends AppResultState<T> {
  final T value;
  RespSuccessAndNavigateState(this.value) : super._();
}

class Failure implements FailureLike {
  String? errorMessage;
  int errorCode = 0;

  Failure({
    required this.errorMessage,
    required this.errorCode,
  });

  Failure.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'][0];
    errorCode = json['errorCode'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorMessage'] = errorMessage;
    data['errorCode'] = errorCode;
    return data;
  }
}
