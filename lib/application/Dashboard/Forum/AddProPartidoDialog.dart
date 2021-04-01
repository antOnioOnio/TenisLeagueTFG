import 'package:flutter/material.dart';

class AddProPartidoDialog extends StatefulWidget {
  @override
  _AddProPartidoDialogState createState() => _AddProPartidoDialogState();
}

class _AddProPartidoDialogState extends State<AddProPartidoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: something(),
    );
  }

  Widget something() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.redAccent,
    );
  }
}
