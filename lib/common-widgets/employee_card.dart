import 'package:flutter/material.dart';
import 'package:mypos_task/styles/assets.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.name,
    required this.depName,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.isActive,
  });

  final String name;
  final String depName;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function()? onTap;
  final bool isActive;

  Widget iconButton(IconData? icon, Color color) {
    return Container(
        height: 20,
        width: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 15,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTap : (() {}),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white
              : const Color.fromARGB(255, 216, 214, 214),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 1.0,
            color: Colors.grey,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                InkWell(
                  onTap: isActive ? onEdit : (() {}),
                  child: iconButton(Icons.edit, Colors.blue),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 230, 228, 228),
              radius: 40.0,
              child: Image.asset(
                employeeLogo,
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    depName,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onDelete,
                child: iconButton(Icons.delete, Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
