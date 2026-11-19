import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notes_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => NotesCubit(),
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNoteDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Просмотр заметки'),
        content: SingleChildScrollView(child: Text(text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotesCubit>();

    return BlocConsumer<NotesCubit, NotesState>(
      listener: (context, state) {
        if (state.isEditing) {
          final text = state.currentEditingText;
          _controller.text = text;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
        } else {
          _controller.clear();
        }
      },
      builder: (context, state) {
        final notes = state.notes;
        final isEditing = state.isEditing;

        return Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Редактирование заметки' : 'Мои заметки'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Введите текст заметки...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final error = cubit.saveNote(_controller.text);
                          if (error.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error)),
                            );
                          }
                        },
                        icon: Icon(isEditing ? Icons.check : Icons.save),
                        label: Text(isEditing ? 'Обновить' : 'Сохранить'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    if (isEditing) ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: cubit.cancelEdit,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                        child: const Text('Отмена'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: notes.isEmpty
                      ? const Center(
                    child: Text(
                      'Заметок пока нет',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isCurrent = state.editingIndex == index;

                      return Dismissible(
                        key: ValueKey('${index}_${note.text}'),
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.green,
                          child: const Icon(Icons.star_border, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            cubit.markNormal(index);
                            return false;
                          }
                          return true;
                        },
                        onDismissed: (_) => cubit.deleteNote(index),

                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: note.isImportant
                              ? Colors.amber.shade100
                              : (isCurrent ? Colors.indigo.shade50 : null),

                          child: GestureDetector(
                            onTap: () => _showNoteDialog(context, note.text),
                            onDoubleTap: () => cubit.toggleImportant(index),
                            onLongPress: () => cubit.editNote(index),

                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Text('${index + 1}'),
                                  ),
                                  const SizedBox(width: 12),
                                  if (note.isImportant)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.star, color: Colors.amber),
                                    ),
                                  Expanded(
                                    child: Text(
                                      note.text,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => cubit.editNote(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => cubit.deleteNote(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}