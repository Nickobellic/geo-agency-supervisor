import 'package:socket_io_client/socket_io_client.dart';
import 'package:geo_agency_mobile/helper/socket_events.dart';
export 'package:socket_io_client/socket_io_client.dart' show socket;

late Socket socket;


  void connectToServer() {
    try {
     
      // Configure socket transports must be specified
      socket = io('http://192.168.1.6:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
     
      // Connect to websocket
      socket.connect();
     
      // Handle socket events
      socket.on('connect', (_) => print("Client ID: $socket.id"));
      socket.on('location', checkLocation);
      //socket.on('typing', handleTyping);
      //socket.on('message', handleMessage);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));

    } catch (e) {
      print(e.toString());
    }

   
}


