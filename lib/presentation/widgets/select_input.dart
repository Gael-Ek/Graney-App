import 'package:flutter/material.dart';

class SelectInput extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  const SelectInput({
    super.key,
    required this.label,
    required this.options,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue; // puede empezar vacío o con valor
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text("Selecciona una opción"),
        ),
        ...widget.options.map((opcion) {
          return DropdownMenuItem(value: opcion, child: Text(opcion));
        }),
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
