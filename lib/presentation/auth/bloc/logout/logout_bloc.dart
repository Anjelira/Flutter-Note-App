import 'package:bloc/bloc.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_remote_datasource.dart';
import 'package:meta/meta.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource remote;
  LogoutBloc(this.remote) : super(LogoutInitial()) {
    on<LogoutButtonPessed>((event, emit) async {
      emit(LogoutLoading());
      final response = await remote.logout();
      response.fold(
        (l) => emit(LogoutFailed(message: l)),
        (r) {
          AuthLocalDatasource().removeAuthData();
          emit(LogoutSuccess());
        },
      );
    });
  }
}
