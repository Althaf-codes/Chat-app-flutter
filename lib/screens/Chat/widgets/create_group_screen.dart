// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  SocketMethods socketMethods;
  CreateGroupScreen({
    Key? key,
    required this.socketMethods,
  }) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late TextEditingController groupNameController;
  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    groupNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 2, 74, 5),
        title: const Text(
          'Create New Group',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formGlobalKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 7,
                  offset: Offset(1, 10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 7,
                    offset: Offset(10, 1),
                    color: Colors.grey.withOpacity(0.2))
              ]),
              child: TextFormField(
                  cursorColor: const Color.fromARGB(255, 29, 201, 192),
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(
                          color: const Color.fromARGB(255, 29, 201, 192)),
                      hintText: 'Enter Group Name',
                      labelText: 'Group Name',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Colors.red,
                            style: BorderStyle.solid,
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 29, 201, 192),
                            style: BorderStyle.solid,
                            width: 1),
                      ),
                      focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                            width: 5),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(
                          Icons.group,
                          color: const Color.fromARGB(255, 29, 201, 192),
                        ),
                        onPressed: () {},
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  controller: groupNameController,
                  validator: (groupname) {
                    // final re = RegExp(
                    //     r'/(\+\d{1,3}\s?)?((\(\d{3}\)\s?)|(\d{3})(\s|-?))(\d{3}(\s|-?))(\d{4})(\s?(([E|e]xt[:|.|]?)|x|X)(\s?\d+))?/g');

                    // Iterable<RegExpMatch> hasMatch =
                    //     re.allMatches(phoneNumber.toString());
                    if (groupname != null && groupname.length <= 3) {
                      return 'Groupname must have atleast 4 characters ';
                    } else if (groupname != null && groupname.length > 3) {
                      return null;
                    }
                  }),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Builder(builder: (context) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  if (formGlobalKey.currentState!.validate()) {
                    formGlobalKey.currentState!.save();
                    widget.socketMethods
                        .createGroup(groupName: groupNameController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                ));
          }),
        ]),
      ),
    );
  }
}
