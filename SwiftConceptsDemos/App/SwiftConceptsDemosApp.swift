//
//  SwiftConceptsDemosApp.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 06/03/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftConceptsDemosApp: App {
    
    //App Delegate
    @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    appDelegate.app = self
                }
        }
        .modelContainer(for: Destination.self) // For Swift Data
    }
}
