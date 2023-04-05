import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'viewContacts.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;

  const ChatScreen({Key? key, required this.chatId, required this.title})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final User _user;

  // Index of the selected message (-1 if none is selected)
  int _selectedMessageIndex = -1;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  // Send a new message to Firestore
  void _sendMessage() {
    final String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'senderId': _user.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appbarcl = const Color(0xFFF8EDEB);

    return Scaffold(
      backgroundColor: appbarcl,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appbarcl,
        title: Text(widget.title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContactsScreen())),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data?.docs[index];
                        final String text = message?['text'];
                        final String senderId = message?['senderId'];
                        final int timestamp = message?['timestamp'];
                        final bool isMe = senderId == _user.uid;

                        final messageTime =
                            DateTime.fromMillisecondsSinceEpoch(timestamp)
                                .toLocal()
                                .toString()
                                .substring(0, 16);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedMessageIndex == index) {
                                _selectedMessageIndex =
                                    -1; // Collapse the message box
                              } else {
                                _selectedMessageIndex = index;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe ? Colors.blue : Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: isMe
                                          ? Radius.circular(10.0)
                                          : Radius.zero,
                                      bottomRight: isMe
                                          ? Radius.zero
                                          : Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                if (_selectedMessageIndex == index)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 4.0,
                                    ),
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      messageTime,
                                      style: TextStyle(
                                        color: isMe
                                            ? Colors.black54
                                            : Colors.black54,
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
