import 'dart:math';

import 'package:nexum_framework/foundation/key.dart';

import '../exceptions/nexum_error.dart';
import '../foundation/types/void_callback.dart';
import '../nexum.dart';
import '../rendering/object.dart';

abstract class Widget {
  const Widget({this.key});
  final Key ? key;
  Element createElement();
}

abstract class BuildContext {
  Widget widget;
  BuildContext(this.widget);
}

abstract class Element extends BuildContext {
  Object ? slot;
  Element ? parent;
  bool mounted = false;
  RenderObject ? renderObject;

  Element(super.widget);

  void mount(Element ? parent, Object ? slot) {
    this.parent = parent;
    this.slot = slot;
    mounted = true;
  }

  void unmount() {
    parent = null;
    slot = null;
    mounted = false;

    renderObject?.dispose();
    renderObject = null;
  }

  void update(Widget newWidget) {
    widget = newWidget;
  }

  bool canUpdate(Widget newWidget) {
    final bool canUpdate = widget.runtimeType == newWidget.runtimeType && widget.key == newWidget.key;

    return canUpdate;
  }
}

abstract class RenderObjectWidget extends Widget {
  const RenderObjectWidget();
  RenderObject createRenderObject();
  void updateRenderObject(RenderObject renderObject);
}

abstract class RenderObjectElement extends Element {
  RenderObjectElement(RenderObjectWidget super.widget);

  @override
  void mount(Element? parent, Object? slot) {
    super.mount(parent, slot);

    renderObject = widget.createRenderObject();
    renderObject!.attach(this);
  }

  @override
  void unmount() {
    renderObject = null;
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    assert(renderObject != null);
    widget.updateRenderObject(renderObject!);
  }

  @override
  RenderObjectWidget get widget => super.widget as RenderObjectWidget;
}

abstract class LeafChildRenderObjectWidget extends RenderObjectWidget {
  const LeafChildRenderObjectWidget();

  @override
  Element createElement() => LeafChildRenderObjectElement(this);
}

class LeafChildRenderObjectElement extends RenderObjectElement {
  LeafChildRenderObjectElement(LeafChildRenderObjectWidget super.widget);
}

abstract class SingleChildRenderObjectWidget extends RenderObjectWidget {
  final Widget ? child;
  const SingleChildRenderObjectWidget({required this.child});

  @override
  Element createElement() => SingleChildRenderObjectElement(this);
}


class SingleChildRenderObjectElement extends RenderObjectElement {
  Element ? _child;
  SingleChildRenderObjectElement(SingleChildRenderObjectWidget super.widget);

  @override
  void mount(Element? parent, Object? slot) {
    super.mount(parent, slot);
    final Element ? child = widget.child?.createElement();

    if(child != null) {
      child.mount(this, null);
      assert(renderObject != null);

      final RenderObject ? childRenderObject = child.renderObject;

      if(childRenderObject != null) {
        renderObject!.adoptChild(childRenderObject);
      }
    }

    _child = child;
  }

  @override
  void unmount() {
    _child?.renderObject?.dispose();
    _child?.unmount();
    _child = null;
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    assert(renderObject != null);

    final Element ? oldChild = _child;
    final Widget ? newChildWidget = widget.child;

    if(oldChild != null && newChildWidget != null && oldChild.canUpdate(newChildWidget)) {
      oldChild.update(newChildWidget);
      return;
    }

    if(newChildWidget == null) {
      if(oldChild != null) {
        final RenderObject ? oldChildRenderObject = oldChild.renderObject;

        if(oldChildRenderObject != null) {
          renderObject!.dropChild(oldChildRenderObject);
        }

        oldChild.unmount();
      }

      _child = null;
      return;
    }

    if(oldChild != null) {
      final RenderObject ? oldChildRenderObject = oldChild.renderObject;

      if(oldChildRenderObject != null) {
        renderObject!.dropChild(oldChildRenderObject);
      }

      oldChild.unmount();
    }

    final Element newChild = _child = newChildWidget.createElement();
    newChild.mount(this, null);

    final RenderObject ? newChildRenderObject = newChild.renderObject;

    if(newChildRenderObject != null) {
      renderObject!.adoptChild(newChildRenderObject);
    }
  }

  @override
  SingleChildRenderObjectWidget get widget => super.widget as SingleChildRenderObjectWidget;
}

abstract class MultiChildRenderObjectWidget extends RenderObjectWidget {
  final List<Widget> childrens;
  const MultiChildRenderObjectWidget(this.childrens);

  @override
  Element createElement() => MultiChildRenderObjectElement(this);
}


class MultiChildRenderObjectElement extends RenderObjectElement {
  List<Element> _childrens = [];
  MultiChildRenderObjectElement(MultiChildRenderObjectWidget super.widget);

  @override
  void mount(Element? parent, Object? slot) {
    super.mount(parent, slot);
    assert(renderObject != null);

    int i = 0;
    _throwIfHasDuplicatedKey(widget.childrens);

    for(final Widget childWidget in widget.childrens) {
      final Element child = childWidget.createElement();
      child.mount(this, i);


      if(child.renderObject != null) {
        renderObject!.adoptChild(child.renderObject!);
      }

      _childrens.add(child);
      i++;
    }
  }

