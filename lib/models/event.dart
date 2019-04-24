enum EventType { test, homework }

class Event {
  final DateTime date;
  final String eventCode;
  final EventType type;
  final DateTime createdAt;
  final DateTime endTime;

  Event({
    this.endTime,
    this.date,
    this.eventCode,
    this.type,
    this.createdAt,
  });
}
