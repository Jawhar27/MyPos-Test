import 'dart:async';
import 'dart:math';
import 'package:mypos_task/common-widgets/label_text_field.dart';
import 'package:mypos_task/constants.dart';
import 'package:mypos_task/models/department.dart';
import 'package:mypos_task/models/employee.dart';
import 'package:mypos_task/parameters.dart';
import 'package:mypos_task/services/api_service.dart';
import 'package:mypos_task/utils/alert_util.dart';
import 'package:mypos_task/utils/logger_util.dart';
import 'package:mypos_task/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({
    super.key,
    this.empNo = "",
    this.departCode = "",
    required this.refresh,
    this.isUpdate = false,
  });
  final String empNo;
  final bool isUpdate;
  final String departCode;
  final Function refresh;

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _addressLine3Controller = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  bool isFetching = false;
  bool isEmployeeFetching = false;
  List<Department> departments = [];
  List<String> departmentNames = [];
  late String name;
  late String address1;
  String? address2;
  String? address3;
  String? department;
  DateTime? dateOfJoin;
  DateTime? dateOfBirth;
  late String salary;
  late String depCode;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSubmitting = false;

  Employee? employee;
  bool loading = false;

  @override
  void initState() {
    depCode = widget.departCode;
    retriveDepartments();
    getEmployeeDetail(widget.empNo);
    super.initState();
  }

  getEmployeeDetail(String employeeNo) async {
    setState(() {
      loading = true;
    });
    if (employeeNo == "") {
      setState(() {
        isEmployeeFetching = false;
      });
    }
    if (employeeNo != "") {
      await getRecords(
        "${ApiEndpoints.employee}/$employeeNo",
        context,
        success: (data) {
          printLogs(data);
          setState(() {
            employee = Employee(
                empNo: data['empNo'],
                empName: data["empName"],
                empAddressLine1: data["empAddressLine1"],
                departmentCode: data["departmentCode"],
                dateOfBirth: data["dateOfBirth"],
                dateOfJoin: data["dateOfJoin"],
                basicSalary: (data["basicSalary"]).toDouble(),
                isActive: data["isActive"]);
            isEmployeeFetching = false;
          });

          _nameController.text = employee?.empName ?? "";
          name = employee?.empName ?? "";
          _addressLine1Controller.text = employee?.empAddressLine1 ?? "";
          address1 = employee?.empAddressLine1 ?? "";
          _addressLine2Controller.text = employee?.empAddressLine2 ?? "";
          address2 = employee?.empAddressLine2 ?? "";
          _addressLine3Controller.text = employee?.empAddressLine3 ?? "";
          address3 = employee?.empAddressLine3 ?? "";
          dateOfBirth = DateTime.parse(employee?.dateOfBirth ?? "");
          dateOfJoin = DateTime.parse(employee?.dateOfJoin ?? "");
          _salaryController.text = (employee?.basicSalary).toString();
          salary = (employee?.basicSalary).toString();
        },
        failed: () {},
        complete: () {
          setState(() {
            loading = false;
          });
        },
      );
    }
  }

  getDepartment(String code) {
    for (int i = 0; i < departments.length; i++) {
      if (departments[i].depCode == code) {
        setState(() {
          department = departments[i].depName;
          getDepCode(department ?? "");
        });
      }
    }
  }

  retriveDepartments() async {
    setState(() {
      loading = true;
    });
    await getRecords(
      ApiEndpoints.getDepartments,
      context,
      success: (data) {
        for (int i = 0; i < data.length; i++) {
          setState(() {
            departmentNames.add(data[i]['departmentName']);
            departments.add(
              Department(
                  depCode: data[i]['departmentCode'],
                  depName: data[i]['departmentName'],
                  isActive: data[i]["isActive"]),
            );
          });
          if (!widget.isUpdate) {
            department = departmentNames[0];
            getDepCode(department ?? "");
          } else {
            if (depCode != "") {
              getDepartment(depCode);
            }
          }
        }
      },
      failed: () {},
      complete: () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  void _datePicker({required BuildContext context, required bool isDOB}) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: isDOB ? DateTime.now() : DateTime(2024),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (isDOB) {
        setState(() {
          dateOfBirth = pickedDate;
        });
      } else {
        setState(() {
          dateOfJoin = pickedDate;
        });
      }
    });
  }

  getDepCode(String dep) {
    for (int x = 0; x < departments.length; x++) {
      if (departments[x].depName == dep) {
        setState(() {
          depCode = departments[x].depCode;
        });
      }
    }
  }

  submit(bool isUpdate) async {
    setState(() {
      loading = true;
    });
    printLogs(depCode);
    var random = Random();
    int randomEmpNo = random.nextInt(1000);
    Employee employee = Employee(
        empNo: widget.isUpdate ? widget.empNo : "J0$randomEmpNo",
        empName: name,
        empAddressLine1: address1,
        empAddressLine2: address2 ?? "",
        empAddressLine3: address3 ?? "",
        departmentCode: depCode,
        dateOfJoin: dateOfJoin?.toIso8601String() ?? "",
        dateOfBirth: dateOfBirth?.toIso8601String() ?? "",
        basicSalary: double.parse(salary),
        isActive: true);
    printLogs(employee.empName);
    printLogs(employee.basicSalary);

    await initializeApiRequest(
      ApiEndpoints.employee,
      context,
      success: (title, message, data) {
        reset();
        showStatusDialog(
          context: context,
          isFailedDialog: false,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            widget.refresh();
          },
          title1: 'Success',
          message1: widget.isUpdate
              ? 'Employee Updated Successfully!'
              : 'Employee Added Successfully!',
        );
      },
      failed: (title, message, data) {
        showStatusDialog(
          context: context,
          message1: widget.isUpdate
              ? 'Employee Updating Process Failed!'
              : 'Employee Adding Process Failed!',
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
      employee: employee,
      requestType: isUpdate ? RequestType.put : RequestType.post,
      complete: () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  reset() {
    _nameController.clear();
    _addressLine1Controller.clear();
    _addressLine2Controller.clear();
    _addressLine3Controller.clear();
    _salaryController.clear();
    dateOfBirth = null;
    dateOfJoin = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 209, 247),
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(!widget.isUpdate ? "Add New Employee" : "Update Employee"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      LabelTextField(
                        keyboardType: TextInputType.name,
                        textFieldController: _nameController,
                        hintText: "Employee Name",
                        labelText: "Employee Name",
                        validator: (value) {
                          if (value?.toString().trim().isEmpty ?? true) {
                            return "Please Enter The Employee Name !";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      LabelTextField(
                        keyboardType: TextInputType.streetAddress,
                        textFieldController: _addressLine1Controller,
                        hintText: "Address Line 1",
                        labelText: "Address Line 1",
                        validator: (value) {
                          if (value?.toString().trim().isEmpty ?? true) {
                            return "Please Enter The Employee Address !";
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            address1 = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      LabelTextField(
                        keyboardType: TextInputType.streetAddress,
                        textFieldController: _addressLine2Controller,
                        hintText: "Address Line 2",
                        labelText: "Address Line 2 (Optional)",
                        onChanged: (value) {
                          setState(() {
                            address2 = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      LabelTextField(
                        keyboardType: TextInputType.streetAddress,
                        textFieldController: _addressLine3Controller,
                        hintText: "Address Line 3",
                        labelText: "Address Line 3 (Optional)",
                        onChanged: (value) {
                          setState(() {
                            address1 = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Department",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 4, 79, 140),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            departments.isEmpty
                                ? Center(
                                    child: Container(),
                                  )
                                : DropdownButtonFormField(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    decoration: const InputDecoration(
                                      hintText: "Department",
                                      // labelText: "Department",
                                      // errorText: "Error",
                                      labelStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000)),

                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                    ),
                                    value: department,
                                    // isExpanded: true,
                                    onChanged: (value) {
                                      getDepCode(value ?? "");
                                      setState(() {
                                        department = value ?? "";
                                      });
                                    },
                                    validator: (String? value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please select a Department!";
                                      } else {
                                        return null;
                                      }
                                    },
                                    items: departmentNames.map((String val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _datePicker(
                                          context: context, isDOB: false);
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Date of Join",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 4, 79, 140),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.blue,
                                            ),
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 0.6),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons
                                                  .calendar_today_outlined),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                (dateOfJoin == null)
                                                    ? 'Pick Date'
                                                    : DateFormat()
                                                        .add_yMd()
                                                        .format(dateOfJoin ??
                                                            DateTime.now()),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _datePicker(
                                          context: context, isDOB: true);
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Date of Birth",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 4, 79, 140),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.blue,
                                            ),
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 0.6),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons
                                                  .calendar_today_outlined),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                (dateOfBirth == null)
                                                    ? 'Pick Date'
                                                    : DateFormat()
                                                        .add_yMd()
                                                        .format(dateOfBirth ??
                                                            DateTime.now()),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            LabelTextField(
                              keyboardType: TextInputType.number,
                              textFieldController: _salaryController,
                              hintText: "Basic Salary",
                              labelText: "Basic Salary",
                              validator: (value) {
                                if (value?.toString().trim().isEmpty ?? true) {
                                  return "Please Enter The Basic Salary !";
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  salary = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  if ((_formKey.currentState?.validate() ??
                                          false) &&
                                      (dateOfBirth != null &&
                                          dateOfJoin != null)) {
                                    submit(widget.isUpdate);
                                  } else if (dateOfBirth == null ||
                                      dateOfJoin == null) {
                                    createSnackBar(
                                      "Check Whether the dates picked or not ! !",
                                      Colors.red,
                                      context,
                                    );
                                  }
                                },
                                child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.isUpdate ? "Update" : "Submit",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (loading)
                  Positioned(
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.2,
                    right: 0,
                    top: 0,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
