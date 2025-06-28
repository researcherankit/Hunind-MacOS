Hunind-MacOS
A macOS application that monitors specific apps and tracks their usage time with timer notifications.

Overview
Hunind is a SwiftUI-based macOS application that monitors when a specified app (currently configured for "Opera GX") is running and starts a countdown timer. When the timer reaches zero, it sends a system notification to alert the user.

Features
App Monitoring: Real-time detection of whether a target application is running

Timer Functionality: 15-minute countdown timer that starts when the monitored app launches

System Notifications: Critical notifications when the timer expires

Clean UI: Simple, intuitive interface showing app status and remaining time

Background Monitoring: Continues monitoring even when the app is in the background

Requirements
macOS 11.0 or later

Xcode 12.0 or later

Swift 5.3 or later

Installation
Clone this repository:

bash
git clone https://github.com/yourusername/Hunind-MacOS.git
Open the project in Xcode:

bash
cd Hunind-MacOS
open Hunind.xcodeproj
Build and run the project in Xcode

Usage
Launch the Hunind application

Grant notification permissions when prompted

The app will automatically start monitoring for "Opera GX"

When Opera GX is detected running:

The timer starts counting down from 15 minutes

The interface shows the remaining time

When the timer reaches zero, you'll receive a critical system notification

Configuration
To monitor a different application, modify the appName parameter in ContentView:

swift
@StateObject private var appMonitor = AppMonitor(appName: "Your App Name")
To change the timer duration, modify the timeRemaining initial value:

swift
@State private var timeRemaining: Int = 900 // Change this value (in seconds)
Permissions
The app requires the following permissions:

Notifications: To send alerts when the timer expires

App Monitoring: To detect running applications (handled automatically by NSWorkspace)

Architecture
ContentView: Main UI and timer logic

AppMonitor: ObservableObject class that handles app detection

Timer Integration: Uses Combine framework for reactive timer updates

Notification System: Leverages UserNotifications framework

Contributing
Fork the repository

Create your feature branch (git checkout -b feature/AmazingFeature)

Commit your changes (git commit -m 'Add some AmazingFeature')

Push to the branch (git push origin feature/AmazingFeature)

Open a Pull Request

License
This project is licensed under the MIT License - see the LICENSE file for details.

Author
Created by Ankit Gupta
