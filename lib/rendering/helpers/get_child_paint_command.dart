import '../painting.dart';

class GetChildPaintCommand extends PaintCommandRecorder {
  PaintCommand ? _paintCommand;

  @override
  void register(PaintCommand paintCommand) => _paintCommand = paintCommand;
  PaintCommand ? getChildPaintCommand() => _paintCommand;
}