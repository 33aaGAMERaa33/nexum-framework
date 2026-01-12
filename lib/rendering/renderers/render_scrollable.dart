import 'dart:math';

import 'package:nexum_framework/material/scroll_controller.dart';
import 'package:nexum_framework/nexum.dart';
import 'package:nexum_framework/painting/axis.dart';
import 'package:nexum_framework/rendering/mixins/multi_child_render_object.dart';
import 'package:nexum_framework/rendering/object.dart';

import '../../foundation/events/event.dart';
import '../../foundation/events/input_events.dart';
import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../painting.dart';

class RenderScrollView extends RenderBox with SingleChildRenderObject {
  Axis axis;
  ScrollController scrollController;
  Offset _scrolledOffset = Offset.zero();

  RenderScrollView({
    required this.axis,
    required this.scrollController,
  });

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    relativeOffset = offset;

    if(child.needsPaint) {
      child.absoluteOffset = absoluteOffset + _scrolledOffset;
      child.paint(FakePaintCommandRecorder(), _scrolledOffset);
    }

    final PaintSingleChildCommand paintCommand = PaintSingleChildCommand(
      owner: this, child: child.paintCommand!,
      offset: offset, size: child.size,
    );

    this.paintCommand = paintCommand;
    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    late final double width;
    late final double height;

    if(axis == Axis.horizontal) {
      if(child.needsLayout) child.layout(Constraints(
          maxWidth: double.infinity,
          maxHeight: constraints.maxHeight,
      ));

      width = constraints.hasBoundedWidth ? constraints.maxWidth : child.size.width;
      height = child.size.height;
    }else {
      if(child.needsLayout) child.layout(Constraints(
          maxWidth: constraints.maxWidth,
          maxHeight: double.infinity,
      ));

      width = child.size.width;
      height = constraints.hasBoundedHeight ? constraints.maxHeight : child.size.height;
    }

    _scrolledOffset = Offset(
      topPos: (axis == Axis.vertical ? scrollController.position : 0).toDouble(),
      leftPos: (axis == Axis.horizontal ? scrollController.position : 0).toDouble(),
    );

    size = Size(
        width: width,
        height: height,
    );

    if(axis == Axis.horizontal) {
      scrollController.size = child.size.width;
      scrollController.sizeCompensation = Nexum.instance.screenSize.width;
    }else {
      scrollController.size = child.size.height;
      scrollController.sizeCompensation = Nexum.instance.screenSize.height;
    }
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  bool get needsChildLayout => true;

  @override
  RenderBox get child => super.child! as RenderBox;
}

class RenderScrollListView extends RenderBox with MultiChildRenderObject {
  Axis axis;
  final int renderZoneOverflow = 0;
  ScrollController scrollController;
  Offset _scrolledOffset = Offset.zero();
  final Map<Offset, RenderObject> _childrensToRender = {};

  RenderScrollListView({
    required this.axis,
    required this.scrollController,
  });

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    relativeOffset = offset;

    final List<PaintCommand> childPaintCommands = [];

    _childrensToRender.forEach((childPos, child) {
      assert(child is RenderBox);
      child = child as RenderBox;

      if(child.needsPaint) {
        child.absoluteOffset = absoluteOffset + childPos;
        child.paint(FakePaintCommandRecorder(), childPos);
      }

      childPaintCommands.add(child.paintCommand!);
    });

    final PaintMultiChildCommand paintCommand = PaintMultiChildCommand(
        size: size, offset: offset,
        owner: this, childrens: childPaintCommands,
    );

    this.paintCommand = paintCommand;
    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    _childrensToRender.clear();
    final double scrolledPositionAbs = scrollController.position.abs();

    late final Rect renderZone;
    late final Constraints constraints;

    double width = 0;
    double height = 0;

    if(axis == Axis.horizontal) {
      assert(this.constraints.hasBoundedWidth);

      renderZone = Rect(start: Offset(leftPos: scrolledPositionAbs, topPos: 0), end: Offset(
        leftPos: this.constraints.maxWidth + scrolledPositionAbs, topPos: double.infinity,
      ));

      constraints = Constraints(
          maxWidth: double.infinity,
          maxHeight: this.constraints.maxHeight
      );

      _scrolledOffset = Offset(leftPos: scrollController.position, topPos: 0);
    }else {
      assert(this.constraints.hasBoundedHeight);

      renderZone = Rect(start: Offset(leftPos: 0, topPos: scrolledPositionAbs), end: Offset(
        leftPos: double.infinity, topPos: this.constraints.maxHeight + scrolledPositionAbs,
      ));

      constraints = Constraints(
          maxWidth: this.constraints.maxWidth,
          maxHeight: double.infinity
      );

      _scrolledOffset = Offset(leftPos: 0, topPos: scrollController.position);
    }

    for(RenderObject child in childrens) {
      assert(child is RenderBox);
      child = child as RenderBox;

      late final Offset currentPos;
      if(child.needsLayout) child.layout(constraints);

      if(axis == Axis.horizontal) {
        currentPos = Offset(leftPos: width, topPos: 0);

        width += child.size.width;
        height = max(height, child.size.height);
      }else {
        currentPos = Offset(leftPos: 0, topPos: height);

        width = max(width, child.size.width);
        height += child.size.height;
      }

      final Rect childRect = Rect.fromSize(start: currentPos, size: child.size);
      if(renderZone.intersects(childRect)) _childrensToRender[currentPos + _scrolledOffset] = child;
    }

    if(axis == Axis.horizontal) {
      size = Size(
          width: this.constraints.hasBoundedWidth ? this.constraints.maxWidth : width,
          height: height
      );

      scrollController.size = width;
      scrollController.sizeCompensation = Nexum.instance.screenSize.width;
    }else {
      size = Size(
          width: width,
          height: this.constraints.hasBoundedHeight ? this.constraints.maxHeight : height
      );

      scrollController.size = height;
      scrollController.sizeCompensation = Nexum.instance.screenSize.height;
    }
  }

  @override
  Future<void> prepareLayout() {
    final List<Future> futures = [];

    for(final RenderObject child in childrens) {
      assert(child is RenderBox);
      futures.add(child.prepareLayout());
    }

    return Future.wait(futures);
  }

  @override
  void propagateEvent<T extends Event>(T event) {
    if(event is! PointerEvent) {
      for(final RenderObject child in _childrensToRender.values) {
        child.propagateEvent(event);
      }

      return;
    }

    for(final RenderObject child in _childrensToRender.values) {
      if(child.hitTest(event.position)) {
        child.propagateEvent(event);
      }
    }
  }

  @override
  bool get needsChildLayout => true;
}