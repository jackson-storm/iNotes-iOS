import SwiftUI

enum NoteCategory: String, Codable, CaseIterable {
    case all
    case banks
    case creditCards
    case work
    case payments
    case shopping
    case travel
    case messages
    case health
    case personal
}

extension NoteCategory {
    var color: Color {
        switch self {
        case .banks: return .red
        case .creditCards: return .green
        case .work: return .orange
        case .payments: return .blue
        case .shopping: return .purple
        case .travel: return .teal
        case .messages: return .yellow
        case .health: return .pink
        case .personal: return .indigo
        case .all: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .banks: return "dollarsign.bank.building.fill"
        case .creditCards: return "creditcard.fill"
        case .work: return "briefcase.fill"
        case .payments: return "banknote.fill"
        case .shopping: return "cart.fill"
        case .travel: return "airplane"
        case .messages: return "ellipsis.message.fill"
        case .health: return "heart.fill"
        case .personal: return "person.fill"
        case .all: return "folder.fill"
        }
    }
    
    var iconMenu: String {
        switch self {
        case .banks: return "dollarsign.bank.building"
        case .creditCards: return "creditcard"
        case .work: return "briefcase"
        case .payments: return "banknote"
        case .shopping: return "cart"
        case .travel: return "airplane"
        case .messages: return "ellipsis.message"
        case .health: return "heart"
        case .personal: return "person"
        case .all: return "folder"
        }
    }
}
