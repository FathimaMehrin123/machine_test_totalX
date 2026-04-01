import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';
import 'package:machine_test_totalx/core/widgets/custom_textfield.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        pickedImage = File(picked.path);
      });
    }
  }

  void _showImageSourceSheet() {
    showCupertinoDialog(
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.gallery);
                },
                child: const Text("Choose From Gallery"),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.camera);
                },
                child: const Text("Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      backgroundColor: AppColors.white,
      content: SizedBox(
        height: height * 0.45,
    width: 339,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add A New User",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),
            
                // Profile Image Picker
                Center(
                  child: InkWell(
                    onTap: _showImageSourceSheet,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: pickedImage != null
                              ? FileImage(pickedImage!) as ImageProvider
                              :  AssetImage("assets/images/placeholder.jpg"),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.grey,
                            child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
            
                // Name Field
                const Text(" Name", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
             CustomTextField( controller: nameController,borderradius: 8),
                const SizedBox(height: 8),
            
                // Age Field
                const Text(" Age", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                          CustomTextField( controller: ageController,borderradius: 8,),
            
                const SizedBox(height: 8),
            
                // Phone Field
                const Text(" Phone", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
              
                const SizedBox(height: 12),
            
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: height * 0.04,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          color: Color(0xFFCCCCCC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text("Cancel")),
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    InkWell(
                      onTap: () {
                        // Pass data back to parent
                        Navigator.pop(context, {
                          'name': nameController.text.trim(),
                          'age': ageController.text.trim(),
                         
                          'image': pickedImage,
                        });
                      },
                      child: Container(
                        height: height * 0.04,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          color:Color(0xFF1782FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text("Save", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}