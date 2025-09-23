//
//  TomarAguaApp.swift
//  TomarAgua
//
//  Copyright (c) 2025  Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.
//

import SwiftUI
import UserNotifications

@main
struct TomarAguaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("dailyWaterCount", store: UserDefaults(suiteName: "group.com.samuelDev.TomarAgua")) var dailyWaterCount: Int = 0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("waterCountUpdated"))) { _ in
                    self.dailyWaterCount = UserDefaults(suiteName: "group.com.seunome.TomarAgua")?.integer(forKey: "dailyWaterCount") ?? 0
                }
        }
    }
}