  @override
  void unmount() {
    for(final Element child in _childrens) {
      child.unmount();
    }

    _childrens.clear();

    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    assert(this.renderObject != null);
    final RenderObject renderObject = this.renderObject!;

    final List<Element> newChildrens = [];
    final List<Widget> newChildWidgets = widget.childrens;
    final int length = max(_childrens.length, newChildWidgets.length);

    _throwIfHasDuplicatedKey(newChildWidgets);

    Element ? getOldChildByIndex(int index) => index < _childrens.length ? _childrens[index] : null;

    for(int i = 0; i < length; i++) {
      final Widget ? newChildWidget = i < newChildWidgets.length ? newChildWidgets[i] : null;
      late final Element ? oldChild;

      if(newChildWidget == null) {
        final Element ? findedOldChild = getOldChildByIndex(i);
        oldChild = findedOldChild?.widget.key == null ? findedOldChild : null;
      }else {
        if(newChildWidget.key == null) {
          oldChild = getOldChildByIndex(i);
        }else {
          bool finded = false;

          for(final Element otherOldChild in _childrens) {
            if(newChildWidget.key == otherOldChild.widget.key) {
              oldChild = otherOldChild;
              finded = true;
              break;
            }
          }

          if(!finded) oldChild = null;
        }
      }

      if(newChildWidget != null && oldChild != null) {
        assert(oldChild.renderObject != null);

        if(oldChild.canUpdate(newChildWidget)) {
          oldChild.update(newChildWidget);
          newChildrens.add(oldChild);
          continue;
        }

        final Element newChild = newChildWidget.createElement();
        newChild.mount(this, i);

        assert(newChild.renderObject != null);
        newChildrens.add(newChild);
      }else if(newChildWidget != null){
        final Element newChild = newChildWidget.createElement();
        newChild.mount(this, i);

        assert(newChild.renderObject != null);
        newChildrens.add(newChild);
      }else {
        assert(oldChild != null);
        assert(oldChild!.renderObject != null);
      }
    }

    for(final Element oldChild in _childrens) {
      assert(oldChild.renderObject != null);
      renderObject.dropChild(oldChild.renderObject!);

      if(newChildrens.contains(oldChild)) continue;
      oldChild.unmount();
    }

    for(final Element newChild in newChildrens) {
      assert(newChild.renderObject != null, "${newChild.mounted}");
      renderObject.adoptChild(newChild.renderObject!);
    }

    _childrens = newChildrens;
  }

  void _throwIfHasDuplicatedKey(List<Widget> childrens) {
    for(final Widget child in childrens) {
      for(final Widget otherChild in childrens) {
        if(child == otherChild) continue;
        else if(child.key == null || otherChild.key == null) continue;

        if(otherChild.key == child.key) throw NexumError(
            "Chave duplicada encontrada: ${child.key}\n"
                "Os Widgets: $child e $otherChild tem mesma chave\n"
                "As chaves devem ser únicas entre irmãos"
        );
      }
    }
  }

  @override
  MultiChildRenderObjectWidget get widget => super.widget as MultiChildRenderObjectWidget;
}

abstract class ComponentElement extends Element {
  Element ? _child;
  bool _dirty = true;
  bool get dirty => _dirty;

  ComponentElement(super.widget);

  Widget build();

  @override
  void mount(Element? parent, Object? slot) {
    super.mount(parent, slot);
    final Element child = build().createElement();
    child.mount(this, null);

    _child = child;
    _dirty = false;
  }

  @override
  void unmount() {
    _child?.unmount();
    _child = null;
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    rebuild(force: true);
  }

  Element _updateChild(Element ? oldChild, Widget newChildWidget) {
    final RenderObject ? parentRenderObject = parent?.renderObject;
    assert(parentRenderObject != null);

    if(oldChild != null && oldChild.canUpdate(newChildWidget)) {
      oldChild.update(newChildWidget);
      return oldChild;
    }

    if(oldChild != null) {
      if(parentRenderObject != null && oldChild.renderObject != null) {
        parentRenderObject.dropChild(oldChild.renderObject!);
      }

      oldChild.unmount();
    }

    final Element newChild = newChildWidget.createElement();
    newChild.mount(this, null);

    if(parentRenderObject != null && newChild.renderObject != null) {
      parentRenderObject.adoptChild(newChild.renderObject!);
      parentRenderObject.update();
    }

    return newChild;
  }

  void markNeedsBuild() {
    if(_dirty) return;
    _dirty = true;
    Nexum.instance.scheduleBuildFor(this);
  }

  void rebuild({bool force = false}) {
    if(!_dirty && !force) return;
    _dirty = false;
    _child = _updateChild(_child, build());
  }

  @override
  RenderObject? get renderObject => _child?.renderObject;
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});
  Widget build(BuildContext context);

  @override
  Element createElement() => StatelessElement(this);
}

class StatelessElement extends ComponentElement {
  StatelessElement(StatelessWidget super.widget);

  @override
  Widget build() => widget.build(this);

  @override
  StatelessWidget get widget => super.widget as StatelessWidget;
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key});
  State createState();

  @override
  Element createElement() => StatefulElement(this);
}

class StatefulElement extends ComponentElement {
  State ? _state;

  StatefulElement(StatefulWidget super.widget) : _state = widget.createState() {
    _state!.attach(widget, this);
  }

  @override
  Widget build() => _state!.build(this);

  @override
  void mount(Element? parent, Object? slot) {
    _state!.initState();
    super.mount(parent, slot);
  }

  @override
  void unmount() {
    _state?.dispose();
    _state = null;
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _state!.attach(widget, this);
    rebuild(force: true);
  }

  @override
  StatefulWidget get widget => super.widget as StatefulWidget;
}

abstract class State<T extends StatefulWidget> {
  T ? _widget;
  T get widget => _widget!;

  StatefulElement ? _element;
  StatefulElement get element => _element!;

  Widget build(BuildContext context);

  void setState(VoidCallback update) {
    update.call();
    element.markNeedsBuild();
  }

  void initState() {

  }

  void dispose() {
    _widget = null;
    _element = null;
  }

  void attach(T widget, StatefulElement element) {
    _widget = widget;
    _element = element;
  }
}