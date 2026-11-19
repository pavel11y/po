import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Note {
  final String text;
  final bool isImportant;

  const Note({required this.text, this.isImportant = false});

  Note copyWith({String? text, bool? isImportant}) {
    return Note(
      text: text ?? this.text,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}

class NotesState {
  final List<Note> notes;
  final int editingIndex;

  const NotesState({this.notes = const [], this.editingIndex = -1});

  bool get isEditing => editingIndex != -1;
  String get currentEditingText =>
      editingIndex == -1 ? '' : notes[editingIndex].text;

  NotesState copyWith({List<Note>? notes, int? editingIndex}) {
    return NotesState(
      notes: notes ?? this.notes,
      editingIndex: editingIndex ?? this.editingIndex,
    );
  }
}

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(const NotesState());

  String saveNote(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return 'Введите текст заметки';
    }

    final notes = List<Note>.from(state.notes);

    if (state.editingIndex == -1) {
      notes.add(Note(text: trimmed));
      emit(state.copyWith(notes: notes));
    } else {
      notes[state.editingIndex] =
          notes[state.editingIndex].copyWith(text: trimmed);
      emit(state.copyWith(notes: notes, editingIndex: -1));
    }

    return '';
  }

  void deleteNote(int index) {
    final notes = List<Note>.from(state.notes)..removeAt(index);
    int newEditingIndex = state.editingIndex;

    if (state.editingIndex == index) {
      newEditingIndex = -1;
    } else if (state.editingIndex > index) {
      newEditingIndex--;
    }
    emit(state.copyWith(notes: notes, editingIndex: newEditingIndex));
  }

  void editNote(int index) {
    emit(state.copyWith(editingIndex: index));
  }

  void cancelEdit() {
    emit(state.copyWith(editingIndex: -1));
  }

  void toggleImportant(int index) {
    final notes = List<Note>.from(state.notes);
    notes[index] =
        notes[index].copyWith(isImportant: !notes[index].isImportant);
    emit(state.copyWith(notes: notes));
  }

  void markNormal(int index) {
    if (!state.notes[index].isImportant) return;
    final notes = List<Note>.from(state.notes);
    notes[index] = notes[index].copyWith(isImportant: false);
    emit(state.copyWith(notes: notes));
  }
}