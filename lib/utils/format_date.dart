String formatarData(String data) {
  DateTime date = DateTime.parse(data);

  String formattedDate = "${date.day.toString().padLeft(2, '0')}/"
                         "${date.month.toString().padLeft(2, '0')}/"
                         "${date.year}";

  return formattedDate;
}