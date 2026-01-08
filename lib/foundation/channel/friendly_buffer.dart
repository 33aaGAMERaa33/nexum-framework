import 'dart:convert';
import 'dart:typed_data';

enum _Types {
  integer(0),
  bool(1),
  float(2),
  double(3),
  string(4);

  final int id;
  const _Types(this.id);

  static _Types fromId(int id) {
    return _Types.values.firstWhere(
          (e) => e.id == id,
      orElse: () => throw StateError('Tipo desconhecido: $id'),
    );
  }
}

class _MismatchedTypesException implements Exception {
  final _Types expected;
  final _Types received;

  _MismatchedTypesException(this.expected, this.received);

  @override
  String toString() => 'Tipo incompatível: esperado $expected, recebido $received';
}

class FriendlyBuffer {
  final List<int> _buffer = [];
  int _readOffset = 0;

  FriendlyBuffer();

  FriendlyBuffer.fromBytes(List<int> bytes) {
    _buffer.addAll(bytes);
  }

  bool get isEOF => _readOffset >= _buffer.length;

  void _writeType(_Types type) => _buffer.add(type.id);

  void writeInt(int value) {
    _writeType(_Types.integer);
    final bd = ByteData(4)..setUint32(0, value, Endian.little);
    _buffer.addAll(bd.buffer.asUint8List());
  }

  void writeBool(bool value) {
    _writeType(_Types.bool);
    _buffer.add(value ? 1 : 0);
  }

  void writeFloat(double value) {
    _writeType(_Types.float);
    final bd = ByteData(4)..setFloat32(0, value, Endian.little);
    _buffer.addAll(bd.buffer.asUint8List());
  }

  void writeDouble(double value) {
    _writeType(_Types.double);
    final bd = ByteData(8)..setFloat64(0, value, Endian.little);
    _buffer.addAll(bd.buffer.asUint8List());
  }

  void writeString(String value) {
    _writeType(_Types.string);
    final bytes = utf8.encode(value);
    final bd = ByteData(4)..setUint32(0, bytes.length, Endian.little);
    _buffer.addAll(bd.buffer.asUint8List());
    _buffer.addAll(bytes);
  }

  _Types _readType() => _Types.fromId(_buffer[_readOffset++]);

  int readInt() {
    final type = _readType();
    if (type != _Types.integer) {
      throw _MismatchedTypesException(_Types.integer, type);
    }

    final bd = ByteData.sublistView(
      Uint8List.fromList(_buffer.sublist(_readOffset, _readOffset + 4)),
    );
    _readOffset += 4;
    return bd.getUint32(0, Endian.little);
  }

  bool readBool() {
    final type = _readType();
    if (type != _Types.bool) {
      throw _MismatchedTypesException(_Types.bool, type);
    }
    return _buffer[_readOffset++] != 0;
  }

  double readFloat() {
    final type = _readType();
    if (type != _Types.float) {
      throw _MismatchedTypesException(_Types.float, type);
    }

    final bd = ByteData.sublistView(
      Uint8List.fromList(_buffer.sublist(_readOffset, _readOffset + 4)),
    );
    _readOffset += 4;
    return bd.getFloat32(0, Endian.little);
  }

  double readDouble() {
    final type = _readType();
    if (type != _Types.double) {
      throw _MismatchedTypesException(_Types.double, type);
    }

    final bd = ByteData.sublistView(
      Uint8List.fromList(_buffer.sublist(_readOffset, _readOffset + 8)),
    );
    _readOffset += 8;
    return bd.getFloat64(0, Endian.little);
  }

  String readString() {
    final type = _readType();

    if(type != _Types.string) {
      throw _MismatchedTypesException(_Types.string, type);
    }

    final lenBd = ByteData.sublistView(
      Uint8List.fromList(_buffer.sublist(_readOffset, _readOffset + 4)),
    );
    final len = lenBd.getUint32(0, Endian.little);
    _readOffset += 4;

    final strBytes = _buffer.sublist(_readOffset, _readOffset + len);
    _readOffset += len;

    return utf8.decode(strBytes);
  }

  List<int> toBytes() => List.unmodifiable(_buffer);
}
