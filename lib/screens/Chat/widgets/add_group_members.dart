import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:flutter/material.dart';

class AddGroupMemberScreen extends StatefulWidget {
  SocketMethods socketMethods;
  String chatId;
  AddGroupMemberScreen({
    Key? key,
    required this.socketMethods,
    required this.chatId,
  }) : super(key: key);

  @override
  State<AddGroupMemberScreen> createState() => _AddGroupMemberScreenState();
}

class _AddGroupMemberScreenState extends State<AddGroupMemberScreen> {
  late TextEditingController mamberPhoneNumberController;
  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    mamberPhoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    mamberPhoneNumberController.dispose();
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
          'Add Member',
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
                  controller: mamberPhoneNumberController,
                  validator: (phoneNumber) {
                    // final re = RegExp(
                    //     r'/(\+\d{1,3}\s?)?((\(\d{3}\)\s?)|(\d{3})(\s|-?))(\d{3}(\s|-?))(\d{4})(\s?(([E|e]xt[:|.|]?)|x|X)(\s?\d+))?/g');

                    // Iterable<RegExpMatch> hasMatch =
                    //     re.allMatches(phoneNumber.toString());
                    if (phoneNumber != null && phoneNumber.length < 10) {
                      return 'Groupname must have atleast 4 characters ';
                    } else if (phoneNumber != null &&
                        phoneNumber.length >= 10) {
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
                    widget.socketMethods.addGroupMember(
                        phoneNumber: mamberPhoneNumberController.text,
                        chatId: widget.chatId);
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
