//
//  ControlDeviceView.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import UIKit

protocol ControlDeviceViewDelegate: AnyObject {
    func controlDeviceViewDidChangeDeviceStatus(_ controlDeviceView: ControlDeviceView, at device: Device, isOn: Bool)
    func controlDeviceDidSelect(_ controlDeviceView: ControlDeviceView, at device: Device)
}

public struct ControlDeviceViewConst {
    static let contentInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0)
    static let cellHeight: Double = 70.0
    static let cellPadding: Double = 12.0
}

class ControlDeviceView: UIView {
    private var collectionView: UICollectionView!
    var viewModel = ControlDeviceViewModel.makeEmpty()
    weak var delegate: ControlDeviceViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.config()
        self.addContentView()
        self.setUpConstraints()
    }

    private func config() {
        self.configUI()
        self.configCollectionView()
    }

    private func configUI() {
        self.backgroundColor = .clear
    }

    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.registerCell(type: ControlDeviceCell.self)
        self.collectionView.backgroundColor = .clear
//        self.collectionView.showsVerticalScrollIndicator = false
//        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = ControlDeviceViewConst.contentInsets
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    private func addContentView() {
        self.addSubview(self.collectionView)
    }

    private func setUpConstraints() {
        self.collectionView.fitSuperviewConstraint()
    }

    func bind(viewModel: ControlDeviceViewModel) {
        self.viewModel = viewModel
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ControlDeviceView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueCell(type: ControlDeviceCell.self, indexPath: indexPath)!
        cell.delegate = self
        cell.bind(viewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfDevices()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ControlDeviceView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - ControlDeviceViewConst.contentInsets.left - ControlDeviceViewConst.contentInsets.right, height: ControlDeviceViewConst.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ControlDeviceViewConst.cellPadding
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.controlDeviceDidSelect(self, at: self.viewModel.device(at: indexPath.row))
    }
}
// MARK: - ControlDeviceCellDelegate
extension ControlDeviceView: ControlDeviceCellDelegate {
    func controlDeviceCellDidChangeStatusValue(_ controlDeviceCell: ControlDeviceCell, at device: Device, isOn: Bool) {
        self.delegate?.controlDeviceViewDidChangeDeviceStatus(self, at: device, isOn: isOn)
    }
}
