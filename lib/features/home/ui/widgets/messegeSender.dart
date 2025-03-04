import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt/core/routing/router.dart';
import 'package:gpt/core/theming/size.dart';
import 'package:gpt/core/shared/get_storage.dart';
import 'package:gpt/core/theming/colors.dart';
import 'package:gpt/features/home/data/picker.dart';
import '../../cubit/cubit/home_cubit.dart';
import '../screens/mainscreen.dart';

class messegeSender extends StatefulWidget {
  messegeSender(
      {super.key,
      required this.cubit,
      required this.messageController,
      required this.messege});

  HomeCubit cubit;
  TextEditingController messageController;
  String messege;

  @override
  State<messegeSender> createState() => _messegeSenderState();
}

class _messegeSenderState extends State<messegeSender> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.messege.length < 30
          ? MediaQuery.sizeOf(context).height * 0.12
          : MediaQuery.sizeOf(context).height * 0.40, // 0.40,//12
      margin: EdgeInsets.only(
          left: context.width(0.4), right: context.width(0.4), bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 95, 96, 99),
            Color.fromARGB(255, 62, 63, 69)
          ],
        ),
        // image: DecorationImage(
        //   image: AssetImage('assets/back.gif'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Column(
        children: [
          // send massage
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  widget.messege = value;
                });
              },
              controller: widget.messageController,
              style: TextStyle(
                color: colors.text,
                fontSize: context.fontSize(14),
              ),
              decoration: InputDecoration(
                hintText: " Ask me anything...",
                hintStyle: TextStyle(
                  color: colors.text,
                  fontSize: context.fontSize(14),
                ),
                border: InputBorder.none,
              ),
              maxLines: 12,
              minLines: 1,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // additional icon
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: () {
                        //   context.navigateTo(router.ai_convertion);
                        picker.uploadfile(context);
                      },
                      child: CircleAvatar(
                        radius: context.fontSize(14),
                        backgroundColor: colors.sliderbackground,
                        child: Icon(Icons.add,
                            size: context.fontSize(14), color: colors.text),
                      ),
                    ),
                  ),
                  // send image icon
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {
                        picker.uploadimage(context);
                      },
                      child: CircleAvatar(
                        radius: context.fontSize(14),
                        backgroundColor: colors.sliderbackground,
                        child: Icon(
                          Icons.image,
                          size: context.fontSize(14),
                          color: colors.text,
                        ),
                      ),
                    ),
                  ),
                  // send voice icon
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: context.fontSize(14),
                        backgroundColor: colors.sliderbackground,
                        child: Icon(
                          Icons.mic,
                          size: context.fontSize(14),
                          color: colors.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    get_storage.readData("model") == null
                        ? 'Select a model'
                        : get_storage.readData("model").toString(),
                    style: TextStyle(
                      color: colors.text,
                      fontSize: context.fontSize(10),
                    ),
                  ),
                  // icon button
                  IconButton(
                    onPressed: () {
                      // show dialog for available models
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                backgroundColor: colors.background,
                                title: Text(
                                  'Available Models',
                                  style: TextStyle(color: colors.text),
                                ),
                                content: Container(
                                  color: colors.background,
                                  height: context.height(0.3),
                                  width: context.width(0.3),
                                  child: widget.cubit.models.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: widget.cubit.models.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                widget.cubit.models[index],
                                                style: TextStyle(
                                                    color: colors.text),
                                              ),
                                              onTap: () {
                                                // select model
                                                get_storage.writeData("model",
                                                    widget.cubit.models[index]);
                                                context
                                                    .navigateTo(MainScreen());
                                              },
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            color: colors.text,
                                          ),
                                        ),
                                ),
                              ));
                    },
                    icon: Icon(Icons.arrow_drop_down, color: colors.text),
                  ),
                ],
              ),
              Row(
                children: [
                  // elevated button (start conversation)
                  Padding(
                    padding: EdgeInsets.only(right: context.width(0.02)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 62, 63, 69),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: colors.text),
                        ),
                      ),
                      onPressed: () {
                        widget.cubit.changeChatView();
                      },
                      child: Text(
                        'Start Conversation',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: context.fontSize(14),
                        ),
                      ),
                    ),
                  ),

                  // send icon
                  Padding(
                    padding: EdgeInsets.only(right: context.width(0.05)),
                    child: GestureDetector(
                      onTap: () {
                        // send massage
                        if (widget.messageController.text.isNotEmpty) {
                          if (get_storage.readData("model") != null) {
                            widget.cubit.addMessage(
                                'user', widget.messageController.text);

                            widget.cubit.generateResponse(
                                widget.messageController.text);

                            widget.messageController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a model'),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please enter a message'),
                          ));
                        }
                      },
                      child: CircleAvatar(
                        radius: context.fontSize(14),
                        backgroundColor: colors.sliderbackground,
                        child: Icon(
                          CupertinoIcons.arrow_up,
                          size: context.fontSize(14),
                          color: colors.text,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
