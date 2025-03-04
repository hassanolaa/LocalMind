

  import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:gpt/features/home/ui/widgets/massegewidget.dart';
import '../../cubit/cubit/home_cubit.dart';
import 'massegewidget.dart';
import 'package:gpt/core/shared/get_storage.dart';
import 'package:gpt/core/theming/colors.dart';

Expanded chatView(HomeCubit cubit) {
    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cubit.messages_list.length,
                        itemBuilder: (context, index) {
                          final message = cubit.messages_list[index];
                          return Padding(
                              padding: message.role == 'user'
                                  ? const EdgeInsets.only(
                                      right: 20, left: 400, bottom: 20)
                                  : const EdgeInsets.only(
                                      left: 20, right: 400, bottom: 20),
                              child: MessageBubble(
                                  isUser: message.role == 'user'
                                      ? true
                                      : false,
                                  avatarIcon: message.role == 'user'
                                      ? Icons.person
                                      : Bootstrap.chat_dots,
                                  backgroundColor: colors.sliderbackground,
                                  content: message.role == 'user'
                                      ? message.content.toString()
                                      : '${get_storage.readData("model")}: ${message.content.toString()}',
                                  onCopy: () {})

                              //  Container(
                              //   height: message['content'].toString().length > 40
                              // ? message['content'].toString().length * 2.5
                              // : 70,
                              //   decoration: BoxDecoration(
                              //       color: colors.sliderbackground,
                              //       borderRadius: BorderRadius.circular(20)
                              //   ),
                              //   padding: const EdgeInsets.only(left: 8,top: 15),
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       CircleAvatar(
                              //         backgroundColor: colors.text,
                              //         child: Icon(
                              //           message['role'] == 'user'
                              //               ? Icons.person
                              //               : Bootstrap.chat_dots,
                              //           color:  colors.sliderbackground,
                              //         ),
                              //       ),
                              //       const SizedBox(width: 12),
                              //       Expanded(
                              //         child: Text(
                              //           message['content'] ?? '',
                              //           style:  TextStyle(
                              //             color:  colors.text,
                              //             fontSize: 16,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              );
                        },
                      ),
                    );
  }
