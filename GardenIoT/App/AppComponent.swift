//
//  AppComponent.swift
//  GardenIoT
//
//  Created by đào sơn on 01/11/2022.
//

import Foundation
import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init(dependency: EmptyComponent())
    }
}
