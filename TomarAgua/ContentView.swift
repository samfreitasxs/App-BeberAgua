//
//  ContentView.swift
//  TomarAgua
//
//  Created by Samuel Freitas on 19/09/25.
//
import SwiftUI
import UserNotifications

// MARK: - View do Recipiente de Água Animado (AGORA UM COPO!)

struct WaterContainerView: View {
    var progress: Double // Progresso de 0.0 a 1.0 (de 0.0 a 1.0)

    var body: some View {
        ZStack {
            // Camada de baixo: O COPO VAZIO (cinza)
            Image(systemName: "waterbottle.fill") // Usando ícone de copo
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray.opacity(0.2))

            // Camada do meio: A ÁGUA (azul), que vai preenchendo
            Image(systemName: "waterbottle.fill") // Usando ícone de copo
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                // --- AJUSTE CRÍTICO AQUI ---
                // Agora o corte começa mais "abaixo" para que a água apareça
                // Multiplicamos por uma altura relativa para preencher o copo
                // O 1.0 - progress faz com que o y diminua (suba) conforme o progresso aumenta
                .clipShape(Rectangle().offset(y: 200 * (1.0 - progress))) // Ajuste a altura 200 conforme o ícone
        }
        // Ajustamos o frame para o formato do copo/garrafa
        .frame(width: 150, height: 200) // Pode ajustar esses valores para o tamanho ideal
        .animation(.easeInOut(duration: 0.5), value: progress)
    }
}


// MARK: - Tela Principal do Aplicativo

struct ContentView: View {
    @State private var showingSettings = false
    
    @AppStorage("dailyWaterCount") private var dailyWaterCount: Int = 0
    @AppStorage("dailyWaterGoal") private var dailyWaterGoal: Int = 8
    @AppStorage("lastLogDate") private var lastLogDate: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()

                    Text("Lembrete para tomar Água meu amor!❤️")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    WaterContainerView(progress: Double(dailyWaterCount) / Double(dailyWaterGoal))
                        .padding(.bottom, 20)

                    VStack {
                        Text("\(dailyWaterCount) de \(dailyWaterGoal) copos")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        HStack(spacing: 20) {
                            Button(action: removeWater) {
                                Image(systemName: "minus")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                            .disabled(dailyWaterCount == 0)
                            
                            Button(action: logWater) {
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        }
                        .shadow(radius: 5)
                    }
                    .padding(30)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Início")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill").font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(dailyWaterGoal: $dailyWaterGoal)
            }
            .onAppear(perform: checkDateAndResetCount)
        }
    }
    
    func logWater() {
        checkDateAndResetCount()
        if dailyWaterCount < dailyWaterGoal {
            dailyWaterCount += 1
        }
    }
    
    func removeWater() {
        checkDateAndResetCount()
        if dailyWaterCount > 0 {
            dailyWaterCount -= 1
        }
    }
    
    func checkDateAndResetCount() {
        let today = Date().formatted(date: .abbreviated, time: .omitted)
        if lastLogDate != today {
            dailyWaterCount = 0
            lastLogDate = today
        }
    }
}

// MARK: - Tela de Configurações e Extensões

struct SettingsView: View {
    @AppStorage("lembretesAtivos") private var lembretesAtivos: Bool = false
    @AppStorage("intervaloNotificacao") private var intervalo: Int = 60
    @AppStorage("horaInicioInterval") private var horaInicioInterval: Double = Date().getIntervalFor(hour: 8)
    @AppStorage("horaFimInterval") private var horaFimInterval: Double = Date().getIntervalFor(hour: 22)
    
    @Binding var dailyWaterGoal: Int
    
    let intervalos = [5, 10, 20, 30, 60, 90, 120]

