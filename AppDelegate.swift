//
//  AppDelegate.swift
//  TomarAgua
//
//  Copyright (c) 2025  Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.

import Foundation
import UIKit
import UserNotifications

let APP_GROUP_ID = "group.com.samuelDev.TomarAgua"

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        print("🔔 [DEBUG] AppDelegate: Delegado de notificação configurado.")
        return true
    }
    
    // MARK: - UNUserNotificationCenterDelegate
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("🔔 [DEBUG] AppDelegate: Recebeu resposta da notificação. Action ID: \(response.actionIdentifier)")
        
        guard let userDefaults = UserDefaults(suiteName: APP_GROUP_ID) else {
            print("❌ [DEBUG] ERRO CRÍTICO: Não foi possível acessar UserDefaults com o App Group: \(APP_GROUP_ID). Verifique a configuração!")
            completionHandler()
            return
        }
        
        switch response.actionIdentifier {
        case "TAKE_WATER_ACTION_YES":
            print("✅ [DEBUG] Ação SIM detectada.")
            var currentCount = userDefaults.integer(forKey: "dailyWaterCount")
            let dailyGoal = userDefaults.integer(forKey: "dailyWaterGoal")
            print("   -> Contagem atual antes: \(currentCount), Meta: \(dailyGoal)")
            
            if currentCount < dailyGoal {
                currentCount += 1
                userDefaults.set(currentCount, forKey: "dailyWaterCount")
                userDefaults.synchronize()
                print("   -> Nova contagem salva: \(currentCount)")
            } else {
                print("   -> Meta já atingida, não incrementou.")
            }
            
            DispatchQueue.main.async {
                print("🔔 [DEBUG] Enviando notificação para atualizar a UI.")
                NotificationCenter.default.post(name: NSNotification.Name("waterCountUpdated"), object: nil)
            }
            
        case "TAKE_WATER_ACTION_NO":
            print("❌ [DEBUG] Ação NÃO detectada.")
            
        default:
            print("ℹ️ [DEBUG] Outra ação ou clique na notificação.")
        }
        
        completionHandler()
        print("🔔 [DEBUG] Completion handler chamado. Fim do processamento.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("🔔 [DEBUG] Notificação recebida com app em primeiro plano. Mostrando banner.")
        completionHandler([.banner, .sound, .badge])
    }
}
