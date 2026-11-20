import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/models/exercise.dart';
import 'package:fitness_pro/data/exercises_data.dart';
import 'package:fitness_pro/screens/workout_screen.dart';
import 'package:fitness_pro/screens/exercise_detail_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final List<Map<String, dynamic>> _programs = [
    {
      'name': 'Новичок: Полное тело',
      'level': 'Начинающий',
      'duration': '4 недели',
      'workouts': 3,
      'icon': Icons.person,
      'color': AppColors.gold,
      'exercises': ['push_ups', 'squat_barbell', 'pull_ups', 'plank', 'lunges', 'dumbbell_curl', 'tricep_pushdown'],
    },
    {
      'name': 'Средний: Верх/Низ',
      'level': 'Средний',
      'duration': '6 недель',
      'workouts': 4,
      'icon': Icons.fitness_center,
      'color': AppColors.goldDark,
      'exercises': ['bench_press_barbell', 'barbell_row', 'shoulder_press_dumbbell', 'barbell_curl', 'tricep_dips', 'squat_barbell', 'leg_press', 'hip_thrust'],
    },
    {
      'name': 'Продвинутый: Сплит',
      'level': 'Продвинутый',
      'duration': '8 недель',
      'workouts': 5,
      'icon': Icons.emoji_events,
      'color': AppColors.gold,
      'exercises': ['bench_press_barbell', 'incline_dumbbell_press', 'cable_crossover', 'pull_ups', 'barbell_row', 'lat_pulldown', 'shoulder_press_dumbbell', 'lateral_raises', 'barbell_curl', 'hammer_curl', 'tricep_dips', 'skull_crushers'],
    },
    {
      'name': 'Грудь и трицепс',
      'level': 'Средний',
      'duration': '4 недели',
      'workouts': 3,
      'icon': Icons.accessibility_new,
      'color': AppColors.goldDark,
      'exercises': ['bench_press_barbell', 'incline_dumbbell_press', 'dumbbell_flyes', 'cable_crossover', 'tricep_dips', 'tricep_pushdown', 'skull_crushers'],
    },
    {
      'name': 'Спина и бицепс',
      'level': 'Средний',
      'duration': '4 недели',
      'workouts': 3,
      'icon': Icons.accessibility,
      'color': AppColors.gold,
      'exercises': ['pull_ups', 'barbell_row', 'lat_pulldown', 't_bar_row', 'seated_cable_row', 'barbell_curl', 'dumbbell_curl', 'hammer_curl'],
    },
    {
      'name': 'Ноги и ягодицы',
      'level': 'Средний',
      'duration': '4 недели',
      'workouts': 3,
      'icon': Icons.directions_run,
      'color': AppColors.goldDark,
      'exercises': ['squat_barbell', 'leg_press', 'lunges', 'romanian_deadlift', 'leg_curl', 'hip_thrust', 'glute_kickback', 'calf_raises'],
    },
    {
      'name': 'Плечи',
      'level': 'Средний',
      'duration': '4 недели',
      'workouts': 3,
      'icon': Icons.sports_gymnastics,
      'color': AppColors.gold,
      'exercises': ['shoulder_press_dumbbell', 'lateral_raises', 'arnold_press', 'front_raises', 'face_pulls', 'shrugs'],
    },
    {
      'name': 'Без оборудования (дома)',
      'level': 'Начинающий',
      'duration': '4 недели',
      'workouts': 3,
      'icon': Icons.home,
      'color': AppColors.goldDark,
      'exercises': ['push_ups', 'squat_barbell', 'lunges', 'plank', 'crunches', 'burpees', 'mountain_climbers', 'jumping_jacks'],
    },
    {
      'name': 'Кардио и сжигание жира',
      'level': 'Средний',
      'duration': '6 недель',
      'workouts': 4,
      'icon': Icons.favorite,
      'color': AppColors.gold,
      'exercises': ['burpees', 'mountain_climbers', 'jumping_jacks', 'jump_rope', 'hiit_circuit', 'plank', 'crunches'],
    },
    {
      'name': 'Растяжка и гибкость',
      'level': 'Начинающий',
      'duration': '2 недели',
      'workouts': 2,
      'icon': Icons.self_improvement,
      'color': AppColors.goldDark,
      'exercises': ['cat_cow', 'hamstring_stretch', 'child_pose', 'cobra_stretch', 'quad_stretch'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Программы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProgramDialog(context),
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
                  color: (p['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(p['icon'] as IconData, color: p['color'] as Color, size: 28),
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
              onTap: () => _showProgramDetail(context, p),
            ),
          );
        },
      ),
    );
  }

  void _showProgramDetail(BuildContext context, Map<String, dynamic> program) {
    final exerciseIds = program['exercises'] as List<String>;
    final exercises = exerciseIds
        .map((id) => allExercises.firstWhere((e) => e.id == id, orElse: () => allExercises.first))
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                program['name'] as String,
                style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${program['level']} • ${program['duration']} • ${exercises.length} упражнений',
                style: TextStyle(color: AppColors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text('Упражнения:', style: TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: exercises.length,
                  itemBuilder: (context, i) {
                    final ex = exercises[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('${i + 1}', style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ex.nameRu, style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                                Text('${ex.muscleName} • ${ex.defaultSets}×${ex.defaultReps}', style: TextStyle(color: AppColors.grey, fontSize: 11)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex))),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => WorkoutScreen(exercises: exercises, workoutName: program['name'] as String),
                    ));
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Начать тренировку'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateProgramDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Создать программу', style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название'),
              style: const TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Описание'),
              style: const TextStyle(color: AppColors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Программа создана!')),
              );
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}
