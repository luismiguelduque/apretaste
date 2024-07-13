import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../blocs/mirrors/mirrors_bloc.dart';

final getIt = GetIt.instance;


showNewMirrorDialog({
  required BuildContext context,
}) async {
  String mirror='';
  AlertDialog alert = AlertDialog(
    titlePadding: const EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 14),
    contentPadding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 10),
    actionsPadding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28.0))
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Modo desarrollo"),
        IconButton(
          onPressed: (){
            context.read<MirrorsBloc>().add(OnConnectToMirrorEvent());
            context.read<MirrorsBloc>().add(const OnDeveloperModeChanged(false));
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: const Icon(Icons.cancel_outlined)
        )
      ],
    ),
    content: BlocBuilder<MirrorsBloc, MirrorsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 45,
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('Ingresa nuevo mirror'),
                        border: OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.black)
                        ),
                      ),
                      onChanged: (value){
                        mirror = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 5,),
                  if(state.devModeFailed)
                    const Text(
                      "El espejo insertado es inválido",
                      style: TextStyle(color: Colors.red),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: (){
                            context.read<MirrorsBloc>().add(
                              OnChangeManualInsertedMirror(mirror)
                            );
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: state.devModeChecking
                            ? const SizedBox(
                                height: 23,
                                width: 23,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              )
                            : const Text("Agregar"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                ],
              ),
            )
          ],
        );
      },
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
