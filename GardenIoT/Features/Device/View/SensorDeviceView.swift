//
//  SensorDeviceView.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import UIKit

protocol SensorDeviceViewDelegate: AnyObject {
    func sensorDeviceViewDidSelect(_ sensorDeviceView: SensorDeviceView, device: Device)
}

public struct SensorDeviceViewConst {
    static let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    static let cellHeight: Double = 70.0
    static let cellPadding: Double = 12.0
}

class SensorDeviceView: UIView {
    private var collectionView: UICollectionView!
    var viewModel = SensorDeviceViewModel.makeEmpty()
    weak var delegate: SensorDeviceViewDelegate?

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
        self.collectionView.registerCell(type: SensorDeviceCell.self)
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = SensorDeviceViewConst.contentInsets
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    private func addContentView() {
        self.addSubview(self.collectionView)
    }

    private func setUpConstraints() {
        self.collectionView.fitSuperviewConstraint()
    }

    func bind(viewModel: SensorDeviceViewModel) {
        self.viewModel = viewModel
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SensorDeviceView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueCell(type: SensorDeviceCell.self, indexPath: indexPath)!
        cell.bind(viewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfDevices()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.sensorDeviceViewDidSelect(self, device: self.viewModel.device(at: indexPath.row))
    }
}

extension SensorDeviceView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - SensorDeviceViewConst.contentInsets.left - SensorDeviceViewConst.contentInsets.right, height: SensorDeviceViewConst.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SensorDeviceViewConst.cellPadding
    }
}
