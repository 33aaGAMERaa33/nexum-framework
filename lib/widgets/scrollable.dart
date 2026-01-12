import 'package:nexum_framework/foundation/events/input_events.dart';
import 'package:nexum_framework/material/scroll_controller.dart';
import 'package:nexum_framework/painting/axis.dart';
import 'package:nexum_framework/widgets/input_detector.dart';

import '../exceptions/incorrect_render_object_update.dart';
import '../rendering/object.dart';
import '../rendering/renderers/render_scrollable.dart';
import 'framework.dart';

class ScrollView extends SingleChildRenderObjectWidget {
  final Axis axis;
  final ScrollController controller;

  ScrollView({
    required this.axis,
    required super.child,
    required this.controller,
  });

  @override
  RenderObject createRenderObject() => RenderScrollView(
    axis: axis,
    scrollController: controller,
  );

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderScrollView) throw IncorrectRenderObjectUpdate(renderObject, RenderScrollView);

    renderObject.scrollController = controller;
    renderObject.update();
  }
}

class ScrollListView extends MultiChildRenderObjectWidget {
  final Axis axis;
  final ScrollController scrollController;

  ScrollListView({
    required this.axis,
    required this.scrollController,
    required List<Widget> childrens,
  }) : super(childrens);

  @override
  RenderObject createRenderObject() => RenderScrollListView(
    axis: axis,
    scrollController: scrollController,
  );

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderScrollListView) throw IncorrectRenderObjectUpdate(renderObject, RenderScrollListView);

    renderObject.scrollController = scrollController;
    renderObject.update();
  }
}

class Scrollable extends StatefulWidget {
  final Axis axis;
  final Widget child;
  final ScrollController scrollController;

  Scrollable({
    required this.child,
    this.axis = Axis.vertical,
    ScrollController ? controller,
  }) : scrollController = controller ?? ScrollController();

  @override
  State<StatefulWidget> createState() => ScrollableState();
}

class ScrollableState extends State<Scrollable> {
  Axis get _axis => widget.axis;
  Widget get _child => widget.child;
  ScrollController get _scrollController => widget.scrollController;

  @override
  Widget build(BuildContext context) {
    return InputDetector(
      onInput: (event) {
        if(event is! PointerScrollEvent) return;
        _scrollController.animateBy(event.scrollDelta * -1);
      },
      child: ScrollView(
        axis: _axis,
        child: _child,
        controller: _scrollController,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    setState(() {});
  }
}

class ScrollableList extends StatefulWidget {
  final Axis axis;
  final List<Widget> childrens;
  final ScrollController scrollController;

  ScrollableList({
    super.key,
    required this.childrens,
    this.axis = Axis.vertical,
    ScrollController ? scrollController,
  }) : scrollController = scrollController ?? ScrollController();

  @override
  State<StatefulWidget> createState() => ScrollableListState();
}

class ScrollableListState extends State<ScrollableList> {
  Axis get _axis => widget.axis;
  List<Widget> get _childrens => widget.childrens;
  ScrollController get _scrollController => widget.scrollController;

  @override
  Widget build(BuildContext context) {
    return InputDetector(
      onInput: (event) {
        if(event is! PointerScrollEvent) return;
        _scrollController.animateBy(event.scrollDelta * -1);
      },
      child: ScrollListView(
        axis: _axis,
        childrens: _childrens,
        scrollController: _scrollController,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    setState(() {});
  }
}