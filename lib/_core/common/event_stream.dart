import 'dart:async';

import 'package:seller_management/main.export.dart';

class EventStreamer {
  // Singleton pattern to ensure only one instance is used across the app
  static final EventStreamer _instance = EventStreamer._internal();
  factory EventStreamer() => _instance;
  EventStreamer._internal();

  final _controller = StreamController<Event>.broadcast();

  // Stream to listen to events
  Stream<Event> get stream => _controller.stream;

  // Method to add events to the stream
  void addEvent(Event event) {
    _controller.add(event);
  }

  // Dispose method to close the stream
  void dispose() {
    _controller.close();
  }
}

// Define an event class (you can customize this as needed)
class Event {
  final String type;
  final QMap? payload;

  Event(this.type, {this.payload});
}
