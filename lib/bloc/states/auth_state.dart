import 'package:equatable/equatable.dart';
import 'package:xrun/bloc/state_message.dart';

abstract class AuthState extends Equatable {
  final StateMessage? message;

  const AuthState({this.message});

  @override
  List<Object?> get props => [message ?? const StateMessage('message')];

  AuthState copyWith({
    StateMessage? message,
    bool? isLoading,
  });
}
