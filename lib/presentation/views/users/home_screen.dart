import 'dart:io';

import 'package:flutter/material.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';
import 'package:machine_test_totalx/core/widgets/alert_dialog.dart';
import 'package:machine_test_totalx/core/widgets/custom_bottomsheet.dart';
import 'package:machine_test_totalx/core/widgets/custom_textfield.dart';
import 'package:machine_test_totalx/presentation/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchcontroller = TextEditingController();
  int selectedAgeCategory = 0;

  void _showAgeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) => AgeBottomSheet(
        selectedAgeCategory: selectedAgeCategory,
        onCategorySelected: (value) {
          setState(() {
            selectedAgeCategory = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leadingWidth: width * 0.5,
        leading: Row(
          children: [
            Icon(Icons.location_on, color: AppColors.white),
            Text("Nilambur", style: TextStyle(color: AppColors.white)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Search by name",
                    controller: searchcontroller,
                    borderradius: 36,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _showAgeFilter,
                  child: Image.asset(
                    "assets/images/filter.png",
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Users Lists"),
            const SizedBox(height: 8),
            Expanded(child: ListView(children: [])),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => const AddUserDialog(),
          );

          if (result != null) {
            final success = await context.read<UserProvider>().addUser(
              name: result['name'],
              age: result['age'],
            );

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User added successfully!")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.read<UserProvider>().errorMessage ??
                        "Failed to add user.",
                  ),
                ),
              );
            }
          }
        },
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
