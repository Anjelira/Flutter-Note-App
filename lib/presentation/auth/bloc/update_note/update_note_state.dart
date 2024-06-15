part of 'update_note_bloc.dart';

@immutable
sealed class UpdateNoteState {}

final class UpdateNoteInitial extends UpdateNoteState {}
final class UpdateNoteLoading extends UpdateNoteState {}
final class UpdateNoteSuccess extends UpdateNoteState {
  final NoteResponseModel note;

  UpdateNoteSuccess(this.note);
}
final class UpdateNoteFailed extends UpdateNoteState {
  final String message;

  UpdateNoteFailed(this.message);
}
