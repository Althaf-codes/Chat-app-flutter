import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  IO.Socket? socket;

  static SocketClient? _instance;

  SocketClient() {}
  SocketClient._internal(String uid) {
    print("the uid here3 is ${uid}");

    socket = IO.io(
        "http://localhost:8080",
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({'authorization': uid})
            .enableForceNew()
            .build());

    socket!.connect();
    socket!.onReconnectAttempt((data) => print('its onReconnectAttempt'));
    socket!.onReconnecting((data) => print('its onReconnecting'));
    socket!.onConnecting((data) => print('its onConnecting'));

    socket!.onReconnect((_) {
      print("its OnReconnect");
    });
    socket!.onConnect((_) {
      print('Connection established');
    });
    // socket!.on('all-chats', (data) {
    //   print('The all-chats socketio data is ${data}');
    // });
    socket!.onDisconnect((data) {
      print("its in ondisconnect");

      print('Connection Disconnected');
      socket!.disconnect();
      socket!.clearListeners();
    });

    socket!.onConnectError((err) {
      print("its in onconnect");
      socket!.emit('disconnect');
      socket!.disconnect();
      socket!.clearListeners();
      socket!.connect();
      print(err);
    });

    socket!.onError((err) {
      print("its in onerror");

      print(err);
    });
  }

  static SocketClient instance({required String uid}) {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance ??= SocketClient._internal(uid);
      return _instance!;
    }
  }
}



// initSocket() {
//     final String uid =
//         Provider.of<AuthMethods>(context, listen: false).user.uid;
//     print("the uid is ${uid}");

//     socket = IO.io(
//         "http://localhost:8080",
//         OptionBuilder()
//             .setTransports(['websocket'])
//             .disableAutoConnect()
//             .setAuth({'authorization': uid})
//             .build());

//     socket.connect();
//     socket.onConnect((_) {
  //     print('Connection established');
  //   });

  //   socket.onDisconnect((_) => print('Connection Disconnected'));
  //   socket.onConnectError((err) => print(err));
  //   socket.onError((err) => print(err));
  // }