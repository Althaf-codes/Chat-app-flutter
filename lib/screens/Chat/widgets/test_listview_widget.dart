import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TestListView extends StatefulWidget {
  const TestListView({super.key});

  @override
  State<TestListView> createState() => _TestListViewState();
}

class _TestListViewState extends State<TestListView> {
  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  ScrollController readMessageScrollController = ScrollController();
  ScrollController singlechildScrollController = ScrollController();
  ScrollController unreadMessageController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // if(unreadMessageController.)
      readMessageScrollController
          .jumpTo(readMessageScrollController.position.maxScrollExtent);
    });
  }

  // void _scrollToUnreadMessages() {
  //   final RenderBox renderBox =
  //       _getRenderBoxForContext(context, readMessageScrollController);
  //   final double offset = renderBox.localToGlobal(Offset.zero).dy;

  //   singlechildScrollController.position.ensureVisible(
  //     renderBox,
  //     alignment: 0.5,
  //     duration: Duration(milliseconds: 500),
  //   );
  // }

  // RenderBox _getRenderBoxForContext(
  //     BuildContext context, ScrollController controller) {
  //   final RenderBox renderBox = context.findRenderObject()! as RenderBox;
  //   return renderBox;
  // }

  @override
  void dispose() {
    readMessageScrollController.dispose();
    singlechildScrollController.dispose();
    unreadMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test list view'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        controller: singlechildScrollController,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                controller: readMessageScrollController,
                shrinkWrap: true,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      // SchedulerBinding.instance.addPostFrameCallback((_) {
                      //   singlechildScrollController.jumpTo(
                      //       readMessageScrollController
                      //           .position.maxScrollExtent);
                      // });
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Index No: ${index + 1}'),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 50,
                    // width: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      'Unread Messages,',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListView.builder(
                    controller: unreadMessageController,
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return sentMessage(
                          context: context,
                          message: "Unread msg No:${index + 1}",
                          sentAt: "11.44",
                          isSeen: true);
                    },
                  ),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.2,
              // height: 300,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: _messageController,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          //   setState(() {
                          //     isShowSendButton = true;
                          //   });
                          // } else {
                          //   setState(() {
                          //     isShowSendButton = false;
                          //   });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.gif,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        suffixIcon: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        hintText: 'Type a message!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF128C7E),
                      radius: 25,
                      child: GestureDetector(
                        child: Icon(
                          // isShowSendButton
                          Icons.send,
                          // : isRecording
                          //     ? Icons.close
                          //     : Icons.mic,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // sendTextMessage(
                          //   chatId: widget.chatdetails.id,
                          //   content: _messageController.text,
                          //   attachment:
                          //       Attachment(url: '', localPath: '', mimeType: ''),
                          // );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row sentMessage({
    required BuildContext context,
    required String message,
    required String sentAt,
    required bool isSeen,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
              minWidth: MediaQuery.of(context).size.width * 0.20,
            ),
            decoration: BoxDecoration(
                color: Color(0xffDCF8C6),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Wrap(
              verticalDirection: VerticalDirection.down,
              alignment: WrapAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.005),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  child: Text(
                    "The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.006,
                      left: MediaQuery.of(context).size.width * 0.015),
                  //alignment: Alignment.bottomRight,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.20,
                  ),
                  child: Text(
                    'Yesterday',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.006),
                  child: Icon(
                    Icons.done_all,
                    size: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.width * 0.004,
            ),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.015,
                right: MediaQuery.of(context).size.width * 0.015,
                top: MediaQuery.of(context).size.width * 0.015),
          ),
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
