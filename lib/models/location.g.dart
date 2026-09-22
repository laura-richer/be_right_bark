// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 0;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      createdAt: fields[3] as DateTime,
      name: fields[4] as String?,
      description: fields[5] as String?,
      status: fields[6] as SpotStatus?,
      notifiedAt: fields[7] as DateTime?,
      resolvedAt: fields[8] as DateTime?,
      fencesRegistered: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.notifiedAt)
      ..writeByte(8)
      ..write(obj.resolvedAt)
      ..writeByte(9)
      ..write(obj.fencesRegistered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
