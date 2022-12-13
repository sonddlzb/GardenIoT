//
//  GardenDetailsViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol GardenDetailsPresentableListener: AnyObject {
    func didTapBackButton()
    func didChangeControlDeviceStatus(device: Device, isOn: Bool)
    func didTapToDelete(device: Device)
    func updateGardenWith(name: String, address: String)
    func didTapToUpdate(device: Device, name: String, description: String, gardenId: String, deviceType: String)
}

final class GardenDetailsViewController: UIViewController, GardenDetailsViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var celciusTemparatureLabel: UILabel!
    @IBOutlet private weak var deviceLabel: UILabel!
    @IBOutlet private weak var fahrenheitTemparatureLabel: UILabel!
    @IBOutlet private weak var moistureLabel: UILabel!
    @IBOutlet private weak var sensorDeviceHeaderView: UIView!
    @IBOutlet private weak var controlDeviceHeaderView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var sensorExpandButton: UIButton!
    @IBOutlet private weak var controlExpandButton: UIButton!
    @IBOutlet private weak var sensorDeviceLabel: UILabel!
    @IBOutlet private weak var controlDeviceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var controlDeviceContainerViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    weak var listener: GardenDetailsPresentableListener?
    private var viewModel: GardenDetailsViewModel!
    private var sensorDeviceView = SensorDeviceView()
    private var controlDeviceView = ControlDeviceView()
    private var isListSensorDevicesVisible = false
    private var isListControlDevicesVisible = false
    private var menuController: UIAlertController!
    private var selectedDevice: Device!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configUI()
        self.configMenuController()
    }

    private func configUI() {
    }

    private func configMenuController() {
        self.menuController = UIAlertController(title: "Device's option", message: nil, preferredStyle: .actionSheet)
        let descriptionAction = UIAlertAction(title: "Description", style: .default, handler: { _ in
            self.showDescription()
        })
        let updateAction = UIAlertAction(title: "Update", style: .default, handler: { _ in
            AddDeviceView.show(title: "Update Device", device: self.selectedDevice)
            AddDeviceView.shared.delegate = self
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.showDeleteConfirmDialog()
        })
        self.menuController.addAction(descriptionAction)
        self.menuController.addAction(updateAction)
        self.menuController.addAction(deleteAction)
    }

    // MARK: - Actions
    @IBAction func backButtonDidTap(_ sender: TapableView) {
        self.listener?.didTapBackButton()
    }

    @IBAction func sensorExpandDidTap(_ sender: Any) {
        self.isListSensorDevicesVisible = !self.isListSensorDevicesVisible
        if self.isListSensorDevicesVisible {
            self.showListSensorDevices()
            if self.isListControlDevicesVisible {
                self.hideListControlDevices()
                self.isListControlDevicesVisible = false
            }
        } else {
            self.hideListSensorDevices()
        }
    }

    @IBAction func controlExpandDidTap(_ sender: Any) {
        self.isListControlDevicesVisible = !self.isListControlDevicesVisible
        if self.isListControlDevicesVisible {
            self.showListControlDevices()
            if self.isListSensorDevicesVisible {
                self.hideListSensorDevices()
                self.isListSensorDevicesVisible = false
            }
        } else {
            self.hideListControlDevices()
        }
    }

    @IBAction func editButtonDidTap(_ sender: TapableView) {
        AddGardenView.show(garden: self.viewModel.garden)
        AddGardenView.shared.delegate = self
    }

    // MARK: - Helper
    private func showListSensorDevices() {
        self.sensorDeviceView = SensorDeviceView()
        self.sensorDeviceView.translatesAutoresizingMaskIntoConstraints = false
        self.sensorDeviceView.delegate = self
        self.sensorDeviceView.bind(viewModel: self.viewModel.sensorItem())
        self.contentView.addSubview(self.sensorDeviceView)

        let maxHeight = self.contentView.frame.height - self.sensorDeviceHeaderView.frame.height - self.controlDeviceHeaderView.frame.height - 24
        let sensorDeviceViewHeight = self.viewModel.heightForSensorDeviceView(maxValue: maxHeight)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.sensorExpandButton.setImage(UIImage(named: "ic_arrow_down"), for: .normal)
            NSLayoutConstraint.activate([
                self.sensorDeviceView.topAnchor.constraint(equalTo: self.sensorDeviceHeaderView.bottomAnchor),
                self.sensorDeviceView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                self.sensorDeviceView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                self.sensorDeviceView.heightAnchor.constraint(equalToConstant: sensorDeviceViewHeight)
            ])
            self.view.layoutIfNeeded()
            self.controlDeviceContainerViewTopConstraint.constant = self.sensorDeviceView.frame.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideListSensorDevices() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.sensorExpandButton.setImage(UIImage(named: "ic_arrow_forward"), for: .normal)
            self.sensorDeviceView.removeFromSuperview()
            self.controlDeviceContainerViewTopConstraint.constant = 5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func showListControlDevices() {
        self.controlDeviceView = ControlDeviceView()
        self.controlDeviceView.translatesAutoresizingMaskIntoConstraints = false
        self.controlDeviceView.delegate = self
        self.controlDeviceView.bind(viewModel: self.viewModel.controlItem())
        self.contentView.addSubview(self.controlDeviceView)

        let maxHeight = self.contentView.frame.height - self.sensorDeviceHeaderView.frame.height - self.controlDeviceHeaderView.frame.height - 24
        let controlDeviceViewHeight = self.viewModel.heightForControlDeviceView(maxValue: maxHeight)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.controlExpandButton.setImage(UIImage(named: "ic_arrow_down"), for: .normal)
            NSLayoutConstraint.activate([
                self.controlDeviceView.topAnchor.constraint(equalTo: self.controlDeviceHeaderView.bottomAnchor),
                self.controlDeviceView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                self.controlDeviceView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                self.controlDeviceView.heightAnchor.constraint(equalToConstant: controlDeviceViewHeight)
            ])
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideListControlDevices() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.controlExpandButton.setImage(UIImage(named: "ic_arrow_forward"), for: .normal)
            self.controlDeviceView.removeFromSuperview()
            self.controlDeviceContainerViewTopConstraint.constant = self.isListSensorDevicesVisible ? self.sensorDeviceView.frame.height + 5 : 5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func showOptionMenu() {
        present(self.menuController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            self.menuController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }

    @objc func dismissAlertController() {
        self.dismiss(animated: true, completion: nil)
    }

    private func showDescription() {
        let alertViewController = UIAlertController(title: "Device's description", message: self.selectedDevice.description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true)
    }

    private func showDeleteConfirmDialog() {
        let deleteConfirmViewController = UIAlertController(title: "", message: "Do you want to delete this device?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.listener?.didTapToDelete(device: self.selectedDevice)
        })
        deleteConfirmViewController.addAction(cancelAction)
        deleteConfirmViewController.addAction(okAction)
        present(deleteConfirmViewController, animated: true)
    }
}

// MARK: - GardenDetailsPresentable
extension GardenDetailsViewController: GardenDetailsPresentable {
    func bind(viewModel: GardenDetailsViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.celciusTemparatureLabel.text = "\(viewModel.celciusTemparatureValue())°C"
        self.fahrenheitTemparatureLabel.text = "\(viewModel.fahrenheitTemparatureValue())°F"
        self.moistureLabel.text = "\(viewModel.moisture)%"
        self.sensorDeviceView.bind(viewModel: self.viewModel.sensorItem())
        self.controlDeviceView.bind(viewModel: self.viewModel.controlItem())
        self.sensorDeviceLabel.text = "Sensor Device (\(self.viewModel.numberOfSensorDevices()))"
        self.controlDeviceLabel.text = "Control Device (\(self.viewModel.numberOfControlDevices()))"
        self.titleLabel.text = self.viewModel.name()
    }

    func bindResult(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true)
    }

    func deinitMenuViewController() {
        self.menuController = nil
    }
}

