import 'package:flutter/material.dart';

Future<void> showStatusDialog({
  required BuildContext context,
  bool isFailedDialog = true,
  String title1 = 'Failed!',
  String? message1,
  String? message2,
  String? buttonText,
  bool? barrierDismissible,
  required void Function() onPressed,
}) async {
  return await showDialog<void>(
    barrierDismissible: barrierDismissible ?? false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      isFailedDialog
                          ? const Icon(
                              Icons.warning,
                              size: 100,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.done,
                              size: 100,
                              color: Colors.green,
                            ),
                      const SizedBox(height: 10),
                      Text(
                        title1,
                        style: TextStyle(
                          color: isFailedDialog ? Colors.red : Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Text(
                    message1 ?? "",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: onPressed,
                    child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            buttonText ?? 'Ok',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ));
    },
  );
}
