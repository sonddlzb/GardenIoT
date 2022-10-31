public func registerCoreNetworkDeps() {
    DIContainer.register(NetworkClient.self) { _, _ in
        return AlamofireClient()
    }
}

public func getNetworkClient() -> NetworkClient {
    return DIContainer.resolve(NetworkClient.self)
}
