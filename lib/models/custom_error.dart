import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  final String errorMessage;
  CustomError({
    this.errorMessage = '',
  });

  @override
  String toString() {
    return 'CustomError{errorMessage: $errorMessage}';
  }

  @override
  List<Object> get props => [errorMessage];
}
