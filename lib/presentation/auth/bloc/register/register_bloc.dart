// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_idn_notes_app/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_idn_notes_app/data/models/request/register_request_model.dart';
import 'package:flutter_idn_notes_app/data/models/response/auth_response_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource remote;
  RegisterBloc(
    this.remote,
  ) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegsiterLoadng());
      final response = await remote.register(event.data);
      response.fold((l) => emit(RegisterFailed(message: l)),
          (r) => emit(RegisterSuccess(data: r)));
    });
  }
}
