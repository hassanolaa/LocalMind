part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class getModelsLoading extends HomeState {}
final class getModelsLoaded extends HomeState {}
final class getModelsEmpty extends HomeState {
  final String message;
  getModelsEmpty({required this.message});
}

final class getModelsError extends HomeState {
  final String message;
  getModelsError({required this.message});
}

final class messegeAdded extends HomeState {}

final class chatsLoading extends HomeState {}
final class chatsLoaded extends HomeState {}
final class chatsError extends HomeState {
  final String message;
  chatsError({required this.message});
}
final class chatAdded extends HomeState {}