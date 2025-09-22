//
//  ContentView.swift
//  TomarAgua
//
//  Created by Samuel Freitas on 19/09/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {

    var body: some View {
        // Usamos um ZStack para colocar uma cor de fundo gradiente
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            // Organiza os elementos verticalmente
            VStack(spacing: 30) {
                Spacer()

                // Ícone principal
                Image(systemName: "drop.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                    .shadow(radius: 5)

                // Título do App
                Text("Lembrete de Água")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.gray.opacity(0.9))

                // Mensagem carinhosa
                Text("Um lembrete para você se manter sempre hidratada, meu amor. ❤️")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Spacer()

                // Botão para ativar os lembretes
                Button(action: {
                    ativarLembretes()
                }) {
                    Text("Ativar Lembretes (a cada hora)")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)

                // Botão para parar os lembretes
                Button(action: {
                    pararLembretes()
                }) {
                    Text("Parar Lembretes")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }

    // MARK: - Funções de Notificação

    /// Solicita permissão e agenda as notificações
    func ativarLembretes() {
        let center = UNUserNotificationCenter.current()

        // 1. Solicita permissão ao usuário para enviar notificações
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permissão para notificações concedida!")
                agendarNotificacoes()
            } else if let error = error {
                print("Erro ao solicitar permissão: \(error.localizedDescription)")
            }
        }
    }

    /// Agenda as notificações recorrentes
    func agendarNotificacoes() {
        let center = UNUserNotificationCenter.current()
        // Limpa notificações antigas para não acumular
        center.removeAllPendingNotificationRequests()

        // 2. Define o conteúdo da notificação
        let content = UNMutableNotificationContent()
        content.title = "💧 Hora de Beber Água!! 💧"
        content.body = "Amor, não se esqueça de se hidratar. É importante para sua saúde!"
        content.sound = UNNotificationSound.default // Som padrão do sistema

        // 3. Define o gatilho (trigger) - a cada 1 hora (3600 segundos)
        // O `repeats` como `true` faz a notificação ser recorrente
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)

        // 4. Cria a requisição da notificação
        let request = UNNotificationRequest(identifier: "lembreteAgua", content: content, trigger: trigger)

        // 5. Adiciona a requisição ao centro de notificações
        center.add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            } else {
                print("Lembretes agendados com sucesso para cada hora!")
            }
        }
    }

    /// Cancela todas as notificações pendentes
    func pararLembretes() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("Todos os lembretes foram cancelados.")
    }
}

// Isso é usado para pré-visualizar o design no Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
