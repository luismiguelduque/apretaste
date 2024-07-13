import 'package:flutter/material.dart';

showSearchingDialog({
  required BuildContext context,
}) {
  AlertDialog alert = AlertDialog(
    contentPadding: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 15),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(23.0))
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Image(
              fit: BoxFit.cover,
              height: 80,
              image: AssetImage("assets/images/bot-neutral.png")
            ),
            SizedBox(width: 10,),
            Flexible(
              child: Text(
                "Estamos buscando un servidor espejo para conectarte; este proceso puede tardar unos minutos.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: LinearProgressIndicator(),
        )
      ],
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
