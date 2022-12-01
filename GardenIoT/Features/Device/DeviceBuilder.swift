//
//  DeviceBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs

protocol DeviceDependency: Dependency {

}

final class DeviceComponent: Component<DeviceDependency> {
}

// MARK: - Builder

protocol DeviceBuildable: Buildable {
    func build(withListener listener: DeviceListener) -> DeviceRouting
}

final class DeviceBuilder: Builder<DeviceDependency>, DeviceBuildable {

    override init(dependency: DeviceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DeviceListener) -> DeviceRouting {
        let component = DeviceComponent(dependency: dependency)
        let viewController = DeviceViewController()
        let interactor = DeviceInteractor(presenter: viewController)
        interactor.listener = listener
        return DeviceRouter(interactor: interactor, viewController: viewController)
    }
}
