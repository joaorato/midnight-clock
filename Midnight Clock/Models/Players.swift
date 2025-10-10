//
//  Players.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import Foundation

struct Player: Identifiable, Codable {
    let id: UUID
    var name: String
    var countdownTime: TimeInterval // Remaining time in seconds
    var initialTime: TimeInterval // Starting time for percentage calculations
    var isActive: Bool
    var isEliminated: Bool
    var position: PlayerPosition // For layout
    
    // Uptime trackers
    var searchTime: TimeInterval
    var shufflingTime: TimeInterval
    
    var activeUptimeCategory: UptimeCategory?
    
    init(id: UUID = UUID(), name: String, initialTime: TimeInterval, position: PlayerPosition) {
        self.id = id
        self.name = name
        self.countdownTime = initialTime
        self.initialTime = initialTime
        self.isActive = false
        self.isEliminated = false
        self.position = position
        self.searchTime = 0
        self.shufflingTime = 0
        self.activeUptimeCategory = nil
    }
    
    var isLowTime: Bool {
        countdownTime <= (initialTime * 0.1)
    }
    
    var hasTimeRemaining: Bool {
        countdownTime > 0
    }
    
    func uptimeFor(category: UptimeCategory) -> TimeInterval {
        switch category {
        case .search: return searchTime
        case .shuffling: return shufflingTime
        }
    }
    
    mutating func addUptime(_ interval: TimeInterval, to category: UptimeCategory) {
        switch category {
        case .search: searchTime += interval
        case .shuffling: shufflingTime += interval
        }
    }
}

enum UptimeCategory: String, Codable, CaseIterable {
    case search
    case shuffling
    
    var iconName: String {
        switch self {
        case .search: return "magnifyingglass"
        case .shuffling: return "shuffle"
        }
    }
    
    var displayName: String {
        switch self {
        case .search: return "Search"
        case .shuffling: return "Shuffling"
        }
    }
}

enum GlobalUptimeCategory: String, Codable, CaseIterable {
    case politics
    case rules
    
    var iconName: String {
        switch self {
        case .politics: return "bubble.left.and.bubble.right"
        case .rules: return "book"
        }
    }
    
    var displayName: String {
        switch self {
        case .politics: return "Politics"
        case .rules: return "Rules"
        }
    }
}

enum PlayerPosition: Codable {
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
