import 'dart:math';

import 'package:nexum_framework/material/max_int.dart';
import 'package:nexum_framework/painting/axis.dart';

import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/multi_child_render_object.dart';
import '../object.dart';
import '../painting.dart';
import 'render_flexible.dart';

enum FlexFit {
  tight,
  loose,
}

enum CrossAxisAlignment {
  end,
  start,
  center,
  stretch,
  baseline,
}

enum MainAxisAlignment {
  end,
  start,
  center,
}

enum MainAxisSize {
  max,
  min
}

class RenderFlex extends RenderBox with MultiChildRenderObject {
  Axis axis;
  int spacing;
  Size ? _childrensSize;
  MainAxisSize mainAxisSize;
  MainAxisAlignment mainAxisAlignment;

  RenderFlex({
    required this.axis,
    required this.spacing,
    required this.mainAxisSize,
    required this.mainAxisAlignment,
  });

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    relativeOffset = offset;

    double currentX = 0;
    double currentY = 0;
    final List<PaintCommand> childPaintCommands = [];

    for(int i = 0; i < childrens.length; i += 1) {
      final RenderBox child = childrens[i] as RenderBox;
      final GetChildPaintCommand childPaintCommandGetter = GetChildPaintCommand();

      Offset translateOffset = Offset(leftPos: currentX, topPos: currentY);
      double translateByMainAxisAlignmentValue = 0;

      final double containerSize = axis == Axis.horizontal ? size.width : size.height;
      final double childrenSize = axis == Axis.horizontal ? _childrensSize!.width : _childrensSize!.height;

      final double freeSpace = (containerSize - childrenSize).clamp(0, containerSize);

      switch (mainAxisAlignment) {
        case MainAxisAlignment.start:
          translateByMainAxisAlignmentValue = 0;
          break;
        case MainAxisAlignment.end:
          translateByMainAxisAlignmentValue = freeSpace;
          break;
        case MainAxisAlignment.center:
          translateByMainAxisAlignmentValue = freeSpace / 2;
          break;
      }

      if(axis == Axis.horizontal) {
        translateOffset += Offset(leftPos: translateByMainAxisAlignmentValue, topPos: 0);
      }else {
        translateOffset += Offset(leftPos: 0, topPos: translateByMainAxisAlignmentValue);
      }

      child.absoluteOffset = absoluteOffset + translateOffset;
      child.paint(childPaintCommandGetter, translateOffset);

      childPaintCommands.add(child.paintCommand!);

      if(axis == Axis.horizontal) {
        currentX += child.size.width + spacing * (i + 1);
      }else {
        currentY += child.size.height + spacing * (i + 1);
      }
    }

    final PaintMultiChildCommand paintMultiChildCommand = PaintMultiChildCommand(
      owner: this,
      size: size,
      offset: offset,
      childrens: childPaintCommands,
    );

    paintCommand = paintMultiChildCommand;
    paintRecorder.register(paintMultiChildCommand);
  }

  @override
  void performLayout() {
    double width = 0;
    double height = 0;

    late final Constraints constraints;

    if(axis == Axis.horizontal) {
      constraints = Constraints(
          minWidth: 0,
          maxWidth: double.infinity,
          minHeight: 0,
          maxHeight: this.constraints.maxHeight,
      );
    }else {
      constraints = Constraints(
          minWidth: 0,
          maxWidth: this.constraints.maxWidth,
          minHeight: 0,
          maxHeight: double.infinity,
      );
    }

    int totalFlex = 0;
    final List<RenderFlexible> childRenderFlexibles = [];

    for(int i = 0; i < childrens.length; i++) {
      final RenderBox child = childrens[i] as RenderBox;

      if(child is RenderFlexible) {
        totalFlex += child.flex;
        childRenderFlexibles.add(child);
        continue;
      }

      child.layout(constraints);

      if(axis == Axis.horizontal) {
        width += child.size.width;
        height = max(height, child.size.height);
      }else {
        width = max(width, child.size.width);
        height += child.size.height;
      }
    }

    if(axis == Axis.horizontal) {
      width += spacing * (childrens.length - 1);
    }else {
      height += spacing * (childrens.length - 1);
    }

    if(childRenderFlexibles.isNotEmpty) {
      final double remainingWidth = this.constraints.maxWidth - width;
      final double remainingHeight = this.constraints.maxHeight - height;

      for(final RenderFlexible childRenderFlexible in childRenderFlexibles) {
        late final double childWidth;
        late final double childHeight;

        if(axis == Axis.horizontal) {
          childWidth = remainingWidth / totalFlex * childRenderFlexible.flex;
          childHeight = height;
        }else {
          childWidth = width;
          childHeight = remainingHeight / totalFlex * childRenderFlexible.flex;
        }

        width += childWidth;
        width += childHeight;
        childRenderFlexible.layout(Constraints(maxWidth: childWidth, maxHeight: childHeight));
      }
    }

    _childrensSize = Size(width: width, height: height);

    if(mainAxisSize == MainAxisSize.max) {
      if(axis == Axis.horizontal) {
        width = this.constraints.hasBoundedWidth ? this.constraints.maxWidth : width;
      }else {
        height = this.constraints.hasBoundedHeight ? this.constraints.maxHeight : height;
      }
    }

    size = Size(width: width, height: height);
  }

  @override
  Future<void> prepareLayout() async {
    final List<Future> futures = [];

    for(final RenderObject child in childrens) {
      futures.add(child.prepareLayout());
    }

    try {
      await Future.wait(futures);
    }catch(e) {
      print(e);
    }
  }

  @override
  bool get needsChildLayout => true;
}