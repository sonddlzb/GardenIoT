//
//  ProfileCell.swift
//  GardenIoT
//
//  Created by đào sơn on 19/11/2022.
//

import UIKit

protocol ProfileCellDelegate: AnyObject {
    func profileCell(_ profileCell: ProfileCell, didSelect option: ProfileOption)
}

class ProfileCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var optionLabel: UILabel!

    weak var delegate: ProfileCellDelegate?
    var viewModel: ProfileItemViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(viewModel: ProfileItemViewModel) {
        self.viewModel = viewModel
        self.imageView.image = viewModel.image()
        self.optionLabel.text = viewModel.labelContent()
    }

    @IBAction func didTapContentView(_ sender: TapableView) {
        delegate?.profileCell(self, didSelect: self.viewModel.profileOption)
    }
}
