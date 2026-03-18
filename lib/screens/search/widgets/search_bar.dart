import 'package:flutter/material.dart';
import '../../../widgets/common/custom_textfield.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Search by username, name, or skills...',
      prefixIcon: Icons.search,
      suffixIcon: controller.text.isNotEmpty ? Icons.clear : null,
      onSuffixTap: () {
        controller.clear();
        onChanged('');
      },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search, 
    );
  }
}