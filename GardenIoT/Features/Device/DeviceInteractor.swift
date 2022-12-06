//
//  DeviceInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol DeviceRouting: ViewableRouting {
}

protocol DevicePresentable: Presentable {
    var listener: DevicePresentableListener? { get set }

    func bindCreateNewDeviceResult(isSuccess: Bool)
}

protocol DeviceListener: AnyObject {
}

final class DeviceInteractor: PresentableInteractor<DevicePresentable>, DeviceInteractable {

    weak var router: DeviceRouting?
    weak var listener: DeviceListener?
    @DIInjected var networkService: NetworkService

    override init(presenter: DevicePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func createNewDevice(name: String, description: String, gardenId: String) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.createNewDevice(accessToken: accessToken, name: name, description: description, gardenId: gardenId).subscribe(onNext: { responseData in
                if let device = responseData as? Device {
                    self.presenter.bindCreateNewDeviceResult(isSuccess: true)
                    print("Create new device \(device.name) successfully!")
                    SVProgressHUD.dismiss()
                } else {
                    self.presenter.bindCreateNewDeviceResult(isSuccess: false)
                    print("Create new device failed with message \(responseData as! String)")
                    SVProgressHUD.dismiss()
                }
            }, onError: { error in
                self.presenter.bindCreateNewDeviceResult(isSuccess: false)
                print("Create new device failed with error \(error.localizedDescription)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }
}
// MARK: - DevicePresentableListener
extension DeviceInteractor: DevicePresentableListener {
    func didTapToCreateNewDevice(name: String, description: String, gardenId: String) {
        self.createNewDevice(name: name, description: description, gardenId: gardenId)
    }
}
