//
//  NotificationService.swift
//  WaterSummaryService
//  Copyright (c) 2025  Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if request.identifier == "DAILY_SUMMARY_NOTIFICATION" {
            if let bestAttemptContent = bestAttemptContent {
                let userDefaults = UserDefaults(suiteName: "group.com.samuelDev.TomarAgua") ?? .standard
                let waterCount = userDefaults.integer(forKey: "dailyWaterCount")
                let waterGoal = userDefaults.integer(forKey: "dailyWaterGoal")

                bestAttemptContent.body = "Você tomou \(waterCount) de \(waterGoal) copos de água hoje! Continue se hidratando. ❤️"
                contentHandler(bestAttemptContent)
            }
        } else {
            if let bestAttemptContent = bestAttemptContent {
                contentHandler(bestAttemptContent)
            }
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
