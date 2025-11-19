import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_profile_container.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/helper/theme_name.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  @override
  Widget build(BuildContext context) {
    final searchUserNames = listenableProvider.searchUserList;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: context.primary),
          ),
          onChanged: (value) {
            databaseProvider.searchUserProvider(value);
          },
        ),
      ),
      body: searchUserNames.isEmpty
          ? Center(child: Text("No user found..."))
          : ListView.builder(
              itemCount: searchUserNames.length,
              itemBuilder: (context, index) {
                final user = searchUserNames[index];
                return MyProfileContainer(userProfile: user);
              },
            ),
    );
  }
}
