import 'package:flutter/material.dart';
import 'package:tiktok/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:tiktok/models/user.dart';
import 'package:tiktok/views/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreen createState() => _SearchScreen();
}
class _SearchScreen extends State<SearchScreen> {
  
  List<User> searchedUsers = [];

  SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TextFormField(
          decoration: const InputDecoration(
            filled: false,
            hintText: 'Search',
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            )
          ),
          onFieldSubmitted: (value) => { 
            searchController.searchUser(value).then((users) => {
              setState(() {
                searchedUsers = users;
              }),
            }),
          },
        ),
      ),
      body: searchedUsers.isEmpty ? (
        const Center(
          child: Text(
            'Search for users',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ) : (
        ListView.builder(
          itemCount: searchedUsers.length,
          itemBuilder: (context, index) {
            User user = searchController.searchedUsers[index];
            return InkWell(
              onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      ),
                    ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.profilePhoto,
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        )
      ),
    );
  }

}