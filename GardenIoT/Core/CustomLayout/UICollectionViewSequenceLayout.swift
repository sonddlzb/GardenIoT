//
//  UICollectionViewSequenceLayout.swift
//  ColoringByPixel
//
//  Created by Linh Nguyen Duc on 12/10/2022.
//

import UIKit

protocol UICollectionViewSequenceLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

class UICollectionViewSequenceLayout: UICollectionViewFlowLayout {
    weak var delegate: UICollectionViewSequenceLayoutDelegate?

    private var contentHeight: CGFloat = 0
    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }

        var currentOffsetX: CGFloat = self.sectionInset.left
        var currentOffsetY: CGFloat = self.sectionInset.top
        for index in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: index, section: 0)
            let cellHeight = delegate?.collectionView(collectionView, heightForItemAtIndexPath: indexPath) ?? 0
            let cellWidth = delegate?.collectionView(collectionView, widthForItemAtIndexPath: indexPath) ?? 0

            if currentOffsetX + cellWidth > self.contentWidth - self.sectionInset.right {
                currentOffsetX = self.sectionInset.left
                currentOffsetY += cellHeight + self.minimumLineSpacing
            }

            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = CGRect(x: currentOffsetX, y: currentOffsetY, width: cellWidth, height: cellHeight)
            cache.append(attribute)
            currentOffsetX += cellWidth + self.minimumInteritemSpacing
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter({
            $0.frame.intersects(rect)
        })
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
