//
//  HomeItemTabBar.swift
//
//  Created by đào sơn on 08/09/2022.
//

import Foundation
import UIKit
public enum HomeTab: String {
    case home = "home"
    case daily = "daily"
    case create = "create"
    case artworks = "artworks"

    func getItemName() -> String {
        return self.rawValue.capitalized
    }

    func getItemImage(isFocus: Bool) -> UIImage? {
        if isFocus {
            return UIImage(named: "ic_\(self.rawValue)_focus")
        } else {
            return UIImage(named: "ic_\(self.rawValue)_not_focus")
        }
    }

    func canHighlighted() -> Bool {
        return true
    }
}

extension HomeTab: CaseIterable {

}
