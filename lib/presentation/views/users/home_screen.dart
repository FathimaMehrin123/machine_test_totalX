import 'package:flutter/material.dart';
import 'package:machine_test_totalx/core/constants/appcolors.dart';
import 'package:machine_test_totalx/core/widgets/alert_dialog.dart';
import 'package:machine_test_totalx/core/widgets/custom_bottomsheet.dart';
import 'package:machine_test_totalx/core/widgets/custom_text.dart';
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
  final ScrollController _scrollController = ScrollController();
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
          context.read<UserProvider>().sortUsers(value);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getUsers();
    });

    searchcontroller.addListener(() {
      context.read<UserProvider>().searchUsers(searchcontroller.text);
    });

    // Detect scroll to bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<UserProvider>().loadMoreUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            SizedBox(width: 3),
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
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.filteredUsers.isEmpty) {
                    return const Center(child: Text("No users found."));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        provider.filteredUsers.length +
                        (provider.isFetchingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.filteredUsers.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final user = provider.filteredUsers[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                user.profileUrl != null &&
                                    user.profileUrl!.isNotEmpty
                                ? NetworkImage(user.profileUrl!,)
                                      as ImageProvider
                                : const AssetImage(
                                    "assets/images/placeholder.jpg",
                                    
                                  ),
                            radius: 28,
                            child: Icon(Icons.person),
                          ),
                          title: CustomText(
                            user.name,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            'Age: ${user.age}',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
              age: int.parse(result['age']),
              image: result['image'],
            );

            if (success) {
              context.read<UserProvider>().getUsers();
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
