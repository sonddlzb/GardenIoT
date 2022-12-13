//
//  GardenViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    static let cellHeight = 80.0
}

protocol GardenPresentableListener: AnyObject {
    func didSelect(garden: Garden)
    func didTapToAddNewGardenWith(name: String, address: String)
}

final class GardenViewController: UIViewController, GardenViewControllable {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Variables
    weak var listener: GardenPresentableListener?
    private var viewModel = GardenViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    func config() {
        self.configCollectionView()
        self.configAddGardenView()
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInsets
        self.collectionView.registerCell(type: GardenCell.self)
    }

    private func configAddGardenView() {
        AddGardenView.shared.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapCreateButton(_ sender: TapableView) {
        AddGardenView.show(garden: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GardenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfGardens()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueCell(type: GardenCell.self, indexPath: indexPath)!
        cell.bind(viewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.listener?.didSelect(garden: self.viewModel.garden(at: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GardenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - Const.contentInsets.left - Const.contentInsets.right, height: Const.cellHeight)
    }
}

// MARK: - GardenPresentable
extension GardenViewController: GardenPresentable {
    func bind(viewModel: GardenViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.collectionView.reloadData()
    }

    func bindAddNewGardenResult(isSuccess: Bool) {
        let alertViewController = UIAlertController(title: "New garden", message: isSuccess ? "Create new garden successfully" : "Something went wrong. Try again!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true)
    }
}

// MARK: - AddGardenViewDelegate
extension GardenViewController: AddGardenViewDelegate {
    func addGardenViewDidTapConfirm(_ addGardenView: AddGardenView, name: String, address: String) {
        self.listener?.didTapToAddNewGardenWith(name: name, address: address)
    }
}
