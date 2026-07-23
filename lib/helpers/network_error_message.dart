import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

bool isNetworkFailure(Object? error, {FailureLike? failure}) {
  if (failure != null && failure.errorCode == 2) return true;

  final message = _messageFor(error, failure).toLowerCase();
  return message.contains('connection refused') ||
      message.contains('connection errored') ||
      message.contains('connection timeout') ||
      message.contains('network is unreachable') ||
      message.contains('failed host lookup') ||
      message.contains('socketexception') ||
      message.contains('no internet');
}

String friendlyNetworkError(Object? error, {FailureLike? failure}) {
  if (isNetworkFailure(error, failure: failure)) {
    return 'Unable to connect to the server. Please check your internet and try again.';
  }

  if (error is DioException) {
    final status = error.response?.statusCode;
    if (status != null && status >= 500) {
      return 'Server error. Please try again in a moment.';
    }
    if (status != null && status >= 400) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return 'Request failed. Please try again.';
    }
  }

  final raw = _messageFor(error, failure);
  if (raw.length > 120) {
    return 'Something went wrong. Please try again.';
  }
  return raw.isNotEmpty ? raw : 'Something went wrong. Please try again.';
}

String _messageFor(Object? error, FailureLike? failure) {
  if (failure?.errorMessage?.isNotEmpty == true) {
    return failure!.errorMessage!;
  }
  if (error is DioException) {
    return error.message ?? error.toString();
  }
  if (error is SocketException) {
    return error.message;
  }
  if (error is TimeoutException) {
    return error.message ?? 'Request timed out';
  }
  return error?.toString() ?? '';
}

abstract class FailureLike {
  String? get errorMessage;
  int get errorCode;
}
