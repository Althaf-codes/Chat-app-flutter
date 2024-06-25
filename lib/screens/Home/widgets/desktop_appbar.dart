import 'package:chatappp_socketio/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopChatAppBar extends StatelessWidget {
  const DesktopChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10.0),
      color: const Color.fromARGB(255, 2, 74, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [ 
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              const Text(
                'Chats',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.grey),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
