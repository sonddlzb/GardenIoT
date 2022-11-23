//
//  ProfileViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 16/11/2022.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let optionHeight = 50.0
    static let contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
}

protocol ProfilePresentableListener: AnyObject {
    func didSelect(option: ProfileOption)
    func didTapConfirmToSignOut()
}

final class ProfileViewController: UIViewController, ProfileViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var phoneImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Variables
    weak var listener: ProfilePresentableListener?
    var viewModel = ProfileViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        configCollectionView()
    }

    private func configCollectionView() {
        self.collectionView.registerCell(type: ProfileCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
    }
}

// MARK: - ProfilePresentable
extension ProfileViewController: ProfilePresentable {
    func bind(viewModel: ProfileViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.collectionView.reloadData()
        self.nameLabel.text = self.viewModel.account.name
        self.addressLabel.text = self.viewModel.account.address
        self.phoneLabel.text = self.viewModel.account.phoneNumber
        self.phoneImageView.isHidden = false
        self.locationImageView.isHidden = false
    }

    func showConfirmDialog() {
        ConfirmDialog.shared.delegate = self
        ConfirmDialog.show(message: "Do you really want to sign out?")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueCell(type: ProfileCell.self, indexPath: indexPath)!
        cell.delegate = self
        cell.bind(viewModel: viewModel.item(at: indexPath.row))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfOptions()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - Const.contentInset.left - Const.contentInset.right, height: Const.optionHeight)
    }
}

// MARK: - ProfileCellDelegate
extension ProfileViewController: ProfileCellDelegate {
    func profileCell(_ profileCell: ProfileCell, didSelect option: ProfileOption) {
        self.listener?.didSelect(option: option)
    }
}

extension ProfileViewController: ConfirmDialogDelegate {
    func confirmDialogDidTapConfirm(_ confirmDialog: ConfirmDialog) {
        self.listener?.didTapConfirmToSignOut()
    }
}
