import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';
import 'package:fitness_pro/screens/nutrition_screen.dart';
import 'package:fitness_pro/data/exercises_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Атлет';
  int _age = 25;
  double _weight = 70;
  double _height = 175;
  String _goal = 'Поддержать форму';
  bool _notificationsEnabled = true;
  String _language = 'Русский';
  String _theme = 'Тёмная';
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 3),
                color: AppColors.card,
              ),
              child: const Icon(Icons.person, color: AppColors.gold, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              _userName,
              style: const TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _isLoggedIn ? 'Аккаунт подключён' : 'Гость',
              style: TextStyle(color: _isLoggedIn ? AppColors.success : AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Возраст', '$_age'),
                  _buildStat('Вес', '${_weight.round()} кг'),
                  _buildStat('Рост', '${_height.round()} см'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account section
            _buildSection('Аккаунт', [
              _buildMenuItem(Icons.login, _isLoggedIn ? 'Выйти' : 'Войти / Зарегистрироваться', () {
                if (_isLoggedIn) {
                  setState(() => _isLoggedIn = false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вы вышли из аккаунта')));
                } else {
                  _showAuthDialog(context);
                }
              }),
              _buildMenuItem(Icons.sync, 'Синхронизация данных', () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Данные синхронизированы')));
              }),
            ]),
            const SizedBox(height: 16),
            _buildSection('Настройки', [
              _buildMenuItem(Icons.notifications, 'Уведомления', () {
                setState(() => _notificationsEnabled = !_notificationsEnabled);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_notificationsEnabled ? 'Уведомления включены' : 'Уведомления выключены'),
                ));
              }, trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
                activeColor: AppColors.gold,
              )),
              _buildMenuItem(Icons.restaurant, 'Питание и калории', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionScreen()));
              }),
              _buildMenuItem(Icons.timer, 'Таймер отдыха', () {
                _showRestTimerDialog(context);
              }),
              _buildMenuItem(Icons.language, 'Язык', () {
                _showLanguageDialog(context);
              }, trailing: Text(_language, style: TextStyle(color: AppColors.grey, fontSize: 13))),
              _buildMenuItem(Icons.dark_mode, 'Тема', () {
                _showThemeDialog(context);
              }, trailing: Text(_theme, style: TextStyle(color: AppColors.grey, fontSize: 13))),
            ]),
            const SizedBox(height: 16),
            _buildSection('Данные', [
              _buildMenuItem(Icons.download, 'Экспорт данных', () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Данные экспортированы')));
              }),
              _buildMenuItem(Icons.delete, 'Очистить историю', () {
                _showClearHistoryDialog(context);
              }),
            ]),
            const SizedBox(height: 16),
            _buildSection('О приложении', [
              _buildMenuItem(Icons.info, 'О FITNESS PRO', () {
                _showAboutDialog(context);
              }),
              _buildMenuItem(Icons.star, 'Оценить приложение', () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Спасибо за оценку!')));
              }),
              _buildMenuItem(Icons.share, 'Поделиться', () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка скопирована')));
              }),
            ]),
            const SizedBox(height: 24),

            Text('FITNESS PRO v1.0.0', style: TextStyle(color: AppColors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: AppColors.grey, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gold),
      title: Text(title, style: const TextStyle(color: AppColors.white, fontSize: 15)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }

  void _showAuthDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Вход / Регистрация', style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              style: const TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Авторизация через Supabase будет подключена в следующей версии.',
              style: TextStyle(color: AppColors.grey, fontSize: 11),
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
              setState(() => _isLoggedIn = true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вход выполнен')));
            },
            child: const Text('Войти'),
          ),
        ],
      ),
    );
  }

  void _showRestTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Таймер отдыха по умолчанию', style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [30, 60, 90, 120].map((sec) => ListTile(
            title: Text('$sec сек', style: const TextStyle(color: AppColors.white)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Таймер: $sec сек')));
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = ['Русский', 'English', 'Español', 'Deutsch'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Язык', style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) => ListTile(
            title: Text(lang, style: const TextStyle(color: AppColors.white)),
            trailing: lang == _language ? const Icon(Icons.check, color: AppColors.gold) : null,
            onTap: () {
              setState(() => _language = lang);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themes = ['Тёмная', 'Светлая', 'Системная'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Тема', style: TextStyle(color: AppColors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themes.map((t) => ListTile(
            title: Text(t, style: const TextStyle(color: AppColors.white)),
            trailing: t == _theme ? const Icon(Icons.check, color: AppColors.gold) : null,
            onTap: () {
              setState(() => _theme = t);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Очистить историю?', style: TextStyle(color: AppColors.white)),
        content: Text('Все записи о тренировках будут удалены.', style: TextStyle(color: AppColors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('История очищена')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('О FITNESS PRO', style: TextStyle(color: AppColors.white)),
        content: Text(
          'FITNESS PRO — твой персональный тренер.\n\n'
          'Версия: 1.0.0\n'
          'Упражнений: ${allExercises.length}\n'
          'Программ: 10\n\n'
          'Разработано с ❤️ для спортсменов.',
          style: TextStyle(color: AppColors.grey),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
