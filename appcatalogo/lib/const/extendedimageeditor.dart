import 'package:appcatalogo/page/cadastro_produto/food_controller.dart'; // Importa o controlador de alimentos, provavelmente para gerenciar o estado da UI (como mostrar/ocultar o editor).
import 'package:extended_image/extended_image.dart'; // Biblioteca para edição e exibição avançada de imagens.
import 'package:flutter/material.dart'; // Pacote fundamental do Flutter para construção de UI.
import 'package:flutter/foundation.dart'; // Utilitários do Flutter, incluindo `compute` para processamento em isolados.
import 'package:get/get.dart'; // Framework para gerenciamento de estado e injeção de dependências (usado aqui para o `FoodController`).
import 'package:image/image.dart'
    as img; // Biblioteca para manipulação de imagens (redimensionar, cortar, decodificar, etc.).

// Widget principal que permite a edição (corte) de uma imagem.
class ImageEditorWidget extends StatefulWidget {
  final Uint8List imageBytes; // Os bytes da imagem original a ser editada.
  final void Function(Uint8List croppedImage, Size size)?
  onImageCropped; // Callback chamado quando a imagem é cortada, retorna os bytes da imagem cortada e seu tamanho.

  const ImageEditorWidget({
    super.key, // Chave do widget.
    required this.imageBytes, // A imagem é obrigatória.
    this.onImageCropped, // Callback opcional.
  });

  @override
  State<ImageEditorWidget> createState() => _ImageEditorWidgetState();
}

