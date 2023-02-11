//
//  DataDetailsViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let numberOfColumns = 3
}

protocol DataDetailsPresentableListener: AnyObject {
}

final class DataDetailsViewController: UIViewController, DataDetailsViewControllable {
    // MARK: - Outlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var moistureLabel: UILabel!

    // MARK: - Variables
    weak var listener: DataDetailsPresentableListener?
    private var viewModel = DataDetailsViewModel(listMeasureData: [])

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configCollectionView()
    }

    private func configCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: DataDetailsCell.self)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DataDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel.numberOfRecords() + 1) * Const.numberOfColumns
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueCell(type: DataDetailsCell.self, indexPath: indexPath)!
        if let itemViewModel = self.viewModel.item(at: indexPath.row) {
            cell.bind(itemViewModel: itemViewModel)
        }

        return cell
    }
}

extension DataDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = 50.0
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - DataDetailsPresentable
extension DataDetailsViewController: DataDetailsPresentable {
    func bind(viewModel: DataDetailsViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.temperatureLabel.text = self.viewModel.temperatureLabelContent()
        self.moistureLabel.text = self.viewModel.moistureLabelContent()
    }
}
