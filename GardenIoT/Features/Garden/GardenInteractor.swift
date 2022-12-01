//
//  GardenInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import RIBs
import RxSwift

protocol GardenRouting: ViewableRouting {
    func routeToGardenDetails(garden: Garden)
    func dismissGardenDetails()
}

protocol GardenPresentable: Presentable {
    var listener: GardenPresentableListener? { get set }

    func bind(viewModel: GardenViewModel)
}

protocol GardenListener: AnyObject {
}

final class GardenInteractor: PresentableInteractor<GardenPresentable>, GardenInteractable {

    weak var router: GardenRouting?
    weak var listener: GardenListener?
    var viewModel: GardenViewModel!
    @DIInjected var networkService: NetworkService

    override init(presenter: GardenPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchListGardens()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchListGardens() {
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getAllGardens(accessToken: accessToken).subscribe(onNext: { listGardens in
                print("number of garden:  \(listGardens.count)")
                self.viewModel = GardenViewModel(listGardens: listGardens)
                self.presenter.bind(viewModel: self.viewModel)
            }, onError: { error in
                print("Failed to get gardens infor with error \(error)")
            }).disposeOnDeactivate(interactor: self)
        }
    }
}

// MARK: - GardenPresentableListener
extension GardenInteractor: GardenPresentableListener {
    func didSelect(garden: Garden) {
        self.router?.routeToGardenDetails(garden: garden)
    }
}