class _ImageEditorWidgetState extends State<ImageEditorWidget> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<
        ExtendedImageEditorState
      >(); // Chave global para controlar o estado do `ExtendedImageEditor`.
  final FoodController controller =
      Get.find(); // Encontra e injeta uma instância do `FoodController`.
  Uint8List?
  displayImageBytes; // Os bytes da imagem que será exibida no editor (pode ser redimensionada).
  double progress =
      0.0; // Variável para controlar o progresso do carregamento/processamento da imagem.
  final double cropSize =
      500; // Tamanho fixo (largura/altura) para o crop e redimensionamento final da imagem.

  @override
  void initState() {
    super.initState();
    // Agenda a preparação da imagem para ser executada após o primeiro frame ser construído.
    // Isso resolve o erro de `ScaffoldMessenger.of(context)` ser chamado antes do widget estar completamente montado.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareImage();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Este método é chamado após initState e sempre que as dependências do widget mudam.
    // É o local seguro para acessar InheritedWidgets (como Theme, MediaQuery, ScaffoldMessenger).
    // No seu código atual, as chamadas para showSnackBar já estão dentro de _prepareImage,
    // que é chamado após o primeiro frame, então essa didChangeDependencies não tem lógica adicional por enquanto.
  }

  // Prepara a imagem para exibição no editor, incluindo validações e redimensionamento.
  Future<void> _prepareImage() async {
    setState(() => progress = 0.1); // Inicia o progresso.

    // --- Validação de Tamanho da Imagem ---
    const int maxImageSizeBytes =
        5 *
        1024 *
        1024; // Define o tamanho máximo permitido para a imagem (5 MB).
    if (widget.imageBytes.lengthInBytes > maxImageSizeBytes) {
      _showSnackBar(
        'Imagem muito grande! O tamanho máximo permitido é 5MB.',
      ); // Exibe mensagem de erro.
      setState(() => progress = 0.0); // Reseta o progresso.
      controller.mostrarEditor.value =
          false; // Fecha o editor se a imagem for muito grande.
      return; // Interrompe o processamento.
    }

    // --- Validação de Formato e Corrupção Inicial ---
    // Tenta decodificar a imagem para verificar se é um formato válido e não está corrompida.
    final img.Image? initialDecodedImage = img.decodeImage(widget.imageBytes);
    if (initialDecodedImage == null) {
      _showSnackBar(
        'Formato de imagem não suportado ou imagem corrompida.',
      ); // Exibe mensagem de erro.
      setState(() => progress = 0.0); // Reseta o progresso.
      controller.mostrarEditor.value =
          false; // Fecha o editor se o formato for inválido/corrompido.
      return; // Interrompe o processamento.
    }

    // Redimensiona a imagem em um Isolate (processo separado) para evitar travamento da UI.
    final resized = await compute(_resizeIsolate, {
      'bytes': widget.imageBytes, // Os bytes da imagem original.
      'maxSize':
          600, // Tamanho máximo para o lado maior da imagem após redimensionamento inicial.
    });

    // --- Validação de Falha no Processamento (redimensionamento) ---
    if (resized == null) {
      _showSnackBar('Falha ao processar imagem.'); // Exibe mensagem de erro.
      setState(() => progress = 0.0); // Reseta o progresso.
      controller.mostrarEditor.value =
          false; // Fecha o editor em caso de falha no redimensionamento.
      return; // Interrompe o processamento.
    }

    // Atualiza o estado com a imagem redimensionada e finaliza o progresso.
    setState(() {
      displayImageBytes = resized; // A imagem redimensionada para exibição.
      progress = 1.0; // Progresso completo.
    });
  }

  // Função auxiliar para exibir um SnackBar (mensagem temporária na parte inferior da tela).
  void _showSnackBar(String message) {
    if (mounted) {
      // Verifica se o widget ainda está montado na árvore de widgets antes de tentar exibir o SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Acessa o ScaffoldMessenger para mostrar o SnackBar.
        SnackBar(content: Text(message)), // O conteúdo da mensagem.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se a imagem ainda não foi carregada/processada, exibe um indicador de carregamento.
    if (displayImageBytes == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Carregando imagem..."), // Mensagem de carregamento.
            const SizedBox(height: 16), // Espaçamento.
            CircularProgressIndicator(
              value: progress,
            ), // Indicador de progresso.
          ],
        ),
      );
    }

    // Se a imagem foi carregada, exibe o editor de imagem e os botões.
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(150, 0, 0, 0),
        borderRadius: BorderRadius.circular(18),
      ),
      width: 700,
      height: 700,

      child: Center(
        child: Column(
          children: [
            // Widget `ExtendedImage.memory` para exibir a imagem e permitir edição.
            ExtendedImage.memory(
              displayImageBytes!, // Os bytes da imagem para exibir.
              width: cropSize, // Largura fixa para a área de edição.
              height: cropSize, // Altura fixa para a área de edição.
              fit: BoxFit.contain, // A imagem se ajusta dentro da área.
              mode: ExtendedImageMode
                  .editor, // Habilita o modo de edição (zoom, pan, crop).
              extendedImageEditorKey: editorKey, // Vincula à chave do editor.
              // Configurações do editor.
              initEditorConfigHandler: (state) => EditorConfig(
                maxScale: 8.0, // Zoom máximo permitido.
                cropRectPadding: EdgeInsets
                    .zero, // Sem preenchimento ao redor da área de corte.
                hitTestSize:
                    20.0, // Tamanho da área clicável para redimensionar o crop.
                cropAspectRatio: 1.0, // Proporção do corte (1.0 = quadrado).
                cornerSize: const Size(
                  20,
                  20,
                ), // Tamanho dos manipuladores de canto do crop.
              ),
            ),
            // Botão para cortar e aplicar a imagem.
            ElevatedButton(
              onPressed: () async {
                final state =
                    editorKey.currentState!; // Obtém o estado atual do editor.
                // Chama a função para cortar e redimensionar a imagem para o tamanho fixo.
                final croppedBytes = await cropImageWithFixedSize(
                  state,
                  cropSize.toInt(), // Converte cropSize para int.
                );
                if (croppedBytes != null) {
                  // Se o corte foi bem-sucedido.
                  // Decodifica a imagem cortada para obter suas dimensões.
                  final decoded = await decodeImageFromList(croppedBytes);
                  // Chama o callback `onImageCropped` com os bytes da imagem final e seu tamanho.
                  widget.onImageCropped?.call(
                    croppedBytes,
                    Size(decoded.width.toDouble(), decoded.height.toDouble()),
                  );
                } else {
                  _showSnackBar(
                    'Falha ao cortar a imagem.',
                  ); // Exibe mensagem de erro se o corte falhar.
                }
              },
              child: const Text("Cortar e aplicar"), // Texto do botão.
            ),
            const SizedBox(height: 15), // Espaçamento.
            // Botão para cancelar a edição.
            ElevatedButton(
              onPressed: () {
                controller.mostrarEditor.value =
                    false; // Define como false para fechar o editor.
              },
              child: const Text("Cancelar"), // Texto do botão.
            ),
          ],
        ),
      ),
    );
  }
}

