//
//  AudioPlayer.swift
//  PrankSounds
//
//  Created by Linh Nguyen Duc on 01/08/2022.
//

import UIKit
import AVFAudio
import CoreHaptics
import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ player: AudioPlayer, didUpdatePlayingStatus isPlaying: Bool)
    func audioPlayerDidEndedInterrupAudio(_ player: AudioPlayer, isPlayingBefore: Bool)
}

class AudioPlayer: NSObject {
    weak var delegate: AudioPlayerDelegate?
    private var isPlayedBefore = true
    var isLoopEnabled: Bool = true {
        didSet {
            self.avPlayer?.isLoopEnabled = isLoopEnabled
        }
    }

    var volume: Float = 1 {
        didSet {
            self.avPlayer?.volume = volume
        }
    }

    var speed: Float = 1 {
        didSet {
            let isPlayingBefore = self.isPlaying()
            self.avPlayer?.rate = speed
            if !isPlayingBefore {
                self.pause()
            }
        }
    }

    var isHapticEnabled: Bool = false

    // private var player: AVAudioPlayer?
    private var hapticEngine: CHHapticEngine?
    private var hapticPlayer: CHHapticPatternPlayer?
    private var avPlayer: SolarQueuePlayer?
    private var playerItemURL: URL?
    private var skipUpdatePlayingStatus = false

    override init() {
        super.init()
        self.configNotification()
    }

    private func configNotification() {
        configNotificationCenterToStopPlayingWhenAppEnterBackground()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Notification Center
    @objc private func applicationWillEnterForegroundNotification(_ notification: Notification) {
        try? hapticEngine?.start()
        if isPlayedBefore {
            self.avPlayer?.play()
            if self.isHapticEnabled {
                try? self.hapticPlayer?.start(atTime: 0)
            }
        }
    }

    // MARK: - Public method
    func replaceItem(url: URL?, completion: ((Error?) -> Void)? = nil) {
        guard let url = url else {
            self.avPlayer = nil
            self.playerItemURL = nil
            completion?(nil)
            return
        }

        if self.playerItemURL == url {
            completion?(nil)
            return
        }

        DispatchQueue.global().async {
            do {
                self.skipUpdatePlayingStatus = true

                self.playerItemURL = url
                if self.avPlayer == nil {
                    self.avPlayer = SolarQueuePlayer(playerItem: AVPlayerItem(url: url))
                    self.configPlayer()
                    self.configHaptic()
                } else {
                    self.avPlayer?.replaceCurrentItem(with: AVPlayerItem(url: url))
                }

                self.skipUpdatePlayingStatus = false
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
    }

    func configNotificationCenterToStopPlayingWhenAppEnterBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundNotification(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func applicationDidEnterBackgroundNotification(_ notification: Notification) {
        if self.isPlaying() {
            self.avPlayer?.pause()
            self.isPlayedBefore = true
        } else {
            self.isPlayedBefore = false
        }
    }

    func play() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        self.avPlayer?.seek(to: .zero)
        self.avPlayer?.play()
        if self.isHapticEnabled {
            try? self.hapticPlayer?.start(atTime: 0)
        }
    }

    func pause() {
        self.avPlayer?.pause()
        if self.isHapticEnabled {
            try? self.hapticPlayer?.cancel()
        }
    }

    func isPlaying() -> Bool {
        return self.avPlayer?.isPlaying ?? false
    }

    // MARK: - Helper
    private func configPlayer() {
        self.avPlayer?.dataSource = self
        self.avPlayer?.delegate = self
        self.avPlayer?.isLoopEnabled = self.isLoopEnabled
        self.avPlayer?.volume = self.volume
    }

    private func configHaptic() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            return
        }

        do {
          hapticEngine = try CHHapticEngine()
        } catch let error {
          print("Haptic engine Creation Error: \(error)")
          return
        }

        do {
            try hapticEngine?.start()
        } catch let error {
          print("Haptic failed to start Error: \(error)")
        }

        do {
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ], relativeTime: 0, duration: 6000)
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            self.hapticPlayer = try hapticEngine?.makePlayer(with: pattern)
        } catch {
            print("Init haptic player error: \(error)")
        }
    }
}

// MARK: - SolarQueuePlayerDataSource
extension AudioPlayer: SolarQueuePlayerDataSource {
    func newPlayerItem(for player: SolarQueuePlayer) -> AVPlayerItem? {
        if let url = self.playerItemURL {
            return AVPlayerItem(url: url)
        }

        return nil
    }
}

// MARK: - SolarQueuePlayerDelegate
extension AudioPlayer: SolarQueuePlayerDelegate {
    func solarQueuePlayer(_ player: SolarQueuePlayer, didUpdatePlayingStatus isPlaying: Bool) {
        if !skipUpdatePlayingStatus {
            delegate?.audioPlayer(self, didUpdatePlayingStatus: isPlaying)
        }
    }

    func solarQueuePlayerBeganInterruptAudio(_ player: SolarQueuePlayer) {
        self.pause()
    }

    func solarQueuePlayerEndedInterruptAudio(_ player: SolarQueuePlayer) {
        self.delegate?.audioPlayerDidEndedInterrupAudio(self, isPlayingBefore: self.isPlayedBefore)
    }

    func solarQueuePlayerBeganPlayToEnd(_ player: SolarQueuePlayer) {
        self.skipUpdatePlayingStatus = true
    }

    func solarQueuePlayerEndedPlayToEnd(_ player: SolarQueuePlayer) {
        self.skipUpdatePlayingStatus = false
    }
}
