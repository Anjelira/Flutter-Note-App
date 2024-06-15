// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_idn_notes_app/data/datasource/note_remote_datasource.dart';
import 'package:flutter_idn_notes_app/data/models/response/all_notes_response_model.dart';

part 'all_notes_event.dart';
part 'all_notes_state.dart';

class AllNotesBloc extends Bloc<AllNotesEvent, AllNotesState> {
  final NoteRemoteDatasource remote;
  AllNotesBloc(
    this.remote,
  ) : super(AllNotesInitial()) {
    on<GetAllNote>((event, emit) async {
      emit(AllNotesLoading());
      final result = await remote.getAllNotes();
      result.fold((message) {
        emit(AllNotesFailed(message: message));
      }, (data) {
        emit(AllNotesSuccess(data: data));
      });
    });
  }
}
