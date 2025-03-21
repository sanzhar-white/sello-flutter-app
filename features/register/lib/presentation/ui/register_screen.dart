import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import 'package:go_router/go_router.dart';

// Основной экран регистрации
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRegion = '';
  String _selectedCity = '';
  bool allCorrect = false;

  // Проверка ввода на корректность
  // Проверка ввода на корректность
  bool _isInputValid() {
    return _surnameController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _selectedRegion.isNotEmpty &&
        _selectedCity.isNotEmpty;
  }

  // Обновление состояния кнопки в зависимости от правильности ввода
  void _checkAndUpdateState() {
    setState(() {
      allCorrect = _isInputValid();
    });
  }

  // Метод для отображения корректного текста или хинта
  String _getDisplayTextOrHint(String inputText, String hint) {
    return inputText.isNotEmpty ? inputText : hint;
  }

  // Метод для получения цвета кнопки
  Color _getButtonColor() {
    return allCorrect
        ? const Color(0xFF2B654D)
        : const Color.fromARGB(255, 143, 185, 167);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120, width: double.infinity),
            const Text(
              'Регистрация в SELO',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 50),

            // Поля для ввода данных
            CustomTextFieldWidget(
              title: 'Фамилия',
              hintText: _getDisplayTextOrHint(
                _surnameController.text,
                "Пример: Санжаров",
              ),
              controller: _surnameController,
              onChanged: (value) => _checkAndUpdateState(),
            ),
            const SizedBox(height: 16),

            CustomTextFieldWidget(
              title: 'Имя',
              hintText: _getDisplayTextOrHint(
                _nameController.text,
                "Пример: Санжар",
              ),
              controller: _nameController,
              onChanged: (value) => _checkAndUpdateState(),
            ),
            const SizedBox(height: 16),

            // Модальное окно для выбора местоположения
            CustomPickerWidget(
              title: 'Местоположение',
              hint: _getDisplayTextOrHint(_selectedRegion, 'Выберите область'),
              items: const ['Алматинская', 'Карагандинская', 'ЮКО'],
              selectedItem: _selectedRegion,
              onItemSelected: (String item) {
                setState(() {
                  _selectedRegion = item;
                  _checkAndUpdateState();
                });
              },
            ),
            const SizedBox(height: 16),

            CustomPickerWidget(
              title: 'Населенный пункт',
              hint: _getDisplayTextOrHint(
                _selectedCity,
                'Выберите населенный пункт',
              ),
              items: const ['Алматы', 'Астана', 'Шымкент'],
              selectedItem: _selectedCity,
              onItemSelected: (String item) {
                setState(() {
                  _selectedCity = item;
                  _checkAndUpdateState();
                });
              },
            ),
            const SizedBox(height: 16),

            CustomTextFieldWidget(
              title: 'Номер Телефона',
              hintText: _getDisplayTextOrHint(
                _phoneController.text,
                'Пример: +7 7XX XXX XX XX',
              ),
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              onChanged: (value) => _checkAndUpdateState(),
            ),
            const Spacer(), // Расширение, чтобы кнопка была внизу
            // Кнопка "Далее"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    allCorrect
                        ? () {
                          context.go('/phonecode/${_phoneController.text}');
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.95),
                  ),
                ),
                child: const Text(
                  'Далее',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Отступ от нижней части экрана
          ],
        ),
      ),
    );
  }
}
