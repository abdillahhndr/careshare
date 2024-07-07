import 'package:careshareapp2/utils/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumChatScreen extends StatefulWidget {
  final int forumId;
  final String userId;

  ForumChatScreen({required this.forumId, required this.userId});

  @override
  _ForumChatScreenState createState() => _ForumChatScreenState();
}

class _ForumChatScreenState extends State<ForumChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String id = "", username = "", address = "";

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await Provider.of<ApiService>(context, listen: false).sendMessage(
          widget.forumId,
          widget.userId,
          _messageController.text,
        );
        _messageController.clear();
        setState(() {}); // Refresh the chat messages
        _scrollToBottom(); // Scroll to the bottom after sending a message
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to send message: $e'),
        ));
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    // getProduct();
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
          child: AppBar(
            backgroundColor: Color(0xffAAD7D9),
            leading: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back))),
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Chat Group',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Provider.of<ApiService>(context, listen: false)
                  .getForumChats(widget.forumId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final chats = snapshot.data;
                  // Scroll to the bottom when the messages are loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: chats?.length ?? 0,
                    itemBuilder: (context, index) {
                      final chat = chats![index];
                      return BubbleChatWidget(
                        username: chat['username'],
                        message: chat['message'],
                        createdAt: chat['created_at'],
                        currentUserId: username,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        labelText: 'Enter message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleChatWidget extends StatelessWidget {
  final String username;
  final String message;
  final String createdAt;
  final String? currentUserId;

  BubbleChatWidget({
    required this.username,
    required this.message,
    required this.createdAt,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = username == currentUserId;

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: isCurrentUser ? Color(0xffAAD7D9) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                )
              ]),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(color: Colors.black)),
              Text(message, style: TextStyle(color: Colors.black)),
              Text(createdAt, style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}
