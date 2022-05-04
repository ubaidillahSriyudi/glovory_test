import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopulerSearch extends ConsumerWidget {
  const PopulerSearch({Key? key}) : super(key: key);
  static const List<String> popularSearch = [
    'Chess',
    'Gundam Action Figure'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = Column(
      children: [
        Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: ChoiceChip(
          label: Text('text'),
          selected: true,
          backgroundColor: Colors.white,
          // labelStyle: GoogleFonts.montserrat(
          //   color: const Color(0xFF1993AB),
          // ),
          side: const BorderSide(color: Color(0xFF1993AB), width: 1),
          selectedColor: const Color(0xFF1993AB).withOpacity(0.1),
          onSelected: (value) {
            // setState(
            //   () {
            //     _selectedCategory = i;
            //     onSelect(categories[_selectedCategory!]);
            //   },
            // );
          },
        ),
      )
      ],
    );

    // final b = 

    return a;
  }
}