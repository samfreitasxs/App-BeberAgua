//
//  AppDelegate.swift
//  TomarAgua
//
//  Created by Samuel Freitas on [Data].
//

import Foundation
import UIKit
import UserNotifications

// SEU ID DE APP GROUP REAL AQUI:
let APP_GROUP_ID = "group.com.samuelDev.TomarAgua" // <--- VERIFIQUE ISSO!

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        print("🔔 [DEBUG] AppDelegate: Delegado de notificação configurado.")
        return true
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Função chamada quando você CLICA em um botão da notificação
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
                // Força a sincronização para garantir que salvou no disco
                userDefaults.synchronize()
                print("   -> Nova contagem salva: \(currentCount)")
            } else {
                print("   -> Meta já atingida, não incrementou.")
            }
            
            // Avisa a UI para atualizar
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
    
    // Função para mostrar notificação com app aberto
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("🔔 [DEBUG] Notificação recebida com app em primeiro plano. Mostrando banner.")
        completionHandler([.banner, .sound, .badge])
    }
}
