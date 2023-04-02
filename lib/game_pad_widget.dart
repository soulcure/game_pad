import 'package:flutter/material.dart';

const double offSize = 44;

class GamePadWidget extends StatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final double? opacity;
  final double size;

  // callbacks
  final VoidCallback? onUpPressed;
  final VoidCallback? onDownPressed;
  final VoidCallback? onRightPressed;
  final VoidCallback? onLeftPressed;
  final Function(double x, double y)? onDrag;

  const GamePadWidget({
    required this.size,
    this.backgroundColor,
    this.iconColor,
    this.opacity,
    this.onUpPressed,
    this.onDownPressed,
    this.onLeftPressed,
    this.onRightPressed,
    this.onDrag,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _GamePadWidgetState();
}

class _GamePadWidgetState extends State<GamePadWidget> {
  double _x = 0;
  double _y = 0;

  double _size = offSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
              color: widget.backgroundColor?.withOpacity(widget.opacity ?? 1) ??
                  Colors.grey.withOpacity(widget.opacity ?? 1),
              shape: BoxShape.circle),
          child: Column(children: [
            // up
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        color: widget.iconColor ?? Colors.black,
                        size: offSize,
                      ),
                      onPressed: () {
                        if (widget.onUpPressed != null) widget.onUpPressed!();
                      },
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
            ),
            // middle
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: widget.iconColor ?? Colors.black,
                        size: offSize,
                      ),
                      onPressed: () {
                        if (widget.onLeftPressed != null) {
                          widget.onLeftPressed!();
                        }
                      },
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: widget.iconColor ?? Colors.black,
                        size: offSize,
                      ),
                      onPressed: () {
                        if (widget.onRightPressed != null) {
                          widget.onRightPressed!();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            // down
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: offSize,
                        color: widget.iconColor ?? Colors.black,
                      ),
                      onPressed: () {
                        if (widget.onDownPressed != null) {
                          widget.onDownPressed!();
                        }
                      },
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
            ),
          ]),
        ),
        Positioned(
          left: 0,
          top: 0,
          right: _x,
          bottom: _y,
          child: GestureDetector(
            onPanStart: (values) {
              debugPrint("onPanStart");
              setState(() {
                _size = offSize * 1.5;
              });
            },
            onPanUpdate: (values) {
              setState(() {
                if (_x.abs() >= offSize || _y.abs() >= offSize) {
                  debugPrint("onPanUpdate out of range");
                  return;
                }

                _x -= values.delta.dx;
                _y -= values.delta.dy;

                debugPrint(
                    "onPanUpdate values.delta.dx:${values.delta.dx} values.delta.dy:${values.delta.dy}");
                debugPrint("onPanUpdate _x:$_x _y:$_y");

                if (_x.abs() >= offSize) {}

                if (widget.onDrag != null) {
                  widget.onDrag!(values.delta.dx, values.delta.dy);
                }
              });
            },
            onPanEnd: (values) {
              debugPrint("onPanEnd");
              _size = offSize;
              _x = 0;
              _y = 0;
              setState(() {});
            },
            child: Icon(
              Icons.drag_handle,
              color: widget.iconColor ?? Colors.black,
              size: _size,
            ),
          ),
        )
      ],
    );
  }
}
