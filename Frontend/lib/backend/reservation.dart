String filter = "";

List<List<String>> hospitalList = [
  ["Hospital A", "Cairo - Nasr City"],
  ["Hospital B", "Cairo - Nasr City"],
  ["Hospital C", "Giza - 6 Octobor"],
  ["Hospital D", "Giza - 6 Octobor"],
];
List<List<String>> hospitals = [];

int hospitalsCount(String filter) {
  hospitals = [];
  int count = 0;
  if (filter.isNotEmpty) {
    for (var element in hospitalList) {
      if (element[1] == filter) {
        count++;
        hospitals.add(element);
      }
    }
    return count;
  }
  hospitals = hospitalList;
  return hospitalList.length;
}