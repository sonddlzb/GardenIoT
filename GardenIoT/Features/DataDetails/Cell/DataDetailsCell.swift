//
//  DataDetailsCell.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import UIKit

class DataDetailsCell: UICollectionViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var moistureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    private func config() {
        self.stackView.subviews.forEach { subview in
            subview.borderWidth = 0.5
            subview.borderColor = UIColor.gray
        }
    }

    func bind(itemViewModel: DataDetailsItemViewModel) {
        self.dateLabel.text = itemViewModel.dateLabelContent()
        self.dateLabel.font = Outfit.regularFont(size: CGFloat(itemViewModel.dataLabelFontSize()))
        self.temperatureLabel.text = itemViewModel.temperatureLabelContent()
        self.moistureLabel.text = itemViewModel.moistureLabelContent()
    }
}
