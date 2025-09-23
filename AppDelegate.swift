//
//  AppDelegate.swift
//  TomarAgua
//
//  Copyright (c) 2025  Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // Função chamada quando o aplicativo termina de carregar
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        print("AppDelegate configurado para UserNotificationCenter.")
        return true
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Esta função é chamada quando o usuário interage com uma notificação (clica em um botão)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.com.samuelDev.TomarAgua") ?? .standard
        
        switch response.actionIdentifier {
        case "TAKE_WATER_ACTION_YES":
            print("Usuário clicou em SIM na notificação!")
            var currentCount = userDefaults.integer(forKey: "dailyWaterCount")
            let dailyGoal = userDefaults.integer(forKey: "dailyWaterGoal")
            if currentCount < dailyGoal {
                currentCount += 1
                userDefaults.set(currentCount, forKey: "dailyWaterCount")
            }
            // Disparar uma notificação local para atualizar a UI do app se ele estiver aberto
            NotificationCenter.default.post(name: NSNotification.Name("waterCountUpdated"), object: nil)
        case "TAKE_WATER_ACTION_NO":
            print("Usuário clicou em NÃO na notificação.")
            // Nenhuma ação específica para "Não" além de registrar, se necessário
        case UNNotificationDefaultActionIdentifier: // O usuário clicou na notificação em si, não nos botões
            print("Usuário clicou na notificação padrão.")
            // Poderia abrir uma tela específica do app
        case UNNotificationDismissActionIdentifier: // O usuário dispensou a notificação
            print("Usuário dispensou a notificação.")
        default:
            print("Ação de notificação desconhecida: \(response.actionIdentifier)")
            break
        }
        
        
        completionHandler()
    }
    
    // Esta função garante que a notificação é exibida mesmo com o app em primeiro plano
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notificação será apresentada enquanto o app está em primeiro plano.")
        completionHandler([.banner, .sound, .badge]) // Mostra a notificação normalmente
    }
}
