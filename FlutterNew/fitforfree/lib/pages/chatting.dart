// import 'package:flutter/material.dart';
// import 'package:signalr_netcore/hub_connection.dart';
// import 'package:signalr_netcore/hub_connection_builder.dart';

// class _ChattingPagState extends StatefulWidget {
//   const _ChattingPagState({super.key});

//   @override
//   State<_ChattingPagState> createState() => __ChattingPagStateState();
// }

// class __ChattingPagStateState extends State<_ChattingPagState> {
//   final hubConnection = HubConnectionBuilder()
//       .withUrl('https://your-signalr-hub-url')
//       .build();

//   TextEditingController messageController = TextEditingController();
//   List<String> messages = [];

//   @override
//   void initState() {
//     super.initState();

//     // Connect to the SignalR hub
//     _startHubConnection();

//     // Define an event handler for receiving messages
//     hubConnection.on('ReceiveMessage', _handleReceivedMessage);
//   }

//   void _startHubConnection() async {
//     try {
//       await hubConnection.start();
//       print('SignalR connection started.');
//     } catch (e) {
//       print('Error starting SignalR connection: $e');
//     }
//   }

//   void _handleReceivedMessage(List<Object?> arguments) {
//     Object user = arguments[0] ?? '';
//     Object message = arguments[1] ?? '';

//     setState(() {
//       messages.add('$user: $message');
//     });
//   }

//   void _sendMessage() {
//     String user = 'You'; // Replace with the user's name or identifier
//     String message = messageController.text;

//     // Send the message to the SignalR hub
//     hubConnection.invoke('SendMessage', args: [user, message]);

//     // Clear the text input field
//     messageController.text = '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter Chat with SignalR'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(messages[index]),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Enter your message',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Ensure that the SignalR connection is closed when the app is disposed
//     hubConnection.stop();
//     super.dispose();
//   }
// }