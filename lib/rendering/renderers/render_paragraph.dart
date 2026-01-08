import 'package:nexum_framework/foundation/metrics/text_metrics.dart';
import 'package:nexum_framework/rendering/mixins/leaf_child_render_object.dart';
import 'package:nexum_framework/ui/font.dart';

import '../../foundation/channel/packet_manager.dart';
import '../../foundation/channel/packets/metrics.dart';
import '../../painting/geometry.dart';
import '../../painting/text_style.dart';
import '../box.dart';
import '../commands/paint_paragraph_command.dart';
import '../painting.dart';

class ParagraphData {
  final String value;
  final Font font;
  ParagraphData({required this.value, required this.font});

  @override
  bool operator ==(Object other) {
    return other is ParagraphData && other.value == value && other.font == font;
  }

  @override
  int get hashCode => Object.hash(value, font);
}

class RenderParagraph extends RenderBox with LeafChildRenderObject {
  String value;
  TextStyle style;
  late ParagraphData paragraphData;
  static final _cache = <ParagraphData, TextMetrics>{};

  RenderParagraph({
    required this.value,
    required this.style,
  }) {
    _updateParagraphData();
  }

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    relativeOffset = offset;

    final PaintCommand paintCommand = PaintParagraphCommand(
      owner: this, size: size, offset: offset,
      value: value, font: style.font, color: style.color,
    );

    this.paintCommand = paintCommand;

    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {

  }

  @override
  Future<void> prepareLayout() async {
    late final TextMetrics textMetrics;

    if(!_cache.containsKey(paragraphData)) {
      final SendTextMetricsPacket response = await PacketManager.instance.sendPacketAndWaitResponse(
          RequestTextMetricsPacket(value: value, style: style),
      );

      textMetrics = response.textMetrics;
      _cache[paragraphData] = response.textMetrics;
    }else {
      textMetrics = _cache[paragraphData]!;
    }

    size = textMetrics.size;
  }

  @override
  void update() {
    super.update();
    _updateParagraphData();
  }

  void _updateParagraphData() {
    paragraphData = ParagraphData(value: value, font: style.font);
  }

  @override
  bool get needsChildLayout => false;
}