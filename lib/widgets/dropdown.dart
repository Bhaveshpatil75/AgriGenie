//
// import 'package:flutter/material.dart';
//
// class Dropdown extends StatefulWidget {
//   final List<String> list;
//   final String field;
//
//   Dropdown({super.key, required this.list, required this.field});
//
//   @override
//   State<Dropdown> createState() => _DropdownState();
// }
//
// class _DropdownState extends State<Dropdown> {
//   late String dropdownValue;
//   @override
//   void initState() {
//     super.initState();
//     // Initialize dropdownValue with the first item in the list or a default value
//     dropdownValue = widget.list.isNotEmpty ? widget.list[0] : '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     details[widget.field] = dropdownValue;
//     return DropdownButton<String>(
//       value: dropdownValue.isNotEmpty ? dropdownValue : null,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? value) {
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       items: widget.list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
