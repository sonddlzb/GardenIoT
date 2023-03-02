//
//  MQTTHelper.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation
import CocoaMQTT

private struct Const {
    static let hostName = "broker.hivemq.com"
    static let port: UInt16 = 1883
}

protocol MQTTHelperDelegate: AnyObject {
    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, measureResult: TemporaryMeasureResult)
    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, notificationMessage: NotificationMessage)
}

class MQTTHelper {
    var gardenId: String?
    var deviceId: String?
    var userId: String?
    var mqtt: CocoaMQTT
    weak var delegate: MQTTHelperDelegate?

    init(deviceId: String, gardenId: String) {
        self.gardenId = gardenId
        self.deviceId = deviceId
        self.mqtt = CocoaMQTT(clientID: gardenId, host: Const.hostName, port: Const.port)
        self.configMQTT()
    }

    init(userId: String) {
        self.userId = userId
        self.mqtt = CocoaMQTT(clientID: userId, host: Const.hostName, port: Const.port)
        self.configMQTT()
    }

    func configMQTT() {
        mqtt.allowUntrustCACertificate = true
        mqtt.keepAlive = 60
        mqtt.delegate = self
        mqtt.allowUntrustCACertificate = true
        mqtt.connect()
    }

    func subcribeTopic() -> String {
        return userId == nil ? "measure_data/sensor/\(deviceId!)" : "warning-son/user/\(userId!)"
    }
}

extension MQTTHelper: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print(self.subcribeTopic())
        self.mqtt.subscribe(self.subcribeTopic(), qos: .qos1)
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let measureResult = message.toTemporaryMeasureResultObject() {
            self.delegate?.mqttHelperDidReceive(self, measureResult: measureResult)
        }

        if let notificationMessage = message.toNotificationObject() {
        self.delegate?.mqttHelperDidReceive(self, notificationMessage: notificationMessage)
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    }
}

extension CocoaMQTTMessage {
    func toTemporaryMeasureResultObject() -> TemporaryMeasureResult? {
        let data = Data(self.payload)
        let decoder = JSONDecoder()
        guard let entity = try? decoder.decode(TemporaryMeasureResultEntity.self, from: data) else {
            return nil
        }

        return TemporaryMeasureResult(entity: entity)
    }

    func toNotificationObject() -> NotificationMessage? {
        let data = Data(self.payload)
        let decoder = JSONDecoder()
        return try? decoder.decode(NotificationMessage.self, from: data)
    }
}

