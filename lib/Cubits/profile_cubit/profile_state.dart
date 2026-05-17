part of 'profile_cubit.dart';

@immutable
class ProfileScreenState {}

class ProfileInitial extends ProfileScreenState {}

 

class GetProfileState extends ProfileScreenState {
  final AppResultState<String>? profileResult;
  GetProfileState(this.profileResult);
}
