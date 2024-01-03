import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const UserSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    String searchResult = '';

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 34.0,
        child: TextFormField(
          restorationId: 'search_userid',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffFAE094), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffFD3F2A), width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            labelText: "请输入用户ID",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                onSearch(searchResult);
              },
            ),
          ),
          onChanged: (value) {
            searchResult = value;
          },
          maxLines: 1,
        ),
      ),
    );
  }
}
