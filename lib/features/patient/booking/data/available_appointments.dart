List<int> getAvailableAppointments(
    DateTime selectedDate, String start, String end) {
  int startHour = int.parse(start);
  int endHour = int.parse(end);

  List<int> availableHours = [];
  for (int i = startHour; i < endHour; i++) {
    if (selectedDate
            .difference(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
            .inDays !=
        0) {
      availableHours.add(i);
    } else {
      if (i > DateTime.now().hour) {
        availableHours.add(i);
      }
    }
  }
  return availableHours;
}