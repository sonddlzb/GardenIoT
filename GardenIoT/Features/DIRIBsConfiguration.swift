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

        DIContainer.register(DetailsBuildable.self) { _, args in
            return DetailsBuilder(dependency: args.get())
        }

        DIContainer.register(DeviceBuildable.self) { _, args in
            return DeviceBuilder(dependency: args.get())
        }

        DIContainer.register(DeviceBuildable.self) { _, args in
            return DeviceBuilder(dependency: args.get())
        }

        DIContainer.register(GardenBuildable.self) { _, args in
            return GardenBuilder(dependency: args.get())
        }

        DIContainer.register(GardenDetailsBuildable.self) { _, args in
            return GardenDetailsBuilder(dependency: args.get())
        }

        DIContainer.register(DataStatisticBuildable.self) { _, args in
            return DataStatisticBuilder(dependency: args.get())
        }

        DIContainer.register(DataDetailsBuildable.self) { _, args in
            return DataDetailsBuilder(dependency: args.get())
        }
    }
}
