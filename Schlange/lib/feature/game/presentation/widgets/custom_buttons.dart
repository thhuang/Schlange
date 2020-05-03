import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonUp extends OptionButton {
  ButtonUp({Color color, void Function() onPressed})
      : super(FontAwesomeIcons.caretUp, color: color, onPressed: onPressed);
}

class ButtonDown extends OptionButton {
  ButtonDown({Color color, void Function() onPressed})
      : super(FontAwesomeIcons.caretDown, color: color, onPressed: onPressed);
}

class ButtonLeft extends OptionButton {
  ButtonLeft({Color color, void Function() onPressed})
      : super(FontAwesomeIcons.caretLeft, color: color, onPressed: onPressed);
}

class ButtonRight extends OptionButton {
  ButtonRight({Color color, void Function() onPressed})
      : super(FontAwesomeIcons.caretRight, color: color, onPressed: onPressed);
}

class OptionButton extends StatelessWidget {
  const OptionButton(
    this.iconData, {
    Key key,
    @required this.onPressed,
    this.color,
  })  : assert(onPressed != null),
        super(key: key);

  final IconData iconData;
  final void Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      icon: Icon(
        iconData,
        color: color ?? Theme.of(context).primaryColor,
        size: 20.0,
      ),
      onPressed: onPressed,
      padding: EdgeInsets.all(10.0),
      fillColor: Theme.of(context).backgroundColor,
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2.0,
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key key,
    this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.all(11.0),
    this.elevation = 2.0,
    this.borderSide = BorderSide.none,
    this.fillColor,
    this.splashColor,
  }) : super(key: key);

  final Icon icon;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final BorderSide borderSide;
  final Color fillColor;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: icon,
      shape: CircleBorder(side: borderSide),
      padding: padding,
      elevation: elevation,
      fillColor: fillColor ?? Theme.of(context).primaryColor,
      splashColor: splashColor ?? Theme.of(context).primaryColorLight,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
    );
  }
}
