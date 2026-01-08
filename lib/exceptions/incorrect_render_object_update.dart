import 'package:nexum_framework/exceptions/exception_message.dart';

import '../rendering/object.dart';

class IncorrectRenderObjectUpdate extends ExceptionMessage {
  IncorrectRenderObjectUpdate(RenderObject provider, Type expected)
      : super("Provide: ${provider.runtimeType}, Expected: $expected");
}