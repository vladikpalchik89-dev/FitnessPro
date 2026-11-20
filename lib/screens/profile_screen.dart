import 'package:flutter/material.dart';
import 'package:fitness_pro/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            const Text(
              'Атлет',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Начинающий',
              style: TextStyle(color: AppColors.grey, fontSize: 14),
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
                  _buildStat('Возраст', '—'),
                  _buildStat('Вес', '— кг'),
                  _buildStat('Рост', '— см'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings sections
            _buildSection('Аккаунт', [
              _buildMenuItem(Icons.login, 'Войти / Зарегистрироваться', () {}),
              _buildMenuItem(Icons.sync, 'Синхронизация данных', () {}),
            ]),
            const SizedBox(height: 16),
            _buildSection('Настройки', [
              _buildMenuItem(Icons.notifications, 'Уведомления', () {}),
              _buildMenuItem(Icons.timer, 'Таймер отдыха', () {}),
              _buildMenuItem(Icons.dark_mode, 'Тема', () {}),
              _buildMenuItem(Icons.language, 'Язык', () {}),
            ]),
            const SizedBox(height: 16),
            _buildSection('Данные', [
              _buildMenuItem(Icons.download, 'Экспорт данных', () {}),
              _buildMenuItem(Icons.delete, 'Очистить историю', () {}),
            ]),
            const SizedBox(height: 16),
            _buildSection('О приложении', [
              _buildMenuItem(Icons.info, 'О FITNESS PRO', () {}),
              _buildMenuItem(Icons.star, 'Оценить приложение', () {}),
              _buildMenuItem(Icons.share, 'Поделиться', () {}),
            ]),
            const SizedBox(height: 24),

            // Version
            Text(
              'FITNESS PRO v1.0.0',
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
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

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gold),
      title: Text(title, style: const TextStyle(color: AppColors.white, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
