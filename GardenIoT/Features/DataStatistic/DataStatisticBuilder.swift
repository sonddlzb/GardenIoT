//
//  DataStatisticBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 09/01/2023.
//

import RIBs

protocol DataStatisticDependency: Dependency {

}

final class DataStatisticComponent: Component<DataStatisticDependency> {
}

// MARK: - Builder

protocol DataStatisticBuildable: Buildable {
    func build(withListener listener: DataStatisticListener) -> DataStatisticRouting
}

final class DataStatisticBuilder: Builder<DataStatisticDependency>, DataStatisticBuildable {

    override init(dependency: DataStatisticDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DataStatisticListener) -> DataStatisticRouting {
        let component = DataStatisticComponent(dependency: dependency)
        let viewController = DataStatisticViewController()
        let interactor = DataStatisticInteractor(presenter: viewController)
        interactor.listener = listener
        return DataStatisticRouter(interactor: interactor, viewController: viewController)
    }
}
