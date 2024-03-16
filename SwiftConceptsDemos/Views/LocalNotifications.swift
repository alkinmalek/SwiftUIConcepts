//
//  LocalNotifications.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 06/03/24.
//

import SwiftUI
import AlertToast

struct LocalNotifications: View {
    @State var notiTile: String = ""
    @State var notiBody: String = ""
    @State var datePicker: Date = .now
    @State var showToast: Bool = false
    @State var toastTile: String = "title"
    
    var body: some View {
        VStack(alignment: .center, spacing: 25.0) {
            TextField("Notification Title", text: $notiTile)
                .textFieldStyle(.roundedBorder)
            
            TextField("Notification Body", text: $notiBody)
                .textFieldStyle(.roundedBorder)
            
            DatePicker("", selection: $datePicker)
            
            Button {
                validateTF(isCustom: false)
            } label: {
                Text("Send Notification in 2 seconds")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.cyan)
            }
            
            Button {
                validateTF(isCustom: true)
            } label: {
                Text("Send Custom Notification")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.cyan)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .toast(isPresenting: $showToast) {
            // `.alert` is the default displayMode
            AlertToast(type: .regular, title: toastTile)
            
            //Choose .hud to toast alert from the top of the screen
            //AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
            
            //Choose .banner to slide/pop alert from the bottom of the screen
            //AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
        }
    }
}

// MARK: - Fns
extension LocalNotifications {
    
    func validateTF(isCustom: Bool) {
        if notiTile.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 {
            setToast(title: "Notification Title cannot be Empty.")
            return
        } else if notiBody.trimmingCharacters(in: .whitespacesAndNewlines).count < 1 {
            setToast(title: "Notification Body cannot be Empty.")
            return
        }
        
        if isCustom {
            sendNotificationOnSelectedDate()
        } else {
            sendSimpleNotification()
        }
    }
    
    func sendSimpleNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Content
        let content = UNMutableNotificationContent()
        content.title = notiTile
        content.body = notiBody
        
        // Sound
        content.sound = UNNotificationSound(named: UNNotificationSoundName("drill.aiff"))
        content.userInfo = ["value": "Data with local notification"]
        
        // Badge
        content.badge = (setNotificationBadge()) as NSNumber
        
        // Image
        let attachment = try! UNNotificationAttachment(identifier: "image", url: Bundle.main.url(forResource: "pic", withExtension: "jpg")!, options: nil)
        content.attachments = [attachment]
        
        // Trigger
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(2)) // After mentioned seconds
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        
        // Request
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
      
    }
    
    func sendNotificationOnSelectedDate() {
        let center = UNUserNotificationCenter.current()
        
        // Content
        let content = UNMutableNotificationContent()
        content.title = notiTile
        content.body = notiBody
        
        // Sound
        content.sound = UNNotificationSound(named: UNNotificationSoundName("drill.aiff"))
        content.userInfo = ["value": "Data with local notification"]
        
        // Badge
        content.badge = (setNotificationBadge()) as NSNumber
        
        // Image
        let attachment = try! UNNotificationAttachment(identifier: "image2", url: Bundle.main.url(forResource: "pic2", withExtension: "jpg")!, options: nil)
        content.attachments = [attachment]
        
        // Trigger
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: datePicker) // After mentioned seconds
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        
        // Request
        let request = UNNotificationRequest(identifier: "reminder2", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
    
    func setToast(title: String) {
        toastTile = title
        showToast = true
    }
    
    func setNotificationBadge() -> Int {
        let key = "Notify"
        let number = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.setValue(number + 1, forKey: key)
        UserDefaults.standard.synchronize()
        return (number + 1)
    }
}

#Preview {
    LocalNotifications()
}
