//
//  SensorDeviceView.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import UIKit

class SensorDeviceView: UIView {
    private var collectionView: UICollectionView!

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
    }

    private func config() {
        self.configCollectionView()
    }

    private func configCollectionView() {

    }
}
