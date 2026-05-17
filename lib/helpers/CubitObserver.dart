import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitNavigatorObserver<C extends Cubit> extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      // Dispose the cubit when navigating away from the screen
      Cubit cubit = _getCubit<C>(previousRoute.navigator!);
      cubit.close();
    }

    super.didPush(route, previousRoute);
  }

  Cubit _getCubit<C extends Cubit>(NavigatorState navigator) {
    // Find the cubit in the navigator's context
    return BlocProvider.of<C>(navigator.context);
  }
}
