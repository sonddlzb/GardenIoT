//
//  MQTTHelper.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation
import CocoaMQTT

private struct Const {
    static let hostName = "localhost"
    static let port: UInt16 = 1883
}

protocol MQTTHelperDelegate: AnyObject {
    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, measureResult: MeasureResult)
}

class MQTTHelper {
    var gardenId: String
    var deviceId: String
    var mqtt: CocoaMQTT
    weak var delegate: MQTTHelperDelegate?

    init(deviceId: String, gardenId: String) {
        self.gardenId = gardenId
        self.deviceId = deviceId
        self.mqtt = CocoaMQTT(clientID: gardenId, host: Const.hostName, port: Const.port)
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
        return "\(gardenId)/\(deviceId)"
    }
}

extension MQTTHelper: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.mqtt.subscribe(self.subcribeTopic(), qos: .qos1)
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        self.delegate?.mqttHelperDidReceive(self, measureResult: message.toObject())
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
    func toObject() -> MeasureResult {
        let data = Data(self.payload)
        let decoder = JSONDecoder()
        let entity = try! decoder.decode(MeasureResultEntity.self, from: data)
        return MeasureResult(entity: entity)
    }
}