    @State private var showSaveAlert = false
    @Environment(\.dismiss) var dismiss

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
                    Toggle("Ativar Lembretes", isOn: $lembretesAtivos)
                        .onChange(of: lembretesAtivos) {
                            if lembretesAtivos { solicitarPermissaoEAgendar() } else { pararLembretes() }
                        }
                }

                if lembretesAtivos {
                    Section(header: Text("Configurações dos Lembretes")) {
                        Picker("Lembrar a cada", selection: $intervalo) {
                            ForEach(intervalos, id: \.self) { valor in Text("\(valor) minutos") }
                        }
                        .onChange(of: intervalo) {
                            solicitarPermissaoEAgendar()
                        }
                        
                        DatePicker("Começar às", selection: horaInicioBinding, displayedComponents: .hourAndMinute)
                            .onChange(of: horaInicioInterval) {
                                solicitarPermissaoEAgendar()
                            }
                        
                        DatePicker("Parar às", selection: horaFimBinding, displayedComponents: .hourAndMinute)
                            .onChange(of: horaFimInterval) {
                                solicitarPermissaoEAgendar()
                            }
                    }
                }
                
                Section(header: Text("Meta Diária")) {
                    Stepper("\(dailyWaterGoal) copos por dia", value: $dailyWaterGoal, in: 1...20)
                }
                
                if lembretesAtivos {
                    Section {
                        Button(action: {
                            solicitarPermissaoEAgendar()
                            showSaveAlert = true
                        }) {
                            Text("Salvar e Reagendar Lembretes")
                        }
                    }
                }
            }
            .navigationTitle("Configurações")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") { dismiss() }
                }
            }
            .alert("Configurações Salvas", isPresented: $showSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Seus lembretes foram reagendados com sucesso!")
            }
        }
    }

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

        // MARK: - Adicionar Ações de Notificação (Sim/Não) e Categoria
        let simAction = UNNotificationAction(identifier: "TAKE_WATER_ACTION_YES",
                                             title: "✅ Sim, tomei!",
                                             options: .foreground) // .foreground abrirá o app, .background processa em segundo plano
        let naoAction = UNNotificationAction(identifier: "TAKE_WATER_ACTION_NO",
                                             title: "❌ Não tomei",
                                             options: .destructive) // .destructive pode ter um visual diferente

        // Categoria que agrupa as ações e será usada para as notificações
        let waterCategory = UNNotificationCategory(identifier: "WATER_REMINDER_CATEGORY",
                                                   actions: [simAction, naoAction],
                                                   intentIdentifiers: [],
                                                   options: .customDismissAction) // Permite personalizar o que acontece ao dispensar

        center.setNotificationCategories([waterCategory]) // Registra a categoria no centro de notificações

        var proximaHora = horaInicioDate
        while calendar.component(.hour, from: proximaHora) < horaFimHora {
            let componentes = calendar.dateComponents([.hour, .minute], from: proximaHora)
            let content = UNMutableNotificationContent()
            content.title = "💧 Hora da Hidratação! 💧"
            content.body = "Amor, um copo de água agora para cuidar de você! ❤️"
            content.sound = UNNotificationSound(named: UNNotificationSoundName("810762__mokasza__natural-water-splash-02.aiff"))
            content.categoryIdentifier = "WATER_REMINDER_CATEGORY" // LINKA a notificação à categoria com os botões

            let trigger = UNCalendarNotificationTrigger(dateMatching: componentes, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            proximaHora = calendar.date(byAdding: .minute, value: intervalo, to: proximaHora)!
        }
        
        // --- Agendar o resumo diário (Parte 2, só o agendamento por enquanto) ---
        // Remova qualquer agendamento de resumo antigo
        center.removePendingNotificationRequests(withIdentifiers: ["DAILY_SUMMARY_NOTIFICATION"])
        
        var summaryComponents = DateComponents()
        summaryComponents.hour = 18 // 18h
        summaryComponents.minute = 0
        
        let summaryContent = UNMutableNotificationContent()
        summaryContent.title = "Seu Resumo de Hidratação 📊"
        summaryContent.body = "Vamos ver como você se hidratou hoje! (Este texto será atualizado)"
        summaryContent.sound = UNNotificationSound.default
        summaryContent.categoryIdentifier = "DAILY_SUMMARY_CATEGORY" // Criaremos essa categoria depois
        
        let summaryTrigger = UNCalendarNotificationTrigger(dateMatching: summaryComponents, repeats: true)
        let summaryRequest = UNNotificationRequest(identifier: "DAILY_SUMMARY_NOTIFICATION", content: summaryContent, trigger: summaryTrigger)
        center.add(summaryRequest)
        print("Notificação de resumo agendada para as 18h.")

        print("Lembretes (re)agendados.")
    }

    func pararLembretes() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("Todos os lembretes foram cancelados.")
    }
}


extension Date {
    func getIntervalFor(hour: Int) -> Double {
        return Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: self)!.timeIntervalSinceReferenceDate
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
