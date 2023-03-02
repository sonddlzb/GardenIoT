//
//  DeviceInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD
import Foundation

protocol DeviceRouting: ViewableRouting {
}

protocol DevicePresentable: Presentable {
    var listener: DevicePresentableListener? { get set }

    func bindResult(title: String, message: String)
    func bind(viewModel: DeviceViewModel)
    func deinitMenuViewController()
}

protocol DeviceListener: AnyObject {
}

final class DeviceInteractor: PresentableInteractor<DevicePresentable>, DeviceInteractable {

    weak var router: DeviceRouting?
    weak var listener: DeviceListener?
    @DIInjected var networkService: NetworkService
    var viewModel: DeviceViewModel!

    override init(presenter: DevicePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchListDevices()
    }

    override func willResignActive() {
        self.presenter.deinitMenuViewController()
        super.willResignActive()
    }

    private func fetchListDevices() {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.getAllDevices(accessToken: accessToken).subscribe(onNext: { listDevices in
                self.viewModel = DeviceViewModel(listDevices: listDevices)
                self.presenter.bind(viewModel: self.viewModel)
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("get all devices failed with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    private func createNewDevice(name: String, description: String, gardenId: String, deviceType: String) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.createNewDevice(accessToken: accessToken, name: name, description: description, gardenId: gardenId, deviceType: deviceType).subscribe(onNext: { responseData in
                if let device = responseData as? Device {
                    self.presenter.bindResult(title: "Create device", message: "Create new device successfully!")
                    self.fetchListDevices()
                    print("Create new device \(device.name) successfully!")
                    SVProgressHUD.dismiss()
                } else {
                    self.presenter.bindResult(title: "Create device", message: "Something went wrong. Try again!")
                    print("Create new device failed with message \(responseData as! String)")
                    SVProgressHUD.dismiss()
                }
            }, onError: { error in
                self.presenter.bindResult(title: "Create device", message: "Something went wrong. Try again!")
                print("Create new device failed with error \(error.localizedDescription)")
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
                    self.fetchListDevices()
                    print("Delete \(deleteSuccessResponse.deletedCount) device \(device.name) successfully!")
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

    private func updateDevice(device: Device, name: String, description: String, gardenId: String, deviceType: String) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.updateDevice(accessToken: accessToken, name: name, description: description, gardenId: gardenId, deviceType: deviceType, deviceId: device.id).subscribe(onNext: { responseData in
                if let device = responseData as? Device {
                    self.presenter.bindResult(title: "Update device", message: "Update device successfully!")
                    self.fetchListDevices()
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

// MARK: - DevicePresentableListener
extension DeviceInteractor: DevicePresentableListener {
    func didTapToCreateNewDevice(name: String, description: String, gardenId: String, deviceType: String) {
        self.createNewDevice(name: name, description: description, gardenId: gardenId, deviceType: deviceType)
    }

    func didChangeControlDeviceStatus(device: Device, isOn: Bool) {
        self.changeDeviceStatus(deviceId: device.id, isOn: isOn)
    }

    func didTapToDelete(device: Device) {
        self.deleteDevice(device: device)
    }

    func didTapToUpdate(device: Device, name: String, description: String, gardenId: String, deviceType: String) {
        self.updateDevice(device: device, name: name, description: description, gardenId: gardenId, deviceType: deviceType)
    }
}
