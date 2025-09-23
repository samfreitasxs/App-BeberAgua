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

    // Adicione os botões programaticamente ou via Storyboard/XIB
    // Para simplificar, vamos criar os botões aqui programaticamente.
    let yesButton = UIButton(type: .system)
    let noButton = UIButton(type: .system)
    let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura a view para ser transparente ou com uma cor de fundo
        self.view.backgroundColor = .clear // Ou .systemGray5 para um fundo discreto

        setupButtons()
        setupMessageLabel()
    }

    func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .white // Ou a cor que combine com seu tema
        self.view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }
    
    func setupButtons() {
        // Estiliza o botão SIM
        yesButton.setTitle("✅ Sim, tomei!", for: .normal)
        yesButton.backgroundColor = .systemGreen
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.layer.cornerRadius = 8
        yesButton.addTarget(self, action: #selector(didTapYes), for: .touchUpInside)
        
        // Estiliza o botão NÃO
        noButton.setTitle("❌ Não tomei", for: .normal)
        noButton.backgroundColor = .systemRed
        noButton.setTitleColor(.white, for: .normal)
        noButton.layer.cornerRadius = 8
        noButton.addTarget(self, action: #selector(didTapNo), for: .touchUpInside)
        
        // StackView para organizar os botões lado a lado
        let stackView = UIStackView(arrangedSubviews: [yesButton, noButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 44) // Altura padrão de botões
        ])
    }
    
    // As ações dos botões na notificação não são tratadas aqui diretamente,
    // mas são enviadas para o app principal via `UNNotificationResponse`.
    // O objetivo aqui é apenas "simular" o clique visualmente,
    // e o sistema iOS se encarregará de disparar a ação correta para o app principal.
    @objc func didTapYes() {
        // Você pode adicionar um feedback visual aqui, se quiser
        print("Botão Sim na notificação foi tocado.")
        // O iOS cuidará de enviar a ação "TAKE_WATER_ACTION_YES" para o AppDelegate/SceneDelegate
    }
    
    @objc func didTapNo() {
        print("Botão Não na notificação foi tocado.")
        // O iOS cuidará de enviar a ação "TAKE_WATER_ACTION_NO" para o AppDelegate/SceneDelegate
    }

    func didReceive(_ notification: UNNotification) {
        // Atualiza a label com o corpo da notificação padrão
        self.messageLabel.text = notification.request.content.body
        // Você pode obter o título ou outras informações da notificação aqui
        // notification.request.content.title
    }
}
