//
//  Notes.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 06/03/24.
//

import SwiftUI

// MARK: - For iOS Notifications
/*
 - If you want to debug when notification is sent , use Notification extension and add func didReceive make sure apns Payload is proper with mutable content
 - Silent Notification will not be displayed , it will only be useful for performing task and not displaying it
 - If notification title and body is nil it will not showup
 - For remote notification fcms is used to send notification for firebase or else device token
 - 5. For Testing Notifications Through Apple:
    https://icloud.developer.apple.com/dashboard/notifications/teams/392S6Q4Z98/app/com.blabblab.blab/notifications
 - 6. If using firebase it can also be tested via Firebase console, we just need is fcm token
 
 */