// MARK: - ControlDeviceViewDelegate
extension GardenDetailsViewController: ControlDeviceViewDelegate {
    func controlDeviceDidSelect(_ controlDeviceView: ControlDeviceView, at device: Device) {
        self.selectedDevice = device
        self.showOptionMenu()
    }

    func controlDeviceViewDidChangeDeviceStatus(_ controlDeviceView: ControlDeviceView, at device: Device, isOn: Bool) {
        self.listener?.didChangeControlDeviceStatus(device: device, isOn: isOn)
    }
}

// MARK: - SensorDeviceViewDelegate
extension GardenDetailsViewController: SensorDeviceViewDelegate {
    func sensorDeviceViewDidSelect(_ sensorDeviceView: SensorDeviceView, device: Device) {
        self.selectedDevice = device
        self.showOptionMenu()
    }
}

// MARK: - AddGardenViewDelegate
extension GardenDetailsViewController: AddGardenViewDelegate {
    func addGardenViewDidTapConfirm(_ addGardenView: AddGardenView, name: String, address: String) {
        self.listener?.updateGardenWith(name: name, address: address)
    }
}

// MARK: - AddDeviceViewDelegate
extension GardenDetailsViewController: AddDeviceViewDelegate {
    func addDeviceViewDidTapConfirm(_ addDeviceView: AddDeviceView, name: String, description: String, gardenId: String, deviceType: String, isNewDevice: Bool) {
        self.listener?.didTapToUpdate(device: self.selectedDevice, name: name, description: description, gardenId: gardenId, deviceType: deviceType)
    }
}
