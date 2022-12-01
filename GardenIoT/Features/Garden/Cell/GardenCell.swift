//
//  GardenCell.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import UIKit

class GardenCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func bind(viewModel: GardenItemViewModel) {
        self.nameLabel.text = viewModel.name()
        self.addressLabel.text = viewModel.address()
    }
}
