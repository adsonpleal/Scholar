enum EventType { test, homework }

class Event {
  final DateTime date;
  final String subjectCode;
  final String description;
  final EventType type;

  Event({
    this.date,
    this.subjectCode,
    this.type,
    this.description,
  });
}
