//
//  DataDetailsBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import RIBs

protocol DataDetailsDependency: Dependency {

}

final class DataDetailsComponent: Component<DataDetailsDependency> {
}

// MARK: - Builder

protocol DataDetailsBuildable: Buildable {
    func build(withListener listener: DataDetailsListener, listMeasureData: [MeasureResult]) -> DataDetailsRouting
}

final class DataDetailsBuilder: Builder<DataDetailsDependency>, DataDetailsBuildable {

    override init(dependency: DataDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DataDetailsListener, listMeasureData: [MeasureResult]) -> DataDetailsRouting {
        let component = DataDetailsComponent(dependency: dependency)
        let viewController = DataDetailsViewController()
        let interactor = DataDetailsInteractor(presenter: viewController, listMeasureData: listMeasureData)
        interactor.listener = listener
        return DataDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
