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

    // Uma label simples para mostrar na notificação
    let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Define uma cor de fundo para ter certeza que carregou (ex: azul claro)
        self.view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        // 2. Configura e adiciona a label
        statusLabel.text = "Carregando..."
        statusLabel.textAlignment = .center
        statusLabel.textColor = .label
        statusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(statusLabel)
        
        // 3. Centraliza a label na view
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            statusLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            statusLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Define o tamanho preferido da view da extensão
        self.preferredContentSize = CGSize(width: self.view.bounds.width, height: 100)
    }

    func didReceive(_ notification: UNNotification) {
        // Quando a notificação chega, atualizamos o texto da label
        statusLabel.text = "Notificação Personalizada Ativa!"
    }
}


