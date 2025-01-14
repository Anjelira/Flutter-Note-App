import 'package:bloc/bloc.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_idn_notes_app/data/models/response/auth_response_model.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource remote;
  LoginBloc(this.remote) : super(LoginInitial()) {
    on<LoginButtonPessed>((event, emit) async {
      emit(LoginLoading());
      final response = await remote.login(event.email, event.password);
      response.fold(
        (error) => emit(LoginFailed(message: error)),
        (data){
          AuthLocalDatasource().saveAuthData(data);
          emit(LoginSuccess(data: data));
        }
      );
    });
  }
}
