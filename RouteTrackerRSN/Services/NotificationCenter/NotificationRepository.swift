//
//  NotificationRepository.swift
//  RouteTrackerRSN
//
//  Created by Sergey Razgulyaev on 22.04.2021.
//

import Foundation
import UserNotifications

final class NotificationRepository {
    //MARK: - Properties
    let notificationCenter = UNUserNotificationCenter.current()
    
    //MARK: - Init
    init() {
        configureNotificationCenter()
    }
    
    //MARK: - Configuration Methods
    private func configureNotificationCenter() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Permission not received")
                return
            }
            self.sendNotificationRequest(
                content: self.makeNotificationContent(title: "Recommendations",
                                                      body: "Return to RouteTrackerRSN",
                                                      badge: 1),
                trigger: self.makeNotificationTrigger(timeInterval: 30*60,
                                                      repeats: false))
        }
    }
    
    //MARK: - Methods
    private func sendNotificationRequest(content: UNNotificationContent,
                                         trigger: UNNotificationTrigger? = nil) {
        let notificationRequest = UNNotificationRequest(identifier: "alarm",
                                                        content: content,
                                                        trigger: trigger)
        notificationCenter.add(notificationRequest) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeNotificationContent(title: String,
                                         body: String,
                                         badge: NSNumber) -> UNNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.badge = badge
        notificationContent.sound = .default
        return notificationContent
    }
    
    private func makeNotificationTrigger(timeInterval: Double,
                                         repeats: Bool) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger (timeInterval: timeInterval,
                                                  repeats: repeats)
    }
}