// --- Funções de Manipulação de Imagem (executadas em Isolates) ---

// Função para redimensionar uma imagem, executada em um Isolate separado para não bloquear a UI.
Uint8List? _resizeIsolate(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes']; // Bytes da imagem de entrada.
  final int maxSize = params['maxSize']; // Tamanho máximo para o lado maior.

  // Decodifica a imagem. Retorna null se for inválida/corrompida.
  final img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  // Redimensiona a imagem mantendo a proporção.
  // O lado maior é ajustado para `maxSize`, o outro lado é calculado automaticamente.
  final img.Image resized = img.copyResize(
    decoded,
    width: decoded.width > decoded.height
        ? maxSize
        : null, // Se largura maior, define largura.
    height: decoded.height >= decoded.width
        ? maxSize
        : null, // Se altura maior ou igual, define altura.
    interpolation: img
        .Interpolation
        .average, // Algoritmo de interpolação para suavizar o redimensionamento.
  );

  // Codifica a imagem redimensionada para JPG com qualidade 75 e retorna os bytes.
  return Uint8List.fromList(img.encodeJpg(resized, quality: 75));
}

// Função para cortar e redimensionar a imagem para um tamanho fixo, executada em um Isolate.
Future<Uint8List?> cropImageWithFixedSize(
  ExtendedImageEditorState state, // O estado do editor de imagem.
  int fixedSize, // O tamanho final desejado para a imagem (largura e altura).
) async {
  final Uint8List imgBytes = state
      .rawImageData; // Obtém os bytes da imagem original no estado do editor.
  // Decodifica a imagem. Retorna null se for inválida/corrompida.
  final img.Image? decodedImage = img.decodeImage(imgBytes);
  if (decodedImage == null) return null;

  final Rect? cropRect = state
      .getCropRect(); // Obtém o retângulo de corte definido pelo usuário.
  if (cropRect == null)
    return null; // Se não houver retângulo de corte, retorna null.

  // Calcula as coordenadas e dimensões inteiras do retângulo de corte.
  final int x = cropRect.left.round();
  final int y = cropRect.top.round();
  final int width = cropRect.width.round();
  final int height = cropRect.height.round();

  // Corta a imagem com base no retângulo de corte.
  final img.Image cropped = img.copyCrop(
    decodedImage,
    x: x,
    y: y,
    width: width,
    height: height,
  );

  // Verifica se a imagem cortada tem dimensões válidas.
  if (cropped.width == 0 || cropped.height == 0) return null;

  // Redimensiona a imagem cortada para o `fixedSize` especificado.
  final img.Image resized = img.copyResize(
    cropped,
    width: fixedSize,
    height: fixedSize,
  );

  // Codifica a imagem final para JPG e retorna os bytes.
  return Uint8List.fromList(img.encodeJpg(resized));
}

// Classe simples para empacotar os bytes da imagem editada e seu tamanho.
class EditedImageResult {
  final Uint8List bytes; // Os bytes da imagem final.
  final Size size; // O tamanho (largura e altura) da imagem final.

  EditedImageResult({required this.bytes, required this.size});
}
