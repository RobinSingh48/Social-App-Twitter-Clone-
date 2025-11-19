import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/database/database_provider.dart';
import 'package:social_app/helper/textstyle.dart';
import 'package:social_app/helper/theme_name.dart';

class BlockeduserPage extends StatefulWidget {
  const BlockeduserPage({super.key});

  @override
  State<BlockeduserPage> createState() => _BlockeduserPageState();
}

class _BlockeduserPageState extends State<BlockeduserPage> {
  late final databaseProvider = Provider.of<DatabaseServiceProvider>(
    context,
    listen: false,
  );
  late final listenableProvider = Provider.of<DatabaseServiceProvider>(context);

  Future<void> loadBLockUsers() async {
    await databaseProvider.getBlockUsersProvider();
  }

  Future<void> unblockUser(String userId,) async {
    await databaseProvider.unBlockUserProvider(userId);
  }

  @override
  void initState() {
    loadBLockUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blockUsers = listenableProvider.blockedUsers;
    return Scaffold(
      appBar: AppBar(
        title: Text("BLOCKED USER", style: boldText()),
        centerTitle: true,
      ),
      body: blockUsers.isEmpty
          ? Center(
              child: Text(
                "Empty Block List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 22,
                ),
              ),
            )
          : ListView.builder(
              itemCount: blockUsers.length,
              itemBuilder: (context, index) {
                final blockUser = blockUsers[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    color: context.secondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(child: Icon(Icons.person, size: 28)),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${blockUser!.user}",
                            style: TextStyle(
                              color: context.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            blockUser.username,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Spacer(),
                      //Unblock button
                      GestureDetector(
                        onTap: () {
                          unblockUser(blockUser.uid,);
                        },
                        child: Icon(
                          Icons.block,
                          size: 40,
                          color: context.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
