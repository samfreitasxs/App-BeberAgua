//
//  NotificationViewController.swift
//  WaterNotificationUI
//
//  Copyright (c) 2025  Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
