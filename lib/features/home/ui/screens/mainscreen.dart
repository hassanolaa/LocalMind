import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt/core/routing/router.dart';
import 'package:gpt/core/shared/get_storage.dart';
import 'package:gpt/core/theming/colors.dart';
import 'package:gpt/core/theming/size.dart';
import 'package:gpt/features/home/cubit/cubit/home_cubit.dart';
import 'package:siri_wave/siri_wave.dart';

import '../../data/models.dart';
import '../widgets/chatView.dart';
import '../widgets/messegeSender.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  String messege = '';

  bool wideSidebar = true;

  @override
  Widget build(BuildContext context) {
    final controller = SiriWaveController(
      speed: 0.05,
    );
    return BlocProvider(
        create: (context) => HomeCubit()
          ..getAvailableModels()
          ..getChats()
          ..setChat()
          ..getMessages(),
        child: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
          if (state is getModelsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is getModelsEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is chatsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }, builder: (context, state) {
          final cubit = BlocProvider.of<HomeCubit>(context);
          return Scaffold(
            backgroundColor: colors.background,
            body: Row(
              children: [
                // Sidebar
                wideSidebar
                    ? Container(
                        width: 260,
                        color: colors.sliderbackground,
                        child: Column(
                          children: [
                            // App Logo
                            Container(
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Image.asset('images/logo.png',
                                      width: 150, height: 100),
                                  const SizedBox(width: 30),
                                  // minimize icon
                                  IconButton(
                                    tooltip: 'Minimize',
                                    onPressed: () {
                                      setState(() {
                                        wideSidebar = false;
                                       
                                      });
                                    },
                                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                                        color: colors.text),
                                  ),
                                ],
                              ),
                            ),

                            // New Chat Button
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(150, 50),
                                      backgroundColor:
                                          Color.fromARGB(255, 61, 75, 229),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () {
                                      // dialog with text field
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: colors.background,
                                            title: const Text(
                                              'New Chat',
                                              style:
                                                  TextStyle(color: colors.text),
                                            ),
                                            content: TextField(
                                              controller: _chatController,
                                              decoration: const InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: colors.text),
                                                hintText: 'New chat name',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: colors.text),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (_chatController
                                                      .text.isNotEmpty) {
                                                    cubit.addChat(
                                                        _chatController.text);
                                                    _chatController.clear();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                            'Chat name cannot be empty'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: colors.text),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.chat_bubble_outline,
                                            color: colors.text),
                                        SizedBox(width: 8),
                                        Text(
                                          'New Chat',
                                          style: TextStyle(color: colors.text),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey),
                            // Chat History
                            Expanded(
                                child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor:
                                    MaterialStateProperty.all(colors.text),
                              ),
                              child: Scrollbar(
                                // thumbVisibility: true,
                                child: ListView.builder(
                                  itemCount: cubit.chats.length,
                                  padding: const EdgeInsets.all(8.0),
                                  itemBuilder: (context, index) {
                                    if (cubit.chats.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'No chats available',
                                          style: TextStyle(color: colors.text),
                                        ),
                                      );
                                    } else {
                                      // return _buildHistoryItem(
                                      //     cubit.chats[index].name,cubit.chats[index].lastMessageTime.toString().substring(0,10) ,
                                      //     cubit.chats[index].id
                                      //     ,Icons.chat);
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: cubit.chats[index].id ==
                                                  get_storage
                                                      .readData('chat_id')
                                              ? colors.text
                                              : colors.sliderbackground,
                                        ),
                                        child: GestureDetector(
                                          child: ListTile(
                                            title: GestureDetector(
                                              onTap: () {
                                                cubit.changeChat(
                                                    cubit.chats[index].id,
                                                    cubit.chats[index].name);
                                                 cubit.getMessages();
                                              },
                                              child: Text(
                                                cubit.chats[index].name,
                                                style: TextStyle(
                                                    color: cubit.chats[index]
                                                                .id ==
                                                            get_storage.readData(
                                                                'chat_id')
                                                        ? colors
                                                            .sliderbackground
                                                        : colors.text),
                                              ),
                                            ),
                                            subtitle: GestureDetector(
                                              onTap: () {
                                                cubit.changeChat(
                                                    cubit.chats[index].id,
                                                    cubit.chats[index].name);
                                                 cubit.getMessages();

                                              },
                                              child: Text(
                                                cubit.chats[index]
                                                    .lastMessageTime
                                                    .toString()
                                                    .substring(0, 10),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: cubit.chats[index]
                                                                .id ==
                                                            get_storage.readData(
                                                                'chat_id')
                                                        ? colors
                                                            .sliderbackground
                                                        : Colors.grey),
                                              ),
                                            ),
                                            onTap: () {
                                              cubit.changeChat(
                                                  cubit.chats[index].id,
                                                  cubit.chats[index].name);
                                               cubit.getMessages();
                                            },
                                            hoverColor: colors.text,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            )),
                            // User Profile Section
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border:
                                    Border(top: BorderSide(color: Colors.grey)),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colors.text,
                                    child:
                                        Icon(Icons.person, color: colors.coco),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'User Profile',
                                    style: TextStyle(color: colors.text),
                                  ),
                                  SizedBox(width: 80),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(CupertinoIcons.settings_solid,
                                          size: 20, color: colors.text)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 90,
                        color: colors.sliderbackground,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // app logo, new chat icon and minimize icon

                              Container(
                                child: Column(
                                  children: [
                                    const SizedBox(width: 8),
                                    Image.asset('images/icon.png',
                                        width: 70, height: 70),
                                    const SizedBox(width: 8),
                                    // maximize icon
                                    IconButton(
                                      tooltip: 'Maximize',
                                      onPressed: () {
                                        setState(() {
                                          wideSidebar = true;
                                        });
                                      },
                                      icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: colors.text,
                                          size: 25),
                                    ),

                                    SizedBox(height: 20),
                                    // new chat
                                    IconButton(
                                      tooltip: 'New Chat',
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.chat_bubble_outline,
                                          color: colors.text, size: 25),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  // settings icon
                                  IconButton(
                                    tooltip: 'Settings',
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: Icon(CupertinoIcons.settings_solid,
                                        color: colors.text, size: 25),
                                  ),

                                  // user icon
                                  // user profile
                                  CircleAvatar(
                                    backgroundColor: colors.text,
                                    child: Icon(Icons.person,
                                        color: colors.coco, size: 15),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ])),

                // Main Content
                Expanded(
                  child: Column(
                    children: [
                      // banner for chat name
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              get_storage.readData('chat_name') ?? '',
                              style: TextStyle(
                                color: colors.text,
                                fontSize: context.fontSize(20),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // chat
                      cubit.is_chat?
                      chatView(cubit)
                      : SiriWave(
                  controller: controller,
                  style: SiriWaveStyle.ios_9,
                  options: SiriWaveOptions(
                    height: context.height(0.75),
                    width: context.width(0.8),
                  ),
                ),

                      // messenger
                      messegeSender(
                          cubit: cubit,
                          messageController: _messageController,
                          messege: messege),

                      Text(
                        'AI-generated, for reference only',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: context.fontSize(12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  Widget _buildHistoryItem(String title, String date, int id, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: id == get_storage.readData('chat_id')
            ? colors.text
            : colors.sliderbackground,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: id == get_storage.readData('chat_id')
                  ? colors.sliderbackground
                  : colors.text),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
              fontSize: 12,
              color: id == get_storage.readData('chat_id')
                  ? colors.sliderbackground
                  : Colors.grey),
        ),
        onTap: () {},
        hoverColor: colors.text,
      ),
    );
  }
}
