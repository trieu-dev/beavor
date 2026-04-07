// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'living_expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomExpenseItemAdapter extends TypeAdapter<CustomExpenseItem> {
  @override
  final int typeId = 6;

  @override
  CustomExpenseItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomExpenseItem(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CustomExpenseItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomExpenseItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LivingExpenseModelAdapter extends TypeAdapter<LivingExpenseModel> {
  @override
  final int typeId = 5;

  @override
  LivingExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LivingExpenseModel(
      id: fields[0] as String,
      month: fields[1] as DateTime,
      rent: fields[2] as double,
      electricityPrevious: fields[3] as double,
      electricityCurrent: fields[4] as double,
      water: fields[5] as double,
      serviceFee: fields[6] as double,
      otherFees: fields[7] as double,
      note: fields[8] as String?,
      food: fields[9] as double,
      transport: fields[10] as double,
      customExpenses: (fields[11] as List).cast<CustomExpenseItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, LivingExpenseModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.rent)
      ..writeByte(3)
      ..write(obj.electricityPrevious)
      ..writeByte(4)
      ..write(obj.electricityCurrent)
      ..writeByte(5)
      ..write(obj.water)
      ..writeByte(6)
      ..write(obj.serviceFee)
      ..writeByte(7)
      ..write(obj.otherFees)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.food)
      ..writeByte(10)
      ..write(obj.transport)
      ..writeByte(11)
      ..write(obj.customExpenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LivingExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
