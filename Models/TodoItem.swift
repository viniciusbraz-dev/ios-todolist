import Foundation
import SwiftUI
import SwiftData

@Model
final class TodoItem {
    var title: String
    var notes: String
    var isCompleted: Bool
    var createdAt: Date
    var priority: Priority

    init(
        title: String,
        notes: String = "",
        isCompleted: Bool = false,
        createdAt: Date = .now,
        priority: Priority = .none
    ) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.priority = priority
    }
}

enum Priority: Int, CaseIterable, Codable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3

    var label: String {
        switch self {
        case .none:   return "Nenhuma"
        case .low:    return "Baixa"
        case .medium: return "Média"
        case .high:   return "Alta"
        }
    }

    var color: Color {
        switch self {
        case .none:   return .gray
        case .low:    return .blue
        case .medium: return .orange
        case .high:   return .red
        }
    }
}
