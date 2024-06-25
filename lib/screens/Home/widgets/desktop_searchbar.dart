import 'package:flutter/material.dart';

class DesktopSearchBar extends StatelessWidget {
  const DesktopSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 60,
          width: 350,
          // width: MediaQuery.of(context).size.width * 0.45,
          // height: MediaQuery.of(context).size.height * 0.06,
          // width: MediaQuery.of(context).size.width * 0.25,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black45,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
              hintText: 'Search or start new chat',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            ))
      ],
    );
  }
}
