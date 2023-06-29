// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TraySelectionFinal.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $TrayEquippedViewModel {
  const $TrayEquippedViewModel();

  String get deviceId;
  DeviceConnectionState get connectionStatus;
  BleDeviceConnector get deviceConnector;
  Future<List<DiscoveredService>> Function() get discoverServices;

  TrayEquippedViewModel copyWith({
    String? deviceId,
    DeviceConnectionState? connectionStatus,
    BleDeviceConnector? deviceConnector,
    Future<List<DiscoveredService>> Function()? discoverServices,
  }) =>
      TrayEquippedViewModel(
        deviceId: deviceId ?? this.deviceId,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        deviceConnector: deviceConnector ?? this.deviceConnector,
        discoverServices: discoverServices ?? this.discoverServices,
      );

  TrayEquippedViewModel copyUsing(
      void Function(TrayEquippedViewModel$Change change) mutator) {
    final change = TrayEquippedViewModel$Change._(
      this.deviceId,
      this.connectionStatus,
      this.deviceConnector,
      this.discoverServices,
    );
    mutator(change);
    return TrayEquippedViewModel(
      deviceId: change.deviceId,
      connectionStatus: change.connectionStatus,
      deviceConnector: change.deviceConnector,
      discoverServices: change.discoverServices,
    );
  }

  @override
  String toString() =>
      "TrayEquippedViewModel(deviceId: $deviceId, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, discoverServices: $discoverServices)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is TrayEquippedViewModel &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectionStatus == other.connectionStatus &&
      deviceConnector == other.deviceConnector &&
      const Ignore().equals(discoverServices, other.discoverServices);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectionStatus.hashCode;
    result = 37 * result + deviceConnector.hashCode;
    result = 37 * result + const Ignore().hash(discoverServices);
    return result;
  }
}

class TrayEquippedViewModel$Change {
  TrayEquippedViewModel$Change._(
    this.deviceId,
    this.connectionStatus,
    this.deviceConnector,
    this.discoverServices,
  );

  String deviceId;
  DeviceConnectionState connectionStatus;
  BleDeviceConnector deviceConnector;
  Future<List<DiscoveredService>> Function() discoverServices;
}

// ignore: avoid_classes_with_only_static_members
class TrayEquippedViewModel$ {
  static final deviceId = Lens<TrayEquippedViewModel, String>(
    (deviceIdContainer) => deviceIdContainer.deviceId,
    (deviceIdContainer, deviceId) =>
        deviceIdContainer.copyWith(deviceId: deviceId),
  );

  static final connectionStatus =
      Lens<TrayEquippedViewModel, DeviceConnectionState>(
    (connectionStatusContainer) => connectionStatusContainer.connectionStatus,
    (connectionStatusContainer, connectionStatus) =>
        connectionStatusContainer.copyWith(connectionStatus: connectionStatus),
  );

  static final deviceConnector =
      Lens<TrayEquippedViewModel, BleDeviceConnector>(
    (deviceConnectorContainer) => deviceConnectorContainer.deviceConnector,
    (deviceConnectorContainer, deviceConnector) =>
        deviceConnectorContainer.copyWith(deviceConnector: deviceConnector),
  );

  static final discoverServices = Lens<TrayEquippedViewModel,
      Future<List<DiscoveredService>> Function()>(
    (discoverServicesContainer) => discoverServicesContainer.discoverServices,
    (discoverServicesContainer, discoverServices) =>
        discoverServicesContainer.copyWith(discoverServices: discoverServices),
  );
}