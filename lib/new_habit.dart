import 'package:flutter/material.dart';

import 'habit.dart';

class NewHabit extends StatefulWidget {
  const NewHabit({Key? key}) : super(key: key);

  @override
  _NewHabitState createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  Habit habit = Habit(habit: '', startedAt: DateTime.now(), type: 'good');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Habit')),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Habit'),
                  onChanged: (String value) => habit.habit = value,
                ),
                DropdownButtonFormField<String>(
                  items: ['good', 'bad']
                      .map<DropdownMenuItem<String>>(
                          (String type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                      .toList(),
                  value: habit.type,
                  decoration:
                      const InputDecoration(labelText: 'Is it good or bad?'),
                  onChanged: (String? value) => habit.type = value!,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 40),
                    child: const Text('Last time you did it',
                        style: TextStyle(fontSize: 16, color: Colors.black54))),
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  onDateChanged: (DateTime date) => habit.startedAt = date,
                ),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, habit),
                    child: const Text('Add'))
              ],
            ),
          ),
        ));
  }
}
