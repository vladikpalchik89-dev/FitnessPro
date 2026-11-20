import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  final List<Map<String, dynamic>> _programs = const [
    {'name': 'Новичок: Полное тело', 'level': 'Начинающий', 'duration': '4 недели', 'workouts': 3, 'icon': Icons.person},
    {'name': 'Средний: Верх/Низ', 'level': 'Средний', 'duration': '6 недель', 'workouts': 4, 'icon': Icons.fitness_center},
    {'name': 'Продвинутый: Сплит', 'level': 'Продвинутый', 'duration': '8 недель', 'workouts': 5, 'icon': Icons.emoji_events},
    {'name': 'Только грудь и трицепс', 'level': 'Средний', 'duration': '4 недели', 'workouts': 3, 'icon': Icons.accessibility_new},
    {'name': 'Только ноги и ягодицы', 'level': 'Средний', 'duration': '4 недели', 'workouts': 3, 'icon': Icons.directions_run},
    {'name': 'Только спина и бицепс', 'level': 'Средний', 'duration': '4 недели', 'workouts': 3, 'icon': Icons.accessibility},
    {'name': 'Без оборудования (дома)', 'level': 'Начинающий', 'duration': '4 недели', 'workouts': 3, 'icon': Icons.home},
    {'name': 'Кардио и сжигание жира', 'level': 'Средний', 'duration': '6 недель', 'workouts': 4, 'icon': Icons.favorite},
    {'name': 'Растяжка и гибкость', 'level': 'Начинающий', 'duration': '2 недели', 'workouts': 2, 'icon': Icons.self_improvement},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Программы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _programs.length,
        itemBuilder: (context, index) {
          final p = _programs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(p['icon'] as IconData, color: AppColors.gold, size: 28),
              ),
              title: Text(
                p['name'] as String,
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${p['level']} • ${p['duration']} • ${p['workouts']} тренировки/нед',
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
