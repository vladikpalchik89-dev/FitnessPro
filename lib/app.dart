import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/screens/home_screen.dart';
import 'package:fitness_pro/screens/exercises_screen.dart';
import 'package:fitness_pro/screens/programs_screen.dart';
import 'package:fitness_pro/screens/progress_screen.dart';
import 'package:fitness_pro/screens/profile_screen.dart';

class FitnessProApp extends StatelessWidget {
  const FitnessProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FITNESS PRO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExercisesScreen(),
    ProgramsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Упражнения',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Программы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Прогресс',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
