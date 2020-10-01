//
//  AppDelegate.swift
//  NoiseBuddy
//
//  Created by Guilherme Rambo on 13/11/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

import Cocoa
import NoiseCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private func makeListeningModeController() -> NCListeningModeStatusProvider {
        guard let arg = UserDefaults.standard.string(forKey: "NBListeningModeControllerType") else {
            return NCAVListeningModeController()
        }

        switch arg {
        case "bt": return NCBTListeningModeController()
        case "mock": return MockListeningModeController()
        default: return NCAVListeningModeController()
        }
    }

    private lazy var preferences = Preferences()

    private lazy var touchBarController: TouchBarUIController = {
        TouchBarUIController(
            listeningModeController: self.makeListeningModeController(),
            preferences: self.preferences
        )
    }()

    private lazy var menuBarController: MenuBarUIController = {
        MenuBarUIController(
            listeningModeController: self.makeListeningModeController(),
            preferences: self.preferences
        )
    }()
    
    private lazy var keyboardShortcutController: KeyboardShortcutController = {
        KeyboardShortcutController(
            listeningModeController: self.makeListeningModeController(),
            preferences: self.preferences
        )
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        preferences.register()

        touchBarController.install()
        menuBarController.install()

        keyboardShortcutController.setup()
        
        if !preferences.hasLaunchedBefore || UserDefaults.standard.bool(forKey: "NBShowPreferences") {
            preferences.hasLaunchedBefore = true
            showPreferences(self)
        }
    }

    private func makePreferencesController() -> NSWindowController {
        PreferencesViewController.instantiate(with: self.preferences).0
    }

    private var preferencesController: NSWindowController?

    @IBAction func showPreferences(_ sender: Any) {
        preferencesController = makePreferencesController()

        preferencesController?.showWindow(sender)
        NSApp.activate(ignoringOtherApps: false)
    }

    private var activationCount = 0

    func applicationDidBecomeActive(_ notification: Notification) {
        if activationCount > 0 { showPreferences(self) }

        activationCount += 1

        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: false)
        }
    }

}

