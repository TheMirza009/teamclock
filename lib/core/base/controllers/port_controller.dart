import 'dart:isolate';
import 'dart:ui';

class PortMessageController {
  static ReceivePort? globalReceivePort;
  static SendPort? globalSendPort;
  static Function(Map<String, dynamic>)? _customHandler;

  /// Initializes the global ReceivePort
  @pragma("vm:entry-point")
  static void initialize() {
    if (globalReceivePort == null) {
      globalReceivePort = ReceivePort();
      globalReceivePort!.listen((message) {
        if (message is Map<String, dynamic>) {
          _customHandler?.call(message); // Call the custom handler if set
        } else {
          print("Unexpected message type: $message");
        }
      });

      globalSendPort = globalReceivePort!.sendPort;

      // Register the SendPort with IsolateNameServer
      IsolateNameServer.removePortNameMapping('globalSendPort');
      IsolateNameServer.registerPortWithName(globalSendPort!, 'globalSendPort');
      print("Global SendPort registered with IsolateNameServer.");
    }
  }

  /// Sends a message using the global SendPort
  @pragma("vm:entry-point")
  static void sendMessage(Map<String, dynamic> message) {
    final sendPort = IsolateNameServer.lookupPortByName('globalSendPort');
    if (sendPort != null) {
      sendPort.send(message);
      print("Message sent: $message");
    } else {
      print("SendPort not found in IsolateNameServer.");
    }
  }

  /// Sets the custom logic for handling received messages
  @pragma("vm:entry-point")
  static void handleReceived({required Function(Map<String, dynamic>) onReceived}) {
    _customHandler = onReceived;
  }
}
