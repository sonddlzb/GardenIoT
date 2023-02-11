//
//  DataDetailsInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import RIBs
import RxSwift

protocol DataDetailsRouting: ViewableRouting {
}

protocol DataDetailsPresentable: Presentable {
    var listener: DataDetailsPresentableListener? { get set }

    func bind(viewModel: DataDetailsViewModel)
}

protocol DataDetailsListener: AnyObject {
}

final class DataDetailsInteractor: PresentableInteractor<DataDetailsPresentable>, DataDetailsInteractable, DataDetailsPresentableListener {

    weak var router: DataDetailsRouting?
    weak var listener: DataDetailsListener?

    private var viewModel: DataDetailsViewModel

    init(presenter: DataDetailsPresentable, listMeasureData: [MeasureResult]) {
        self.viewModel = DataDetailsViewModel(listMeasureData: listMeasureData)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
