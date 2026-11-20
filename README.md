# FITNESS PRO

Мобильное приложение для фитнеса и тренировок. Android + iOS (Flutter).

## Функции

- Каталог упражнений (200+ упражнений по группам мышц)
- Готовые программы тренировок
- Режим тренировки с таймером отдыха
- История тренировок и статистика
- Избранное
- Работа офлайн (SQLite)
- Облачная синхронизация (Supabase)

## Стек

- Flutter 3.24
- Dart
- SQLite (sqflite)
- Supabase (auth + cloud DB)
- GitHub Actions (CI/CD)

## Сборка

### Android
```bash
flutter pub get
flutter build apk --debug
```

### iOS
```bash
flutter pub get
flutter build ios --simulator --no-codesign
```

## Структура

```
lib/
├── main.dart
├── app.dart
├── theme/app_theme.dart
├── models/
│   ├── exercise.dart
│   └── workout.dart
├── services/
│   └── database_service.dart
├── data/
│   └── exercises_data.dart
├── screens/
│   ├── home_screen.dart
│   ├── exercises_screen.dart
│   ├── exercise_detail_screen.dart
│   ├── programs_screen.dart
│   ├── progress_screen.dart
│   └── profile_screen.dart
└── widgets/
```

## Лицензия

MIT
