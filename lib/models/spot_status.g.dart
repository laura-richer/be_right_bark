// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpotStatusAdapter extends TypeAdapter<SpotStatus> {
  @override
  final int typeId = 1;

  @override
  SpotStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SpotStatus.dropped;
      case 1:
        return SpotStatus.armed;
      case 2:
        return SpotStatus.notified;
      case 3:
        return SpotStatus.collected;
      case 4:
        return SpotStatus.abandoned;
      default:
        return SpotStatus.dropped;
    }
  }

  @override
  void write(BinaryWriter writer, SpotStatus obj) {
    switch (obj) {
      case SpotStatus.dropped:
        writer.writeByte(0);
        break;
      case SpotStatus.armed:
        writer.writeByte(1);
        break;
      case SpotStatus.notified:
        writer.writeByte(2);
        break;
      case SpotStatus.collected:
        writer.writeByte(3);
        break;
      case SpotStatus.abandoned:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
