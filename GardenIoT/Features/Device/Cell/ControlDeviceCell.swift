//
//  ControlDeviceCell.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import UIKit

private struct Const {
    static let borderWidth = 0.5
    static let borderPadding = 20.0
}

protocol ControlDeviceCellDelegate: AnyObject {
    func controlDeviceCellDidChangeStatusValue(_ controlDeviceCell: ControlDeviceCell, at device: Device, isOn: Bool)
}

class ControlDeviceCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var gardenLabel: UILabel!
    @IBOutlet private weak var statusSwitch: UISwitch!

    var viewModel: DeviceItemViewModel!
    weak var delegate: ControlDeviceCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomBorderLayer = CALayer()
        bottomBorderLayer.backgroundColor = UIColor.darkGray.cgColor
        bottomBorderLayer.frame = CGRect(x: 0, y: self.frame.size.height - Const.borderWidth, width: self.frame.size.width - Const.borderPadding, height: Const.borderWidth)
        self.layer.addSublayer(bottomBorderLayer)
    }

    func bind(viewModel: DeviceItemViewModel) {
        self.viewModel = viewModel
        self.nameLabel.text = viewModel.name()
        viewModel.gardenName { name in
            self.gardenLabel.text = name ?? ""
        }

        self.statusSwitch.isOn = viewModel.isOn()
    }

    @IBAction func switchDidChangeValue(_ sender: Any) {
        self.viewModel.changeStatus()
        self.delegate?.controlDeviceCellDidChangeStatusValue(self, at: self.viewModel.device, isOn: self.statusSwitch.isOn)
    }
}
