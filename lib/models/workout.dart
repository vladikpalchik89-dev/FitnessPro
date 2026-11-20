import 'package:fitness_pro/models/exercise.dart';

class WorkoutSet {
  final int setNumber;
  final int reps;
  final double weight;
  final DateTime completedAt;

  WorkoutSet({
    required this.setNumber,
    required this.reps,
    required this.weight,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'set_number': setNumber,
    'reps': reps,
    'weight': weight,
    'completed_at': completedAt.toIso8601String(),
  };

  factory WorkoutSet.fromMap(Map<String, dynamic> m) => WorkoutSet(
    setNumber: m['set_number'],
    reps: m['reps'],
    weight: (m['weight'] as num).toDouble(),
    completedAt: DateTime.parse(m['completed_at']),
  );
}

class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final int restSeconds;
  final List<WorkoutSet> completedSets;

  WorkoutExercise({
    required this.exercise,
    this.sets = 3,
    this.reps = 12,
    this.restSeconds = 60,
    this.completedSets = const [],
  });

  bool get isCompleted => completedSets.length >= sets;

  int get completedSetsCount => completedSets.length;

  WorkoutExercise copyWith({List<WorkoutSet>? completedSets}) => WorkoutExercise(
    exercise: exercise,
    sets: sets,
    reps: reps,
    restSeconds: restSeconds,
    completedSets: completedSets ?? this.completedSets,
  );
}

class Workout {
  final String id;
  final String name;
  final String description;
  final List<WorkoutExercise> exercises;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int durationMinutes;
  final String notes;

  Workout({
    required this.id,
    required this.name,
    this.description = '',
    required this.exercises,
    this.startedAt,
    this.finishedAt,
    this.durationMinutes = 0,
    this.notes = '',
  });

  int get totalSets => exercises.fold(0, (s, e) => s + e.sets);
  int get completedSets => exercises.fold(0, (s, e) => s + e.completedSetsCount);
  bool get isCompleted => exercises.every((e) => e.isCompleted);

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'started_at': startedAt?.toIso8601String(),
    'finished_at': finishedAt?.toIso8601String(),
    'duration': durationMinutes,
    'notes': notes,
  };

  factory Workout.fromMap(Map<String, dynamic> m) => Workout(
    id: m['id'],
    name: m['name'],
    description: m['description'] ?? '',
    exercises: [],
    startedAt: m['started_at'] != null ? DateTime.parse(m['started_at']) : null,
    finishedAt: m['finished_at'] != null ? DateTime.parse(m['finished_at']) : null,
    durationMinutes: m['duration'] ?? 0,
    notes: m['notes'] ?? '',
  );
}

class Program {
  final String id;
  final String name;
  final String description;
  final String level; // beginner, intermediate, advanced
  final List<String> workoutIds;
  final bool isCustom;
  final DateTime createdAt;

  Program({
    required this.id,
    required this.name,
    this.description = '',
    this.level = 'beginner',
    this.workoutIds = const [],
    this.isCustom = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'level': level,
    'workout_ids': workoutIds.join(','),
    'is_custom': isCustom ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
  };

  factory Program.fromMap(Map<String, dynamic> m) => Program(
    id: m['id'],
    name: m['name'],
    description: m['description'] ?? '',
    level: m['level'] ?? 'beginner',
    workoutIds: (m['workout_ids'] as String).isEmpty ? [] : (m['workout_ids'] as String).split(','),
    isCustom: m['is_custom'] == 1,
    createdAt: DateTime.parse(m['created_at']),
  );
}
