import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  Function toggleView;
  SigninScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  // bool islogged = false;

  @override
  void initState() {
    // getSellerData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    phoneNumberController.dispose();
  }

  // void getSellerData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     islogged = prefs.getBool("isUserRegistered")!;
  //     print("the islogged in 1 is $islogged");
  //   });
  //   if (islogged == null) {
  //     setState(() {
  //       islogged = false;
  //       print('he islogged in 2 $islogged');
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.zero,
      child: Scaffold(
        backgroundColor:
            Colors.white, // const Color.fromARGB(255, 232, 240, 236),
        //backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formGlobalKey,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //   TextField(controller: usernamecontroller),
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.30,
                  //   width: MediaQuery.of(context).size.width * 0.90,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12), color: pinkcolor),
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome Back!,",
                              style: TextStyle(
                                  // shadows: [
                                  //   Shadow(
                                  //       color:
                                  //           Color.fromARGB(255, 29, 201, 192),
                                  //       offset: Offset.zero,
                                  //       blurRadius: 4),
                                  // ],
                                  color: Color.fromARGB(255, 29, 201, 192),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 15.0, right: 15.0, top: 15.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(boxShadow: [
                  //       BoxShadow(
                  //           blurRadius: 10,
                  //           spreadRadius: 7,
                  //           offset: Offset(1, 10),
                  //           color: Colors.grey.withOpacity(0.2))
                  //     ]),
                  //     child: TextFormField(
                  //       cursorColor: const Color.fromARGB(255, 29, 201, 192),
                  //       decoration: InputDecoration(
                  //           labelStyle: const TextStyle(
                  //               color: const Color.fromARGB(255, 29, 201, 192)),
                  //           hintText: 'Enter your Email',
                  //           labelText: 'Email',
                  //           enabledBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(20),
                  //               borderSide: BorderSide.none),
                  //           focusedErrorBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //             borderSide: const BorderSide(
                  //                 color: Colors.red,
                  //                 style: BorderStyle.solid,
                  //                 width: 2),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             gapPadding: 10,
                  //             borderRadius: BorderRadius.circular(20),
                  //             borderSide: const BorderSide(
                  //                 color:
                  //                     const Color.fromARGB(255, 29, 201, 192),
                  //                 style: BorderStyle.solid,
                  //                 width: 1),
                  //           ),
                  //           focusColor: Colors.white,
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //             borderSide: const BorderSide(
                  //                 color: Colors.transparent,
                  //                 style: BorderStyle.solid,
                  //                 width: 5),
                  //           ),
                  //           prefixIconColor:
                  //               const Color.fromARGB(255, 29, 201, 192),
                  //           prefixIcon: IconButton(
                  //             icon: const Icon(
                  //               Icons.email,
                  //               color: Color.fromARGB(255, 29, 201, 192),
                  //             ),
                  //             onPressed: () {},
                  //           ),
                  //           fillColor: Colors.white,
                  //           filled: true),
                  //       controller: emailcontroller,
                  //       keyboardType: TextInputType.emailAddress,
                  //       validator: (email) {
                  //         if (email!.isEmpty) {
                  //           return "This Feild is required";
                  //         } else if (!RegExp(
                  //                 r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                  //             .hasMatch(email.toString())) {
                  //           return "Enter a valid email address";
                  //         } else {
                  //           return null;
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0),
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
                                  color:
                                      const Color.fromARGB(255, 29, 201, 192)),
                              hintText: 'Enter your PhoneNumber',
                              labelText: 'PhoneNumber',
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
                                    color:
                                        const Color.fromARGB(255, 29, 201, 192),
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
                                  Icons.phone,
                                  color:
                                      const Color.fromARGB(255, 29, 201, 192),
                                ),
                                onPressed: () {},
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          controller: phoneNumberController,
                          validator: (phoneNumber) {
                            // final re = RegExp(
                            //     r'/(\+\d{1,3}\s?)?((\(\d{3}\)\s?)|(\d{3})(\s|-?))(\d{3}(\s|-?))(\d{4})(\s?(([E|e]xt[:|.|]?)|x|X)(\s?\d+))?/g');

                            // Iterable<RegExpMatch> hasMatch =
                            //     re.allMatches(phoneNumber.toString());
                            if (phoneNumber != null &&
                                phoneNumber.length < 10) {
                              return 'Enter a valid phonenumber ';
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () async {
                          if (formGlobalKey.currentState!.validate()) {
                            formGlobalKey.currentState!.save();

                            await context.read<AuthMethods>().phoneSignIn(
                                  context,
                                  phoneNumber: phoneNumberController.text,
                                );
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ));
                  }),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          wordSpacing: 2,
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          widget.toggleView();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const SigninScreen()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 29, 201, 192)),
                        ),
                      )
                    ],
                  ),

                  // TextField(
                  //   controller: passwordcontroller,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
