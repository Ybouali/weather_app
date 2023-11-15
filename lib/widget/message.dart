import 'package:flutter/material.dart';

enum InfoAppMessageType {
  info,
  error,
  warn,
}

class DataDesign {
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;
  DataDesign({
    this.textColor = Colors.black87,
    this.backgroundColor = Colors.amber,
    this.icon = Icons.warning,
  });

  DataDesign.info()
      : textColor = Colors.black87,
        backgroundColor = Colors.blue,
        icon = Icons.info;

  DataDesign.error()
      : textColor = Colors.black87,
        backgroundColor = Colors.red,
        icon = Icons.error;
}

class InfoAppMessages {
  static final InfoAppMessages _instance = InfoAppMessages._internal();

  factory InfoAppMessages() {
    return _instance;
  }

  InfoAppMessages._internal();

  showMessage(
    InfoAppMessageType type,
    String message,
  ) {
    DataDesign disagn = DataDesign();

    switch (type) {
      case InfoAppMessageType.warn:
        break;
      case InfoAppMessageType.info:
        disagn = DataDesign.info();
        break;
      case InfoAppMessageType.error:
        disagn = DataDesign.error();
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: disagn.backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              disagn.icon,
              size: 20,
              color: disagn.textColor,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message,
                style: TextStyle(
                  color: disagn.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
