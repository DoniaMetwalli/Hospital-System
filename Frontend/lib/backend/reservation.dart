List<String> filter = [];

Map<String, List<String>> cities = {
  "Cairo": ["Nasr City", "Abbassia "],
  "Giza": ["6-October", "Faisal"]
};

List<dynamic> filteredHospitals = [];
List<dynamic> hospitals = [];

String selectedGovernorate = "Cairo";
String selectedCity = cities["Cairo"]![0];

int hospitalsCount(List<String> filter) {
  int count = 0;
  if (filter.isNotEmpty) {
    for (var element in hospitals) {
      if (element["city"].toLowerCase() == filter[0].toLowerCase() &&
          element["area"].toLowerCase() == filter[1].toLowerCase()) {
        count++;
        filteredHospitals.add(element);
      }
    }
    return count;
  }

  filteredHospitals = hospitals;
  return hospitals.length;
}


