//
//  GardenDetailsInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import RIBs
import RxSwift

protocol GardenDetailsRouting: ViewableRouting {
}

protocol GardenDetailsPresentable: Presentable {
    var listener: GardenDetailsPresentableListener? { get set }

    func bind(viewModel: GardenDetailsViewModel)
}

protocol GardenDetailsListener: AnyObject {
    func dismissGardenDetails()
}

final class GardenDetailsInteractor: PresentableInteractor<GardenDetailsPresentable>, GardenDetailsInteractable {

    weak var router: GardenDetailsRouting?
    weak var listener: GardenDetailsListener?
    private var viewModel: GardenDetailsViewModel
    private var mqttHelper: MQTTHelper!

    init(presenter: GardenDetailsPresentable, garden: Garden) {
        print("garden with id \(garden.id)")
        self.viewModel = GardenDetailsViewModel(garden: garden)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchAllDeviceIds()
        self.subcribeForMeasureData()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func subcribeForMeasureData() {
        self.mqttHelper = MQTTHelper(deviceId: self.viewModel.currentSensor!.id, gardenId: self.viewModel.garden.id)
        self.mqttHelper.delegate = self
    }

    func fetchAllDeviceIds() {
        self.viewModel.listDevices.append(Device(gardenId: "6385965016563213bbc5a3c6", id: "6385d202f8f5ed28a28b3ce5", name: "device-1", description: "sensor-1"))
        self.viewModel.currentSensor = self.viewModel.listDevices.first
    }
}

// MARK: - GardenDetailsPresentableListener
extension GardenDetailsInteractor: GardenDetailsPresentableListener {
    func didTapBackButton() {
        self.listener?.dismissGardenDetails()
    }
}

extension GardenDetailsInteractor: MQTTHelperDelegate {
    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, measureResult: MeasureResult) {
        self.viewModel.temparature = measureResult.temparature
        self.viewModel.moisture = measureResult.moisture
        self.presenter.bind(viewModel: self.viewModel)
//        print("result \(measureResult.temparature)")
    }
}
