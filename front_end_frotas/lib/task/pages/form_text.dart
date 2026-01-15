import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  const FormText({super.key});

  @override
  Widget build(BuildContext context) {
    print('FormText construindo!');
    return Container(
      color: Colors.red,
      child: Row(
        children: [
          Column(
            children: [
              TextButton(
                onPressed: () {
                  context.beamToNamed('/home');
                },
                child: Text('Botao para voltar para home'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
