import 'package:flutter/material.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';
import 'package:machine_test_totalx/core/widgets/custom_text.dart';

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
      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      height: height * 0.3,
      width: width * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: CustomText("Sort", fontWeight: FontWeight.w600),
          ),
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
              const CustomText("All",fontSize: 12,fontWeight: FontWeight.w500,),
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
              const CustomText("Age: Elder",fontSize: 12,fontWeight: FontWeight.w500,),
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
              const CustomText("Age: Younger",fontSize: 12,fontWeight: FontWeight.w500),
            ],
          ),
        ],
      ),
    );
  }
}
