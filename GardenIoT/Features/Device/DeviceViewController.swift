//
//  DeviceViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol DevicePresentableListener: AnyObject {
    func didTapToCreateNewDevice(name: String, description: String, gardenId: String)
}

final class DeviceViewController: UIViewController, DeviceViewControllable {
    weak var listener: DevicePresentableListener?

    // MARK: - Action
    @IBAction func addDeviceButtonDidTap(_ sender: Any) {
        AddDeviceView.show()
        AddDeviceView.shared.delegate = self
    }
}

// MARK: - AddDeviceViewDelegate
extension DeviceViewController: AddDeviceViewDelegate {
    func addDeviceViewDidTapConfirm(_ addDeviceView: AddDeviceView, name: String, description: String, gardenId: String) {
        self.listener?.didTapToCreateNewDevice(name: name, description: description, gardenId: gardenId)
    }
}

// MARK: - DevicePresentable
extension DeviceViewController: DevicePresentable {
    func bindCreateNewDeviceResult(isSuccess: Bool) {
        let alertViewController = UIAlertController(title: "New device", message: isSuccess ? "Create new device successfully" : "Something went wrong. Try again!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true)
    }
}
