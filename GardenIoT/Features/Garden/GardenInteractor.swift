//
//  GardenInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol GardenRouting: ViewableRouting {
    func routeToGardenDetails(garden: Garden)
    func dismissGardenDetails()
}

protocol GardenPresentable: Presentable {
    var listener: GardenPresentableListener? { get set }

    func bind(viewModel: GardenViewModel)
    func bindAddNewGardenResult(isSuccess: Bool)
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
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getAllGardens(accessToken: accessToken).subscribe(onNext: { listGardens in
                print("number of garden:  \(listGardens.count)")
                self.viewModel = GardenViewModel(listGardens: listGardens)
                self.presenter.bind(viewModel: self.viewModel)
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("Failed to get gardens infor with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    func addNewGarden(name: String, address: String) {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.addNewGarden(accessToken: accessToken, name: name, address: address).subscribe(onNext: { responseData in
                if let garden = responseData as? Garden {
                    print("create new garden successfully:  \(garden.name)")
                    self.viewModel.add(garden: garden)
                    self.presenter.bind(viewModel: self.viewModel)
                    self.presenter.bindAddNewGardenResult(isSuccess: true)
                    self.fetchListGardens()
                    SVProgressHUD.dismiss()
                } else {
                    print("failed to create new garden with message: \(responseData)")
                    self.presenter.bindAddNewGardenResult(isSuccess: false)
                    SVProgressHUD.dismiss()
                }
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

    func didTapToAddNewGardenWith(name: String, address: String) {
        self.addNewGarden(name: name, address: address)
    }
}
