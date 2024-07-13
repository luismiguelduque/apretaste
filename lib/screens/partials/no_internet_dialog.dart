import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/mirrors/mirrors_bloc.dart';

showNoInternetDialog({
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
            "Tu teléfono no está conectado. Quizás no tienes los datos o el wifi activado, o estás en modo avión. Por favor revisa la conectividad e intenta nuevamente.",
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
