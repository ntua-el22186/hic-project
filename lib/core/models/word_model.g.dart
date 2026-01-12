// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordModelAdapter extends TypeAdapter<WordModel> {
  @override
  final int typeId = 0;

  @override
  WordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordModel(
      word: fields[0] as String,
      phonetic: fields[1] as String,
      definition: fields[2] as String,
      examples: (fields[3] as List).cast<String>(),
      personalNote: fields[4] as String?,
      correctAnswers: fields[5] as int,
      wrongAnswers: fields[6] as int,
      lastPracticed: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WordModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.phonetic)
      ..writeByte(2)
      ..write(obj.definition)
      ..writeByte(3)
      ..write(obj.examples)
      ..writeByte(4)
      ..write(obj.personalNote)
      ..writeByte(5)
      ..write(obj.correctAnswers)
      ..writeByte(6)
      ..write(obj.wrongAnswers)
      ..writeByte(7)
      ..write(obj.lastPracticed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
