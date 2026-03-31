import 'package:flutter/material.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';

class AgeBottomSheet extends StatefulWidget {
  final int selectedAgeCategory;
  final Function(int) onCategorySelected;

  const AgeBottomSheet({
    super.key,
    required this.selectedAgeCategory,
    required this.onCategorySelected,
  });

  @override
  State<AgeBottomSheet> createState() => _AgeBottomSheetState();
}

class _AgeBottomSheetState extends State<AgeBottomSheet> {
  late int selectedAgeCategory;

  @override
  void initState() {
    super.initState();
    selectedAgeCategory = widget.selectedAgeCategory;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.3,
      width: width * 1,
      color: AppColors.white,
      child: Column(
        children: [
          Row(
            children: [
              Radio<int>(
                value: 0,
                groupValue: selectedAgeCategory,
                onChanged: (value) {
                  setState(() => selectedAgeCategory = value!);
                  widget.onCategorySelected(value!);
                  Navigator.pop(context);
                },
              ),
              const Text("All"),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: selectedAgeCategory,
                onChanged: (value) {
                  setState(() => selectedAgeCategory = value!);
                  widget.onCategorySelected(value!);
                  Navigator.pop(context);
                },
              ),
              const Text("Age: Elder"),
            ],
          ),
          Row(
            children: [
              Radio<int>(
                value: 2,
                groupValue: selectedAgeCategory,
                onChanged: (value) {
                  setState(() => selectedAgeCategory = value!);
                  widget.onCategorySelected(value!);
                  Navigator.pop(context);
                },
              ),
              const Text("Age: Younger"),
            ],
          ),
        ],
      ),
    );
  }
}
