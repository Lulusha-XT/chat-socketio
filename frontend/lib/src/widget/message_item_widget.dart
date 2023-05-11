import 'package:flutter/material.dart';
import 'package:frontend/src/constatnts/color_strings.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.msg, required this.sendByMe});
  final String msg;
  final bool sendByMe;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sendByMe ? AppColors.purple : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg,
              style: TextStyle(
                color: sendByMe ? Colors.white : AppColors.purple,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "1:10 AM",
              style: TextStyle(
                  color: sendByMe ? Colors.white : AppColors.purple,
                  fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
