class Department {
  String depCode;
  String depName;
  bool isActive;

  Department({
    required this.depCode,
    required this.depName,
    required this.isActive,
  });

  factory Department.fromJson(Map<String, dynamic> parsedJson) {
    return Department(
      depCode: parsedJson['departmentCode'],
      depName: parsedJson["departmentName"],
      isActive: parsedJson["isActive"],
    );
  }
}
