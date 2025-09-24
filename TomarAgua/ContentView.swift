//
//  ContentView.swift
//  TomarAgua
//
//  Copyright (c) 2025 Samuel Freitas. All rights reserved.
//  Licenciado sob a Licença MIT.
//

import SwiftUI
import UserNotifications

// MARK: - View do Ícone Humano Animado

struct HumanHydrationView: View {
    var progress: Double // Progresso de 0.0 a 1.0

    var body: some View {
        ZStack {
      
            Image(systemName: "waterbottle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray.opacity(0.2))

            Image(systemName: "waterbottle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .clipShape(Rectangle().offset(y: 250 * (1.0 - progress)))
        }
        .frame(width: 150, height: 270)
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

                    // --- MUDANÇA AQUI: Usamos a nova HumanHydrationView ---
                    HumanHydrationView(progress: Double(dailyWaterCount) / Double(dailyWaterGoal))
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
        
        var proximaHora = horaInicioDate
        while calendar.component(.hour, from: proximaHora) < horaFimHora {
            let componentes = calendar.dateComponents([.hour, .minute], from: proximaHora)
            let content = UNMutableNotificationContent()
            content.title = "💧 Hora da Hidratação! 💧"
            content.body = "Amor, um copo de água agora para cuidar de você! ❤️"
            content.sound = UNNotificationSound(named: UNNotificationSoundName("810762__mokasza__natural-water-splash-02.aiff"))
            
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
