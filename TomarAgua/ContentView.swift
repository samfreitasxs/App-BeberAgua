//
//  ContentView.swift
//  TomarAgua
//
//  Created by Samuel Freitas on 19/09/25.
//

import SwiftUI
import UserNotifications

// MARK: - Tela Principal do Aplicativo

struct ContentView: View {
    // Variável de estado para controlar se a tela de configurações está visível
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            // Usamos um ZStack para colocar a cor de fundo gradiente
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                // Organiza os elementos verticalmente (o layout antigo que você gostava)
                VStack(spacing: 30) {
                    Spacer()

                    Image(systemName: "drop.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                        .shadow(radius: 5)

                    Text("Lembrete de Água")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary) // Corrigido para Dark Mode

                    Text("Toque na engrenagem ⚙️ para ajustar os lembretes.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary) // Corrigido para Dark Mode
                        .padding(.horizontal)

                    Spacer()
                    Spacer()
                }
            }
            .navigationTitle("Início")
            .navigationBarTitleDisplayMode(.inline)
            // Adiciona um botão (a engrenagem) na barra de navegação
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Ao tocar, ativa a nossa variável de estado
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                    }
                }
            }
            // A "mágica" acontece aqui: quando `showingSettings` for true,
            // a tela `SettingsView` será apresentada.
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

// MARK: - Tela de Configurações

struct SettingsView: View {
    // Propriedades para Configuração
    @AppStorage("lembretesAtivos") private var lembretesEstaoAtivos: Bool = false
    @AppStorage("intervaloNotificacao") private var intervalo: Int = 60
    @AppStorage("horaInicioInterval") private var horaInicioInterval: Double = Date().getIntervalFor(hour: 8)
    @AppStorage("horaFimInterval") private var horaFimInterval: Double = Date().getIntervalFor(hour: 22)
    
    let intervalos = [30, 60, 90, 120]

    var body: some View {
        let horaInicioBinding = Binding<Date>(
            get: { Date(timeIntervalSinceReferenceDate: self.horaInicioInterval) },
            set: { self.horaInicioInterval = $0.timeIntervalSinceReferenceDate }
        )
        
        let horaFimBinding = Binding<Date>(
            get: { Date(timeIntervalSinceReferenceDate: self.horaFimInterval) },
            set: { self.horaFimInterval = $0.timeIntervalSinceReferenceDate }
        )
        
        return NavigationView {
            Form {
                Section(header: Text("Controle Geral")) {
                    Toggle("Ativar Lembretes", isOn: $lembretesEstaoAtivos)
                        .onChange(of: lembretesEstaoAtivos) { ativado in
                            if ativado {
                                solicitarPermissaoEAgendar()
                            } else {
                                pararLembretes()
                            }
                        }
                }

                if lembretesEstaoAtivos {
                    Section(header: Text("Configurações")) {
                        Picker("Lembrar a cada", selection: $intervalo) {
                            ForEach(intervalos, id: \.self) { valor in
                                Text("\(valor) minutos")
                            }
                        }
                        
                        DatePicker("Começar às", selection: horaInicioBinding, displayedComponents: .hourAndMinute)
                        DatePicker("Parar às", selection: horaFimBinding, displayedComponents: .hourAndMinute)
                    }
                    
                    Section {
                        Button(action: {
                            solicitarPermissaoEAgendar()
                        }) {
                            Text("Salvar e Reagendar Lembretes")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .navigationTitle("Configurações")
        }
    }

    // Funções de Notificação
    
    func solicitarPermissaoEAgendar() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted { agendarNotificacoes() }
        }
    }

    func agendarNotificacoes() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let calendar = Calendar.current
        let horaInicioDate = Date(timeIntervalSinceReferenceDate: horaInicioInterval)
        let horaFimDate = Date(timeIntervalSinceReferenceDate: horaFimInterval)
        let horaFimComponentes = calendar.dateComponents([.hour, .minute], from: horaFimDate)
        guard let horaFimHora = horaFimComponentes.hour else { return }
        
        var proximaHora = horaInicioDate
        while calendar.component(.hour, from: proximaHora) < horaFimHora {
            let componentes = calendar.dateComponents([.hour, .minute], from: proximaHora)
            let content = UNMutableNotificationContent()
            content.title = "💧 Hora da Hidratação! 💧"
            content.body = "Amor, um copo de água agora para cuidar de você! ❤️"
            content.sound = UNNotificationSound.default
            let trigger = UNCalendarNotificationTrigger(dateMatching: componentes, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            proximaHora = calendar.date(byAdding: .minute, value: intervalo, to: proximaHora)!
        }
        print("Lembretes (re)agendados.")
    }

    func pararLembretes() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("Todos os lembretes foram cancelados.")
    }
}

// Extensão (sem mudanças)
extension Date {
    func getIntervalFor(hour: Int) -> Double {
        return Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: self)!.timeIntervalSinceReferenceDate
    }
}

// Preview (sem mudanças)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
