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

    let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
                self.view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        statusLabel.text = "Carregando..."
        statusLabel.textAlignment = .center
        statusLabel.textColor = .label
        statusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            statusLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            statusLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.preferredContentSize = CGSize(width: self.view.bounds.width, height: 100)
    }

    func didReceive(_ notification: UNNotification) {
        statusLabel.text = "Notificação Personalizada Ativa!"
    }
}


