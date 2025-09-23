//
//  TomarAguaApp.swift
//  TomarAgua
//
//  Copyright (c) 2025  Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.
//

import SwiftUI
import UserNotifications // Certifique-se de importar UserNotifications

@main
struct TomarAguaApp: App {
    // Crie uma instância do seu AppDelegate customizado
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Certifique-se de que o AppStorage está usando o App Group aqui também!
    // E para todas as outras `@AppStorage` no ContentView e SettingsView
    @AppStorage("dailyWaterCount", store: UserDefaults(suiteName: "group.com.samuelDev.TomarAgua")) var dailyWaterCount: Int = 0

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Se você quiser que o ContentView reaja à atualização imediatamente:
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("waterCountUpdated"))) { _ in
                    // Force a UI a se atualizar lendo novamente do AppStorage
                    self.dailyWaterCount = UserDefaults(suiteName: "group.com.seunome.TomarAgua")?.integer(forKey: "dailyWaterCount") ?? 0
                }
        }
    }
}
