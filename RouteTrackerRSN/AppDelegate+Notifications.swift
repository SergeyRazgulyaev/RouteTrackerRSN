//
//  AppDelegate+Notifications.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 23.04.2021.
//

import Foundation
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("You opened the application from the notification")
    }
}
