import 'package:flutter/material.dart';

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String _selectedItem = 'Option 1'; // Изначально выбранный элемент

  void _onItemSelected(String item) {
    setState(() {
      _selectedItem = item; // Обновляем выбранный элемент
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPickerWidget(
              title: 'Choose an Option',
              hint: _selectedItem, // Подсказка изменяется на выбранный элемент
              items: ['Option 1', 'Option 2', 'Option 3'],
              selectedItem: _selectedItem,
              onItemSelected: _onItemSelected, // Передаем callback функцию
            ),
            SizedBox(height: 20),
            Text(
              'Selected Item: $_selectedItem',
            ), // Отображаем выбранный элемент
          ],
        ),
      ),
    );
  }
}

class CustomPickerWidget extends StatelessWidget {
  final String title;
  final String hint;
  final List<String> items;
  final String selectedItem;
  final Function(String) onItemSelected;

  const CustomPickerWidget({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Вызов модального окна при нажатии
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return PickerModal(
                  items: items,
                  hint: hint,
                  selectedItem: selectedItem,
                  onItemSelected: onItemSelected,
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(14.95),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hint, // Подсказка обновляется на основе выбранного элемента
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'SF-Pro',
                    color: Colors.black,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF9D9D9D)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PickerModal extends StatefulWidget {
  final List<String> items;
  final String hint;
  final String selectedItem;
  final Function(String) onItemSelected; // Callback для уведомления о выборе

  const PickerModal({
    super.key,
    required this.items,
    required this.hint,
    required this.selectedItem,
    required this.onItemSelected, // Принимаем callback
  });

  @override
  State<PickerModal> createState() => _PickerModalState();
}

class _PickerModalState extends State<PickerModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 250,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.95),
          topRight: Radius.circular(14.95),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hint,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(widget.items[index]),
                  onTap: () {
                    widget.onItemSelected(
                      widget.items[index],
                    ); // Вызываем callback с выбранным элементом
                    Navigator.pop(
                      context,
                      widget.items[index],
                    ); // Закрываем модальное окно
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
