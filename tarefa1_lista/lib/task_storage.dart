import 'package:shared_preferences/shared_preferences.dart';

class TaskStorage {
  static const _key = 'completed_tasks';

  // carrega do SharedPreferences os IDs das tarefas marcadas como concluídas
  static Future<List<int>> loadCompletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList(_key);
    return saved?.map(int.parse).toList() ?? [];
  }

  // salva em SharedPreferences a lista de IDs das tarefas concluídas
  static Future<void> saveCompletedIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> asString = ids.map((i) => i.toString()).toList();
    await prefs.setStringList(_key, asString);
  }
}
