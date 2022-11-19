//
//  ProfileCell.swift
//  GardenIoT
//
//  Created by đào sơn on 19/11/2022.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(viewModel: ProfileItemViewModel) {
        self.imageView.image = viewModel.image()
        self.optionLabel.text = viewModel.labelContent()
    }
}
