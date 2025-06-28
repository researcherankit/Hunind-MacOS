//
//  HunindApp.swift
//  Hunind
//
//  Created by Ankit Gupta on 24/02/23.
//

import SwiftUI
import Combine
import UserNotifications

struct ContentView: View {
    @StateObject private var appMonitor = AppMonitor(appName: "Opera GX")
    @State private var timer: AnyCancellable?
    @State private var timeRemaining: Int = 900 // 1 hour in seconds
    
    var body: some View {
        VStack {
            Text("App Monitor")
                .font(.largeTitle)
            
            if appMonitor.isAppRunning {
                Text("The app is running. Timer started!")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("The app is not running.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            if appMonitor.isAppRunning {
                Text("Time remaining: \(timeString(from: timeRemaining))")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            startMonitoring()
            requestNotificationPermission()
        }
        .onDisappear {
            timer?.cancel()
        }
    }
    
    func startMonitoring() {
        appMonitor.startBackgroundCheck()
        appMonitor.$isAppRunning
            .receive(on: RunLoop.main)
            .sink { isRunning in
                if isRunning {
                    startTimer()
                } else {
                    stopTimer()
                }
            }
            .store(in: &appMonitor.cancellables)
    }
    
    func startTimer() {
        timer?.cancel()
        timeRemaining = 900
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.cancel()
                    sendNotification()
                }
            }
    }
    
    func stopTimer() {
        timer?.cancel()
        timeRemaining = 900
    }
    
    func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Ended"
        content.body = "The one-hour timer has ended."
        content.sound = UNNotificationSound.defaultCritical
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}

class AppMonitor: ObservableObject {
    @Published var isAppRunning: Bool = false
    let appName: String
    var cancellables: Set<AnyCancellable> = []
    private var backgroundTimer: AnyCancellable?
    
    init(appName: String) {
        self.appName = appName
        checkAppStatus()
    }
    
    func startBackgroundCheck() {
        backgroundTimer = Timer.publish(every: 1200, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAppStatus()
            }
    }
    
    private func checkAppStatus() {
        let runningApps = NSWorkspace.shared.runningApplications
        isAppRunning = runningApps.contains { $0.localizedName == appName }
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
