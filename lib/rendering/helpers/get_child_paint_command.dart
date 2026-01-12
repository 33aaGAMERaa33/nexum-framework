import '../painting.dart';

final class FakePaintCommandRecorder implements PaintCommandRecorder {
  static const instance = FakePaintCommandRecorder._();

  const FakePaintCommandRecorder._();
  factory FakePaintCommandRecorder() => instance;

  @override
  void register(PaintCommand paintCommand) => {};
}