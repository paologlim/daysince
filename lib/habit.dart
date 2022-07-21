class Habit {
  String habit = '';
  DateTime startedAt = DateTime.now();
  String type = 'good';

  Habit({required this.habit, required this.startedAt, required this.type});
}
