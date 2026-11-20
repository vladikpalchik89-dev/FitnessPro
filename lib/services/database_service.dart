import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitness_pro/models/exercise.dart';
import 'package:fitness_pro/models/workout.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_pro.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_ru TEXT NOT NULL,
        primary_muscle INTEGER NOT NULL,
        secondary_muscles TEXT,
        difficulty INTEGER NOT NULL,
        equipment INTEGER NOT NULL,
        description TEXT,
        steps TEXT,
        mistakes TEXT,
        safety TEXT,
        image_url TEXT,
        phase_images TEXT,
        video_url TEXT,
        default_sets INTEGER DEFAULT 3,
        default_reps INTEGER DEFAULT 12,
        default_rest INTEGER DEFAULT 60
      )
    ''');

    await db.execute('''
      CREATE TABLE workouts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        started_at TEXT,
        finished_at TEXT,
        duration INTEGER DEFAULT 0,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id TEXT NOT NULL,
        exercise_id TEXT NOT NULL,
        set_number INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        completed_at TEXT NOT NULL,
        FOREIGN KEY (workout_id) REFERENCES workouts(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE programs (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        level TEXT DEFAULT 'beginner',
        workout_ids TEXT,
        is_custom INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        exercise_id TEXT PRIMARY KEY,
        added_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY,
        name TEXT,
        age INTEGER,
        weight REAL,
        height REAL,
        goal TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // --- Exercises ---
  Future<void> insertExercise(Exercise ex) async {
    final db = await database;
    await db.insert('exercises', ex.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertExercises(List<Exercise> exercises) async {
    final db = await database;
    final batch = db.batch();
    for (final ex in exercises) {
      batch.insert('exercises', ex.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await database;
    final maps = await db.query('exercises');
    return maps.map(Exercise.fromMap).toList();
  }

  Future<List<Exercise>> getExercisesByMuscle(MuscleGroup muscle) async {
    final db = await database;
    final maps = await db.query('exercises', where: 'primary_muscle = ?', whereArgs: [muscle.index]);
    return maps.map(Exercise.fromMap).toList();
  }

  Future<List<Exercise>> searchExercises(String query) async {
    final db = await database;
    final maps = await db.query(
      'exercises',
      where: 'name LIKE ? OR name_ru LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map(Exercise.fromMap).toList();
  }

  Future<Exercise?> getExercise(String id) async {
    final db = await database;
    final maps = await db.query('exercises', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Exercise.fromMap(maps.first);
  }

  // --- Favorites ---
  Future<void> addFavorite(String exerciseId) async {
    final db = await database;
    await db.insert('favorites', {'exercise_id': exerciseId, 'added_at': DateTime.now().toIso8601String()}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String exerciseId) async {
    final db = await database;
    await db.delete('favorites', where: 'exercise_id = ?', whereArgs: [exerciseId]);
  }

  Future<List<String>> getFavoriteIds() async {
    final db = await database;
    final maps = await db.query('favorites');
    return maps.map((m) => m['exercise_id'] as String).toList();
  }

  Future<bool> isFavorite(String exerciseId) async {
    final db = await database;
    final maps = await db.query('favorites', where: 'exercise_id = ?', whereArgs: [exerciseId]);
    return maps.isNotEmpty;
  }

  // --- Workouts ---
  Future<void> insertWorkout(Workout workout) async {
    final db = await database;
    await db.insert('workouts', workout.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Workout>> getWorkouts({int limit = 50}) async {
    final db = await database;
    final maps = await db.query('workouts', orderBy: 'started_at DESC', limit: limit);
    return maps.map(Workout.fromMap).toList();
  }

  Future<void> insertWorkoutSet(String workoutId, String exerciseId, WorkoutSet set) async {
    final db = await database;
    await db.insert('workout_sets', {
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      ...set.toMap(),
    });
  }

  Future<List<WorkoutSet>> getSetsForWorkout(String workoutId) async {
    final db = await database;
    final maps = await db.query('workout_sets', where: 'workout_id = ?', whereArgs: [workoutId]);
    return maps.map(WorkoutSet.fromMap).toList();
  }

  // --- Programs ---
  Future<void> insertProgram(Program program) async {
    final db = await database;
    await db.insert('programs', program.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Program>> getPrograms() async {
    final db = await database;
    final maps = await db.query('programs');
    return maps.map(Program.fromMap).toList();
  }

  Future<void> deleteProgram(String id) async {
    final db = await database;
    await db.delete('programs', where: 'id = ?', whereArgs: [id]);
  }

  // --- User Profile ---
  Future<void> saveProfile(String name, int age, double weight, double height, String goal) async {
    final db = await database;
    await db.insert('user_profile', {
      'id': 1,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'goal': goal,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    final maps = await db.query('user_profile', where: 'id = 1');
    if (maps.isEmpty) return null;
    return maps.first;
  }
}
