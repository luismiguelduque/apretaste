import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/mirrors/mirrors_bloc.dart';

showNoMirrorDialog({
  required BuildContext context,
}) {
  AlertDialog alert = AlertDialog(
    contentPadding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 15),
    actionsPadding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(23.0))
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Image(
          fit: BoxFit.cover,
          height: 80,
          image: AssetImage("assets/images/bot-down.png")
        ),
        SizedBox(width: 10,),
        Flexible(
          child: Text(
            "No encontramos ningún servidor espejo para conectarte. Intenta nuevamente, y si recibes este error trata en un rato, usa un VPN, o escríbenos al soporte.",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        )
      ],
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      SizedBox(
        width: 120,
        child: TextButton(
          onPressed: (){
            context.read<MirrorsBloc>().add(OnConnectToMirrorEvent());
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text("Reintentar"),
        )
      ),
    ],
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
