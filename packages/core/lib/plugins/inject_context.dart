import 'package:analytics/analytics.dart';
import 'package:analytics/event.dart';
import 'package:analytics/plugin.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;

class InjectContext extends PlatformPlugin {
  InjectContext() : super(PluginType.before);

  final instanceId = const Uuid().v4();

  @override
  Future<RawEvent> execute(RawEvent event) async {
    // We need to get the Context in a concurrency safe mode to permit changes to make it in before we retrieve it
    final context = await analytics!.state.context.state;
    context!.instanceId = instanceId;
    final libraryName =
        Platform.isAndroid ? "analytics-android" : "analytics-ios";
    context.library = ContextLibrary(libraryName, Analytics.version());
    event.context = context;
    return event;
  }
}
