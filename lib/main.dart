import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String message = 'waiting message from socket';
  IO.Socket socket = IO.io('http://localhost:3001/feeder',
      OptionBuilder().setTransports(['websocket']).build());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket IO'),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onConnect,
            child: const Text('Connect'),
          ),
          ElevatedButton(
            onPressed: onCallEvent,
            child: const Text('Call Event'),
          ),
          ElevatedButton(
            onPressed: onDisconnect,
            child: const Text('Disconnet'),
          ),
        ],
      )),
    );
  }

  void onConnect() {
    socket.connect();
  }

  void onCallEvent() {
    socket.emit('message', 'test');
    socket.on('message', (data) {
      print(data);
      setState(() {
        message = data;
      });
    });
  }

  void onDisconnect() {
    socket.disconnect();
  }
}
