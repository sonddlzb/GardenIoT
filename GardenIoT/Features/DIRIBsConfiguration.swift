//
//  DIRibsConfiguration.swift
//  ColoringByPixel
//
//  Created by Linh Nguyen Duc on 06/09/2022.
//

import Foundation

extension DIConnector {
    static func registerAllRibs() {
        DIContainer.register(RootBuildable.self) { _, args in
            return RootBuilder(dependency: args.get())
        }

        DIContainer.register(SplashBuildable.self) { _, args in
            return SplashBuilder(dependency: args.get())
        }

        DIContainer.register(LoginBuildable.self) { _, args in
            return LoginBuilder(dependency: args.get())
        }

        DIContainer.register(SignUpBuildable.self) { _, args in
            return SignUpBuilder(dependency: args.get())
        }

        DIContainer.register(HomeBuildable.self) { _, args in
            return HomeBuilder(dependency: args.get())
        }

        DIContainer.register(ProfileBuildable.self) { _, args in
            return ProfileBuilder(dependency: args.get())
        }
    }
}
