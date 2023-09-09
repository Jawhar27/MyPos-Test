import 'dart:async';

import 'package:mypos_task/constants.dart';
import 'package:mypos_task/models/department.dart';
import 'package:mypos_task/models/employee.dart';
import 'package:mypos_task/pages/employees/add_employee_screen.dart';
import 'package:mypos_task/parameters.dart';
import 'package:mypos_task/routes.dart';
import 'package:mypos_task/services/api_service.dart';
import 'package:mypos_task/styles/assets.dart';
import 'package:mypos_task/utils/alert_util.dart';
import 'package:mypos_task/utils/navigation_util.dart';
import 'package:mypos_task/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen(
      {super.key, required this.employee, required this.refresh});
  final Function refresh;
  final Employee employee;

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  Widget contactInfo(String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20, width: 20, child: Icon(icon)),
        const SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: const TextStyle(
            // fontFamily: manropeMedium,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff212121),
          ),
        ),
      ],
    );
  }

  List<Department> departments = [];
  bool isFetching = false;
  String? department;

  getSpecificDepartment(String depCode) {
    for (int i = 0; i < departments.length; i++) {
      if (departments[i].depCode == depCode) {
        setState(() {
          department = departments[i].depName;
        });
      }
    }
  }

  getDepartments() async {
    setState(() {
      isFetching = true;
    });
    await getRecords(
      ApiEndpoints.getDepartments,
      context,
      success: (data) {
        for (int i = 0; i < data.length; i++) {
          setState(() {
            departments.add(
              Department(
                  depCode: data[i]['departmentCode'],
                  depName: data[i]['departmentName'],
                  isActive: data[i]["isActive"]),
            );
          });
        }
        getSpecificDepartment(widget.employee.departmentCode!);
      },
      failed: () {},
      complete: () {
        setState(() {
          isFetching = false;
        });
      },
    );
  }

  Widget showAlert(String employeeNo) {
    return AlertDialog(
      backgroundColor: Colors.grey[300],
      title: const Text('Warning !', style: TextStyle(color: Colors.red)),
      content: const Text(
        'Do you want to delete the employee ?',
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await initializeApiRequest(
                "${ApiEndpoints.employee}/$employeeNo",
                context,
                success: (title, message, data) {
                  Navigator.of(context).pop();
                  showStatusDialog(
                    context: context,
                    isFailedDialog: false,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.refresh();
                    },
                    title1: 'Success',
                    message1: 'Employee Deleted Successfully!',
                  );
                },
                failed: (title, message, data) {
                  showStatusDialog(
                    context: context,
                    message1: 'Employee Deleting Process Failed!',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                requestType: RequestType.delete,
              );
            }),
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        )
      ],
    );
  }

  Widget heading(String heading) {
    return Text(
      heading,
      style: const TextStyle(
        // fontFamily: manropeMedium,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xff212121),
      ),
    );
  }

  Widget button(void Function()? onPressed, String text) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 241, 239, 239),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        height: 37,
        width: 100,
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style:
                  TextStyle(color: text == "Delete" ? Colors.red : Colors.blue),
            )));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 209, 247),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Employee Details"),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 20, right: 40, left: 40),
          child: isFetching
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          employeeLogo,
                          height: height * 0.13,
                          width: 118.69,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heading("Employee Name"),
                                const SizedBox(
                                  height: 10,
                                ),
                                contactInfo(widget.employee.empName ?? '',
                                    Icons.person),
                                const SizedBox(
                                  height: 15,
                                ),
                                heading("Department Name"),
                                const SizedBox(
                                  height: 10,
                                ),
                                contactInfo(
                                    department ?? "", Icons.location_city),
                                const SizedBox(
                                  height: 15,
                                ),
                                heading("Address"),
                                const SizedBox(
                                  height: 10,
                                ),
                                contactInfo(
                                    widget.employee.empAddressLine1 ?? "",
                                    Icons.location_on),
                                widget.employee.empAddressLine2 == ""
                                    ? contactInfo(
                                        widget.employee.empAddressLine2 ?? "",
                                        Icons.location_on)
                                    : Container(),
                                widget.employee.empAddressLine3 == ""
                                    ? contactInfo(
                                        widget.employee.empAddressLine3 ?? "",
                                        Icons.location_on)
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: height * 0.28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading("Join Date"),
                          const SizedBox(
                            height: 10,
                          ),
                          contactInfo(widget.employee.dateOfJoin ?? '',
                              Icons.date_range),
                          const SizedBox(
                            height: 15,
                          ),
                          heading("Date of Birth"),
                          const SizedBox(
                            height: 10,
                          ),
                          contactInfo(widget.employee.dateOfBirth ?? '',
                              Icons.date_range),
                          const SizedBox(
                            height: 15,
                          ),
                          heading("Basic Salary"),
                          const SizedBox(
                            height: 10,
                          ),
                          contactInfo(widget.employee.basicSalary.toString(),
                              Icons.money),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          button(
                            () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return showAlert(widget.employee.empNo!);
                                  });
                            },
                            "Delete",
                          ),
                          button(() {
                            pushScreen(
                                context, ScreenRoutes.toAddEmployeeScreen,
                                arguments: {
                                  'empNo': widget.employee.empNo!,
                                  'isUpdate': true,
                                  'departmentCode':
                                      widget.employee.departmentCode,
                                });
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AddEmployeeScreen(
                            //       empNo: widget.employee.empNo!,
                            //       isUpdate: true,
                            //       refresh: () {},
                            //     ),
                            //   ),
                            // );
                          }, "Edit"),
                        ],
                      ),
                    )
                  ],
                )),
    );
  }
}
