part of 'admin_cubit.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoad extends AdminState {
  final Admin admin;

  AdminLoad(this.admin);
}

class AdminError extends AdminState {}
