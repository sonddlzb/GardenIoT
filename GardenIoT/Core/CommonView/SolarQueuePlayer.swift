//
//  SolarQueuePlayer.swift
//  PrankSounds
//
//  Created by Linh Nguyen Duc on 23/08/2022.
//

import AVFoundation
import UIKit

protocol SolarQueuePlayerDataSource: AnyObject {
    func newPlayerItem(for player: SolarQueuePlayer) -> AVPlayerItem?
}

protocol SolarQueuePlayerDelegate: AnyObject {
    func solarQueuePlayer(_ player: SolarQueuePlayer, didUpdatePlayingStatus isPlaying: Bool)
    func solarQueuePlayerBeganInterruptAudio(_ player: SolarQueuePlayer)
    func solarQueuePlayerEndedInterruptAudio(_ player: SolarQueuePlayer)
    func solarQueuePlayerBeganPlayToEnd(_ player: SolarQueuePlayer)
    func solarQueuePlayerEndedPlayToEnd(_ player: SolarQueuePlayer)
}

class SolarQueuePlayer: AVQueuePlayer {
    private var playingStatusObserver: NSKeyValueObservation?

    weak var dataSource: SolarQueuePlayerDataSource?
    weak var delegate: SolarQueuePlayerDelegate?

    var isLoopEnabled: Bool = false

    // MARK: - Init
    override init() {
        super.init()
    }

    deinit {
        self.playingStatusObserver = nil
    }

    override init(items: [AVPlayerItem]) {
        super.init(items: items)
        self.commonInit()
    }

    override init(url URL: URL) {
        super.init(url: URL)
        self.commonInit()
    }

    override init(playerItem item: AVPlayerItem?) {
        super.init(playerItem: item)
        self.commonInit()
    }

    private func commonInit() {
        self.actionAtItemEnd = .advance
        self.configNotificationCenter()

        self.playingStatusObserver = self.observe(\.timeControlStatus, options: [.new]) { [weak self] _, _ in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                self.delegate?.solarQueuePlayer(self, didUpdatePlayingStatus: self.timeControlStatus != .paused)
            }
        }
    }

    private func configNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruptNotification(_:)), name: AVAudioSession.interruptionNotification, object: nil)
    }

    // MARK: - Notification
    @objc private func playerDidPlayToEnd(_ notification: Notification) {
        guard (notification.object as? AVPlayerItem) == self.currentItem else {
            return
        }

        if !self.isLoopEnabled {
            self.pause()
            delegate?.solarQueuePlayer(self, didUpdatePlayingStatus: false)
        }

        delegate?.solarQueuePlayerBeganPlayToEnd(self)
        if let newPlayerItem = dataSource?.newPlayerItem(for: self) {
            self.insert(newPlayerItem, after: nil)
        }

        self.seek(to: .zero, completionHandler: { [weak self] _ in
            guard let self = self else {
                return
            }

            if self.isLoopEnabled {
                // set rate with current value, make sure audio play with true rate in next play time
                self.rate = self.rate
            }

            self.delegate?.solarQueuePlayerEndedPlayToEnd(self)
        })
    }

    @objc private func audioSessionInterruptNotification(_ notification: Notification) {
        guard let interruptValue = (notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.intValue,
              let interruptType = AVAudioSession.InterruptionType(rawValue: UInt(interruptValue)) else {
            return
        }

        switch interruptType {
        case .began:
            delegate?.solarQueuePlayerBeganInterruptAudio(self)
        case .ended:
            delegate?.solarQueuePlayerEndedInterruptAudio(self)
        @unknown default:
            break
        }
    }

    // MARK: - Override method
    override func play() {
        self.seek(to: .zero) { _ in
            super.play()
        }
    }
}
