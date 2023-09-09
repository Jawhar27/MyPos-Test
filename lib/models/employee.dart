class Employee {
  String? empNo;
  String? empName;
  String? empAddressLine1;
  String? empAddressLine2;
  String? empAddressLine3;
  String? departmentCode;
  String? dateOfJoin;
  String? dateOfBirth;
  double? basicSalary;
  bool? isActive;

  Employee({
    this.empNo,
    this.empName,
    this.empAddressLine1,
    this.empAddressLine2,
    this.empAddressLine3,
    this.departmentCode,
    this.dateOfBirth,
    this.dateOfJoin,
    this.basicSalary,
    this.isActive,
  });

  // Factory method implementation
  factory Employee.fromJson(Map<String, dynamic> parsedJson) {
    return Employee(
      empNo: parsedJson['empNo'],
      empName: parsedJson["empName"],
      empAddressLine1: parsedJson["empAddressLine1"],
      departmentCode: parsedJson["departmentCode"],
      dateOfBirth: parsedJson["dateOfBirth"],
      dateOfJoin: parsedJson["dateOfJoin"],
      basicSalary: (parsedJson["basicSalary"]).toDouble(),
      isActive: parsedJson["isActive"],
    );
  }
}
