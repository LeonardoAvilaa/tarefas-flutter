import 'package:flutter/material.dart';
import './task.dart';
import './task_storage.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // lista de tarefas
  final List<Task> _tasks = [
    Task(id: 1, title: 'Tarefa 1', description: 'Descrição da Tarefa 1'),
    Task(id: 2, title: 'Tarefa 2', description: 'Descrição da Tarefa 2', completed: true),
    Task(id: 3, title: 'Tarefa 3', description: 'Descrição da Tarefa 3'),
    ];

    @override
    void initState() {
      super.initState ();
      _loadCompletedTasks();
    }

    // 
    void _loadCompletedTasks() async {
      final completedIds = await TaskStorage.loadCompletedIds();
      setState((){
        for (var task in _tasks) {
          task.completed = completedIds.contains(task.id);
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: _buildTaskList(),
    );
  }

// widget para exibir a lista de tarefas
  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return _buildTaskItem(task);
      },
    );
  }


  Widget _buildTaskItem(Task task) {
    return GestureDetector(
      // ao clicar na tarefa, alterna o estado completado
      onTap: () {
        setState(() {
          task.completed = !task.completed;
        });
        // salva as tarefas completadas
        final completedIds = _tasks.where((t) => t.completed).map((t) => t.id).toList();
        TaskStorage.saveCompletedIds(completedIds);
      },
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            // riscar as tarefas completadas
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.description),
        tileColor: task.completed ? Colors.green[100] : null,
      ),
    );
  }
}