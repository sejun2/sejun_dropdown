import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_playground/triangle_custom_painter.dart';

class RnDropdown extends StatefulWidget {
  RnDropdown(
      {Key? key,
      this.buttonWidth = 146.0,
      this.buttonHeight = 46.0,
      required this.dropdownItemList,
      required this.hintText,
      this.dropdownCallback})
      : super(key: key);

  DropdownCallback? dropdownCallback;

  double? buttonWidth;
  double? buttonHeight;

  final String hintText;
  final List dropdownItemList;

  @override
  State<RnDropdown> createState() => _RnDropdownState();
}

class _RnDropdownState extends State<RnDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isShowing = false;

  Key scaffoldKey = UniqueKey();

  late String _selectedItem;

  @override
  void initState() {
    _overlayEntry = buildOverlayEntry(context);
    _selectedItem = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CompositedTransformTarget(
              link: _layerLink,
              child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  onTap: () {
                    setState(() {
                      if (isShowing) {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                      } else {
                        _overlayEntry = buildOverlayEntry(context);
                        Overlay.of(context)?.insert(_overlayEntry!);
                      }
                      isShowing = !isShowing;
                    });
                  },
                  child: buildMainButton()),
            ),
          ],
        ),
      ],
    );
  }

  AnimatedContainer buildMainButton() {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          // borderRadius: isShowing
          //     ? const BorderRadius.only(
          //         topRight: Radius.circular(14), topLeft: Radius.circular(14))
          //     : const BorderRadius.all(Radius.circular(14)),
          // border: Border.all(
          //     width: 1,
          //     style: BorderStyle.solid,
          //     color: Colors.grey.withOpacity(0.6)),
          ),
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      duration: const Duration(milliseconds: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_selectedItem),
          AnimatedRotation(
            child: const Icon(Icons.keyboard_arrow_down),
            duration: const Duration(milliseconds: 140),
            turns: isShowing ? 0.5 : 0,
          ),
        ],
      ),
    );
  }

  OverlayEntry buildOverlayEntry(BuildContext ctx) {
    return OverlayEntry(builder: (ctx) {
      return Positioned(
        key: scaffoldKey,
        width: widget.buttonWidth,
        child: CompositedTransformFollower(
            offset: Offset(0, widget.buttonHeight! - 1),
            link: _layerLink,
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(
                  height: 10,
                  child: CustomPaint(
                    painter: TriangleCustomPainter(),
                  ),
                ),
                Positioned(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0))),
                    height: widget.dropdownItemList.length <= 5
                        ? widget.buttonHeight! *
                            widget.dropdownItemList.length
                        : widget.buttonHeight! * 5,
                    child: SizedBox(
                      height: widget.dropdownItemList.length <= 5
                          ? widget.buttonHeight! *
                              widget.dropdownItemList.length
                          : widget.buttonHeight! * 5,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: widget.dropdownItemList
                            .map((item) => RnDropdownChild(
                                  title: item,
                                  height: widget.buttonHeight!,
                                  dropdownCallback: (String selectedItem) {
                                    setState(() {
                                      _selectedItem = selectedItem;
                                      if (widget.dropdownCallback != null) {
                                        widget
                                            .dropdownCallback!(selectedItem);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ]),
            )),
      );
    });
  }
}

typedef DropdownCallback = Function(String selectedItem);

class RnDropdownChild extends StatefulWidget {
  const RnDropdownChild(
      {Key? key,
      required this.title,
      required this.height,
      required this.dropdownCallback})
      : super(key: key);

  final String title;
  final double height;

  final DropdownCallback dropdownCallback;

  @override
  State<RnDropdownChild> createState() => _RnDropdownChildState();
}

class _RnDropdownChildState extends State<RnDropdownChild> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.dropdownCallback.call(widget.title);
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(widget.title),
      ),
    );
  }
}
