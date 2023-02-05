//
//  DataStatisticInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 09/01/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol DataStatisticRouting: ViewableRouting {
}

protocol DataStatisticPresentable: Presentable {
    var listener: DataStatisticPresentableListener? { get set }

    func bind(viewModel: DataStatisticViewModel)
    func bindFilterResult(isSuccess: Bool, message: String)
}

protocol DataStatisticListener: AnyObject {
    func dataStatisticWantToDismiss()
}

final class DataStatisticInteractor: PresentableInteractor<DataStatisticPresentable>, DataStatisticInteractable {

    weak var router: DataStatisticRouting?
    weak var listener: DataStatisticListener?
    @DIInjected var networkService: NetworkService
    private var viewModel = DataStatisticViewModel(fromDate: Date(), toDate: Date())

    override init(presenter: DataStatisticPresentable) {
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
                self.viewModel.listGardens = listGardens
                self.presenter.bind(viewModel: self.viewModel)
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("Failed to get gardens infor with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    func filterGardenData() {
//        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getGardenData(accessToken: accessToken, gardenId: self.viewModel.selectedGarden!.id, fromDate: self.viewModel.fromDate, toDate: self.viewModel.toDate).subscribe(onNext: { listData in
                // handle after
                print("Number of measure data \(listData.count)")
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("Failed to get gardens infor with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    func validateFilterInput(fromDate: String, toDate: String) -> Bool {
        guard self.viewModel.selectedGarden != nil else {
            self.presenter.bindFilterResult(isSuccess: false, message: "Must select garden first!")
            return false
        }

        guard let fromDate = self.viewModel.toDate(dateString: fromDate),
              let toDate = self.viewModel.toDate(dateString: toDate) else {
            self.presenter.bindFilterResult(isSuccess: false, message: "Date is not in correct format!")
            return false
        }

        guard fromDate <= toDate else {
            self.presenter.bindFilterResult(isSuccess: false, message: "To-Date must be after From-Date! ")
            return false
        }

        self.viewModel.fromDate = fromDate
        self.viewModel.toDate = toDate
        return true
    }
}

// MARK: - DataStatisticPresentableListener
extension DataStatisticInteractor: DataStatisticPresentableListener {
    func didTapBackButton() {
        self.listener?.dataStatisticWantToDismiss()
    }

    func didChangeDateTo(date: Date, isToTextFieldFocus: Bool) {
        if isToTextFieldFocus {
            self.viewModel.toDate = date
        } else {
            self.viewModel.fromDate = date
        }

        self.presenter.bind(viewModel: self.viewModel)
    }

    func didTapFilterButton(fromDate: String, toDate: String) {
        guard self.validateFilterInput(fromDate: fromDate, toDate: toDate) else {
            return
        }

        self.filterGardenData()
    }

    func didSelectGarden(at index: Int) {
        self.viewModel.selectItem(at: index)
        self.presenter.bind(viewModel: self.viewModel)
    }
}
