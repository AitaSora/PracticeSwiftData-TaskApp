

import Foundation
import SwiftData
import UserNotifications

@Model
final class Todo {
    var content: String
    var goal: String
    var priority: Int
    var isDone: Bool
    var registerDate: Date
    var notificationEnabled: Bool
    var notificationTime: Date
    
    var reflection: String?
    var rating: Int?
    
    init(content: String, goal: String, priority: Int, isDone: Bool = false, notificationEnabled: Bool = false, notificationTime: Date = Date()) {
        self.content = content
        self.goal = goal
        self.priority = priority
        self.isDone = isDone
        self.notificationEnabled = notificationEnabled
        self.notificationTime = notificationTime
        registerDate = Date()
    }
}
