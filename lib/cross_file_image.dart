import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Decodes the given [XFile] object as an image, associating it with the given
/// scale.
///
/// The provider does not monitor the file for changes. If you expect the
/// underlying data to change, you should call the [evict] method.
@immutable
class XFileImage extends ImageProvider<XFileImage> {
  /// Creates an object that decodes a [XFile] as an image.
  ///
  /// The arguments must not be null.
  const XFileImage(this.file, {this.scale = 1.0});

  /// The file to decode into an image.
  final XFile file;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  @override
  Future<XFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<XFileImage>(this);
  }

  @override
  ImageStreamCompleter load(XFileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.file.path,
      informationCollector: () sync* {
        yield ErrorDescription('Path: ${file.path}');
      },
    );
  }

  Future<ui.Codec> _loadAsync(XFileImage key, DecoderCallback decode) async {
    final Uint8List bytes = await file.readAsBytes();

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance!.imageCache!.evict(key);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }

    return decode(bytes);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is XFileImage &&
        other.file.path == file.path &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(file.path, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'XFileImage')}("${file.path}", scale: $scale)';
}
