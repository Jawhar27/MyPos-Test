import 'package:mypos_task/common-widgets/employee_card.dart';
import 'package:mypos_task/constants.dart';
import 'package:mypos_task/models/employee.dart';
import 'package:mypos_task/pages/employees/add_employee_screen.dart';
import 'package:mypos_task/pages/employees/employee_detail_screen.dart';
import 'package:mypos_task/parameters.dart';
import 'package:mypos_task/routes.dart';
import 'package:mypos_task/services/api_service.dart';
import 'package:mypos_task/utils/alert_util.dart';
import 'package:mypos_task/utils/logger_util.dart';
import 'package:mypos_task/utils/navigation_util.dart';
import 'package:mypos_task/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    retriveEmployees();
    super.initState();
  }

  refresh() {
    employees.clear();
    retriveEmployees();
  }

  retriveEmployees() async {
    setState(() {
      isFetching = true;
    });

    await getRecords(
      ApiEndpoints.getEmployees,
      context,
      success: (data) {
        if (data.isNotEmpty) {
          printLogs(data);
          for (int i = 0; i < data.length; i++) {
            printLogs(data[i]['empName']);
            setState(() {
              employees.add(
                Employee(
                  empNo: data[i]['empNo'],
                  empName: data[i]["empName"],
                  empAddressLine1: data[i]["empAddressLine1"],
                  departmentCode: data[i]["departmentCode"],
                  dateOfBirth: data[i]["dateOfBirth"],
                  dateOfJoin: data[i]["dateOfJoin"],
                  basicSalary: (data[i]["basicSalary"]).toDouble(),
                  isActive: data[i]["isActive"],
                ),
              );
              filteredEmployees = employees;
            });
          }
        }
      },
      failed: () {
        setState(() {
          isFetching = false;
        });
      },
      complete: () {
        setState(() {
          isFetching = false;
        });
      },
    );
  }

  bool isFetching = false;

  List<Employee> employees = [];

  List<Employee> filteredEmployees = [];

  Employee? employeee;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  refresh();
                  createSnackBar(
                    data['statusDescription'] ?? 'Successfully Deleted!',
                    Colors.green,
                    context,
                  );
                },
                failed: (title, message, data) {
                  createSnackBar(
                    data['statusDescription'] ?? 'Failed !',
                    Colors.red,
                    context,
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(
          child: Text("Employees"),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 188, 209, 247),
        child: isFetching
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : filteredEmployees.isEmpty
                ? const Center(
                    child: Text(
                      "Oops, There are no records found !",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  )
                : Container(
                    height: height,
                    margin: EdgeInsets.only(
                        top: height * 0.04,
                        left: width * 0.03,
                        right: width * 0.03),
                    child: Column(
                      children: [
                        // gridvieww
                        SizedBox(
                          width: width * 0.85,
                          child: TextFormField(
                            // controller: textFieldController,
                            onChanged: (value) {
                              setState(() {
                                filteredEmployees = employees
                                    .where((element) => element.empName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: "Search For Employee",
                              hintStyle: TextStyle(fontSize: 16),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          height: height * 0.7,
                          margin: EdgeInsets.only(
                              left: width * 0.035, right: width * 0.03),
                          child: GridView.builder(
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredEmployees.length,
                            itemBuilder: (context, index) {
                              Employee employee = filteredEmployees[index];
                              return GestureDetector(
                                  onTap: () {},
                                  child: EmployeeCard(
                                    name: employee.empName!,
                                    depName: employee.empAddressLine1!,
                                    isActive: true,
                                    onTap: () {
                                      pushScreen(context,
                                          ScreenRoutes.toEmployeeDetailScreen,
                                          arguments: {
                                            'employee': employee,
                                            'refresh': refresh,
                                          });
                                    },
                                    onEdit: () {
                                      pushScreen(context,
                                          ScreenRoutes.toAddEmployeeScreen,
                                          arguments: {
                                            'empNo': employee.empNo!,
                                            'isUpdate': true,
                                            'departmentCode':
                                                employee.departmentCode ?? '',
                                            'refresh': refresh
                                          });
                                    },
                                    onDelete: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return showAlert(employee.empNo!);
                                          });
                                    },
                                  ));
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.5)),
                          ),
                        ),
                      ],
                    )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          pushScreen(context, ScreenRoutes.toAddEmployeeScreen, arguments: {
            'refresh': refresh,
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
