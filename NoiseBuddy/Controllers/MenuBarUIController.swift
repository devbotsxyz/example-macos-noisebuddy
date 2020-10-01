//
//  MenuBarUIController.swift
//  NoiseBuddy
//
//  Created by Guilherme Rambo on 13/11/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

import Cocoa
import NoiseCore

final class MenuBarUIController: NoiseControlUIController {

    override var isEnabled: Bool { preferences.menuBarEnabled }

    private var item: NSStatusItem?

    private func makeStatusItem() -> NSStatusItem {
        let i = NSStatusBar.system.statusItem(withLength: 30)

        i.autosaveName = "codes.rambo.NoiseBuddy.Menu"
        i.button?.imageScaling = .scaleProportionallyDown
        i.button?.target = self
        i.button?.action = #selector(toggleNoiseControlMode)

        return i
    }

    override func configureUI() {
        guard isEnabled, item == nil else { return }

        item = makeStatusItem()
    }

    override func reevaluateVisibility() {
        item?.isVisible = shouldShow(for: currentDevice)
    }

    override func handleListeningModeDidChange(_ device: NCDevice) {
        item?.button?.image = device.listeningMode.menuBarImage
        item?.button?.toolTip = currentDevice?.tooltip
    }

    override func handleDeviceDidChange(_ device: NCDevice?) {
        super.handleDeviceDidChange(device)
        
        item?.button?.toolTip = currentDevice?.tooltip
    }

}

extension NCDevice {
    var tooltip: String? {
        guard supportsListeningModes else { return nil }

        return "NoiseBuddy: \(name) (\(listeningMode.title))"
    }
}

extension NCListeningMode {
    var title: String {
        switch self {
        case .normal:
            return "Normal"
        case .anc:
            return "Noise Cancelling"
        case .transparency:
            return "Transparency"
        }
    }
}
