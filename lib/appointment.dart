class Appointment {
  String id;
  String appointmentName;
  DateTime appointmentDate;
  String userId;

  Appointment(
      {required this.id,
      required this.appointmentName,
      required this.appointmentDate,
      required this.userId});
}
// DateFormat.yMd().format(seDate)
