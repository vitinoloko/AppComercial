import 'package:appcatalogo/page/cadastro_produto/food_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class ImageEditorWidget extends StatefulWidget {
  final Uint8List imageBytes;
  final void Function(Uint8List croppedImage, Size size)? onImageCropped;

  const ImageEditorWidget({
    super.key,
    required this.imageBytes,
    this.onImageCropped,
  });

  @override
  State<ImageEditorWidget> createState() => _ImageEditorWidgetState();
}

class _ImageEditorWidgetState extends State<ImageEditorWidget> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final FoodController controller = Get.find();
  Uint8List? displayImageBytes;
  double progress = 0.0;
  final double cropSize = 500;

  @override
  void initState() {
    super.initState();
    _prepareImage();
  }

  Future<void> _prepareImage() async {
    setState(() => progress = 0.1);

    if (widget.imageBytes.lengthInBytes > 5 * 1024 * 1024) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Imagem muito pesada!')));
      return;
    }

    final resized = await compute(_resizeIsolate, {
      'bytes': widget.imageBytes,
      'maxSize': 600,
    });

    if (resized == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao processar imagem.')),
      );
      return;
    }

    setState(() {
      displayImageBytes = resized;
      progress = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (displayImageBytes == null) {
      return Center(
        child: Column(
          children: [
            const Text("Carregando imagem..."),
            const SizedBox(height: 16),
            CircularProgressIndicator(value: progress),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          ExtendedImage.memory(
            displayImageBytes!,
            width: cropSize,
            height: cropSize,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            extendedImageEditorKey: editorKey,
            initEditorConfigHandler: (state) => EditorConfig(
              maxScale: 8.0,
              cropRectPadding: EdgeInsets.zero,
              hitTestSize: 20.0,
              cropAspectRatio: 1.0,
              cornerSize: const Size(20, 20),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final state = editorKey.currentState!;
              final croppedBytes = await cropImageWithFixedSize(
                state,
                cropSize.toInt(),
              );
              if (croppedBytes != null) {
                final decoded = await decodeImageFromList(croppedBytes);
                widget.onImageCropped?.call(
                  croppedBytes,
                  Size(decoded.width.toDouble(), decoded.height.toDouble()),
                );
              }
            },
            child: const Text("Cortar e aplicar"),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              controller.mostrarEditor.value = false;
            },
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}

Uint8List? _resizeIsolate(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes'];
  final int maxSize = params['maxSize'];

  final img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  final img.Image resized = img.copyResize(
    decoded,
    width: decoded.width > decoded.height ? maxSize : null,
    height: decoded.height >= decoded.width ? maxSize : null,
    interpolation: img.Interpolation.average,
  );

  return Uint8List.fromList(img.encodeJpg(resized, quality: 75));
}

Future<Uint8List?> cropImageWithFixedSize(
  ExtendedImageEditorState state,
  int fixedSize,
) async {
  final Uint8List imgBytes = state.rawImageData;
  final img.Image? decodedImage = img.decodeImage(imgBytes);
  if (decodedImage == null) return null;

  final Rect? cropRect = state.getCropRect();
  if (cropRect == null) return null;

  final int x = cropRect.left.round();
  final int y = cropRect.top.round();
  final int width = cropRect.width.round();
  final int height = cropRect.height.round();

  final img.Image cropped = img.copyCrop(
    decodedImage,
    x: x,
    y: y,
    width: width,
    height: height,
  );
  final img.Image resized = img.copyResize(
    cropped,
    width: fixedSize,
    height: fixedSize,
  );

  return Uint8List.fromList(img.encodeJpg(resized));
}

class EditedImageResult {
  final Uint8List bytes;
  final Size size;

  EditedImageResult({required this.bytes, required this.size});
}
