//
//  GardenDetailsInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol GardenDetailsRouting: ViewableRouting {
}

protocol GardenDetailsPresentable: Presentable {
    var listener: GardenDetailsPresentableListener? { get set }

    func bind(viewModel: GardenDetailsViewModel)
    func bindResult(title: String, message: String)
    func deinitMenuViewController()
}

protocol GardenDetailsListener: AnyObject {
    func dismissGardenDetails()
    func reloadData()
}

final class GardenDetailsInteractor: PresentableInteractor<GardenDetailsPresentable>, GardenDetailsInteractable {

    weak var router: GardenDetailsRouting?
    weak var listener: GardenDetailsListener?
    private var viewModel: GardenDetailsViewModel
    private var mqttHelper: MQTTHelper!
    @DIInjected var networkService: NetworkService

    init(presenter: GardenDetailsPresentable, garden: Garden) {
        print("garden with id \(garden.id)")
        self.viewModel = GardenDetailsViewModel(garden: garden)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchAllDeviceIds()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        self.presenter.deinitMenuViewController()
        super.willResignActive()
    }

    func subcribeForMeasureData() {
        self.mqttHelper = MQTTHelper(deviceId: self.viewModel.currentSensor!.id, gardenId: self.viewModel.garden.id)
        self.mqttHelper.delegate = self
    }

    func fetchAllDeviceIds() {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.getAllDevicesByGardenId(accessToken: accessToken, gardenId: self.viewModel.garden.id).subscribe(onNext: { listDevices in
                self.viewModel.listDevices = listDevices
                self.viewModel.currentSensor = listDevices.first
                self.presenter.bind(viewModel: self.viewModel)
                self.viewModel.currentSensor = self.viewModel.listDevices.first(where: { device in
                    device.type == "sensor"
                })
                self.subcribeForMeasureData()
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("get all devices failed with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    private func deleteDevice(device: Device) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.deleteDeviceById(accessToken: accessToken, gardenId: device.gardenId, deviceId: device.id).subscribe(onNext: { responseData in
                if let deleteSuccessResponse = responseData as? DeleteResponse {
                    self.presenter.bindResult(title: "Delete device", message: "Delete this device successfully!")
                    print("Delete \(deleteSuccessResponse.deletedCount) device \(device.name) successfully!")
                    self.fetchAllDeviceIds()
                    SVProgressHUD.dismiss()
                } else {
                    self.presenter.bindResult(title: "Delete device", message: "Something went wrong. Try again!")
                    print("Create new device failed with message \(responseData as! String)")
                    SVProgressHUD.dismiss()
                }
            }, onError: { error in
                self.presenter.bindResult(title: "Delete device", message: "Something went wrong. Try again!")
                print("Create new device failed with error \(error.localizedDescription)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    private func updateGarden(name: String, address: String) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.updateGarden(accessToken: accessToken, name: name, address: address, gardenId: self.viewModel.garden.id).subscribe(onNext: { responseData in
                if let garden = responseData as? Garden {
                    self.presenter.bindResult(title: "Update garden", message: "Update garden successfully!")
                    print("Update garden \(garden.name) successfully!")
                    self.viewModel.garden = garden
                    self.presenter.bind(viewModel: self.viewModel)
                    self.listener?.reloadData()
                    SVProgressHUD.dismiss()
                } else {
                    self.presenter.bindResult(title: "Update garden", message: "Something went wrong. Try again!")
                    print("Update garden failed with message \(responseData as! String)")
                    SVProgressHUD.dismiss()
                }
            }, onError: { error in
                self.presenter.bindResult(title: "Update garden", message: "Something went wrong. Try again!")
                print("Update garden failed with error \(error.localizedDescription)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    private func updateDevice(device: Device, name: String, description: String, gardenId: String, deviceType: String) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.updateDevice(accessToken: accessToken, name: name, description: description, gardenId: gardenId, deviceType: deviceType, deviceId: device.id).subscribe(onNext: { responseData in
                if let device = responseData as? Device {
                    self.presenter.bindResult(title: "Update device", message: "Update device successfully!")
                    self.fetchAllDeviceIds()
                    print("Update device \(device.name) successfully!")
                    SVProgressHUD.dismiss()
                } else {
                    self.presenter.bindResult(title: "Update device", message: "Something went wrong. Try again!")
                    print("Update device failed with message \(responseData as! String)")
                    SVProgressHUD.dismiss()
                }
            }, onError: { error in
                self.presenter.bindResult(title: "Update device", message: "Something went wrong. Try again!")
                print("Update device failed with error \(error.localizedDescription)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    private func changeDeviceStatus(deviceId: String, isOn: Bool) {
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.changeDeviceStatus(accessToken: accessToken, deviceId: deviceId, isOn: isOn).subscribe(onNext: { responseData in
                    if let device = responseData as? Device {
                        print("Change status \(device.name) successfully!")
                    } else {
                        print("Change device status failed with message \(responseData as! String)")
                    }
                }, onError: { error in
                    print("Change device status failed with error \(error.localizedDescription)")
                }).disposeOnDeactivate(interactor: self)
        }
    }
}

// MARK: - GardenDetailsPresentableListener
extension GardenDetailsInteractor: GardenDetailsPresentableListener {
    func didChangeControlDeviceStatus(device: Device, isOn: Bool) {
        self.changeDeviceStatus(deviceId: device.id, isOn: isOn)
    }

    func didTapToDelete(device: Device) {
        self.deleteDevice(device: device)
    }

    func didTapBackButton() {
        self.listener?.dismissGardenDetails()
    }

    func updateGardenWith(name: String, address: String) {
        self.updateGarden(name: name, address: address)
    }

    func didTapToUpdate(device: Device, name: String, description: String, gardenId: String, deviceType: String) {
        self.updateDevice(device: device, name: name, description: description, gardenId: gardenId, deviceType: deviceType)
    }
}

// MARK: - MQTTHelperDelegate
extension GardenDetailsInteractor: MQTTHelperDelegate {
    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, measureResult: TemporaryMeasureResult) {
        self.viewModel.temperature = measureResult.temperature
        self.viewModel.moisture = measureResult.moisture
        self.presenter.bind(viewModel: self.viewModel)
        print("result \(measureResult.temperature)")
    }

    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, notificationMessage: NotificationMessage) {
        // nothing to handle
    }
}
