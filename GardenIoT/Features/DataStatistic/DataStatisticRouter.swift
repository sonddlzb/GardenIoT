//
//  DataStatisticRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 09/01/2023.
//

import RIBs

protocol DataStatisticInteractable: Interactable, DataDetailsListener {
    var router: DataStatisticRouting? { get set }
    var listener: DataStatisticListener? { get set }
}

protocol DataStatisticViewControllable: ViewControllable {
    func embedViewController(_ viewController: ViewControllable)
}

final class DataStatisticRouter: ViewableRouter<DataStatisticInteractable, DataStatisticViewControllable> {

    private var dataDetailsRouter: DataDetailsRouting?
    private var dataDetailsBuilder: DataDetailsBuildable

    init(interactor: DataStatisticInteractable,
                  viewController: DataStatisticViewControllable,
                  dataDetailsBuilder: DataDetailsBuildable) {
        self.dataDetailsBuilder = dataDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - DataStatisticRouting
extension DataStatisticRouter: DataStatisticRouting {
    func embedDataDetails(listMeasureData: [MeasureResult]) {
        if self.dataDetailsRouter == nil {
            self.dataDetailsRouter = self.dataDetailsBuilder.build(withListener: self.interactor, listMeasureData: listMeasureData)
            self.attachChild(self.dataDetailsRouter!)
        }

        self.viewController.embedViewController(self.dataDetailsRouter!.viewControllable)
    }
}
