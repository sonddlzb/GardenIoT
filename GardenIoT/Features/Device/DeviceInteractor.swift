//
//  DeviceInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs
import RxSwift

protocol DeviceRouting: ViewableRouting {
}

protocol DevicePresentable: Presentable {
    var listener: DevicePresentableListener? { get set }
}

protocol DeviceListener: AnyObject {
}

final class DeviceInteractor: PresentableInteractor<DevicePresentable>, DeviceInteractable, DevicePresentableListener {

    weak var router: DeviceRouting?
    weak var listener: DeviceListener?

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
}
