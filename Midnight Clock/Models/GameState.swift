//
//  GameState.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import Foundation

class GameState: ObservableObject {
    @Published var players: [Player]
    @Published var isPaused: Bool
    @Published var gameStartTime: Date
    @Published var currentPlayerIndex: Int
    @Published var isGameOver: Bool
    
    private var timer: Timer?
    private var lastTickTime: Date?
    
    init(playerCount: Int, initialTime: TimeInterval, playerNames: [String], startingPlayerIndex: Int) {
        let positions = Self.getPositions(for: playerCount)
                
        // Initialize all players first
        var initialPlayers = (0..<playerCount).map { index in
            let name = index < playerNames.count && !playerNames[index].isEmpty ? playerNames[index] : "Player \(index + 1)"
            return Player(name: name, initialTime: initialTime, position: positions[index])
        }
        
        // Set the starting player as active
        initialPlayers[startingPlayerIndex].isActive = true
        
        // Now assign to stored properties
        self.players = initialPlayers
        self.currentPlayerIndex = startingPlayerIndex
        self.isPaused = false
        self.gameStartTime = Date()
        self.isGameOver = false
    }
    
    // MARK: - Timer Control
    
    func startTimer() {
        guard timer == nil else { return }
        lastTickTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        lastTickTime = nil
    }
    
    private func tick() {
        guard !isPaused, !isGameOver else {
            // Update lastTickTime even when paused so we don't count paused time
            lastTickTime = Date()
            return
        }
        
        let now = Date()
        guard let lastTick = lastTickTime else {
            lastTickTime = now
            return
        }
        
        let elapsed = now.timeIntervalSince(lastTick)
        lastTickTime = now
        
        let activePlayer = players[currentPlayerIndex]
        
        // Check if tracking uptime
        if let uptimeCategory = activePlayer.activeUptimeCategory {
            players[currentPlayerIndex].addUptime(elapsed, to: uptimeCategory)
        } else {
            // Countdown active player's time
            players[currentPlayerIndex].countdownTime -= elapsed
            
            // Check if player ran out of time
            if players[currentPlayerIndex].countdownTime <= 0 {
                players[currentPlayerIndex].countdownTime = 0
                eliminatePlayer(at: currentPlayerIndex)
            }
        }
    }
    
    // MARK: - Player Actions
    
    func activatePlayer(at index: Int) {
        guard !isGameOver, !players[index].isEliminated else { return }
        
        // Deactivate current player
        players[currentPlayerIndex].isActive = false
        players[currentPlayerIndex].activeUptimeCategory = nil
        
        // Activate new player
        currentPlayerIndex = index
        players[index].isActive = true
    }
    
    func passToNextPlayer() {
        var nextIndex = (currentPlayerIndex + 1) % players.count
        
        // Find next non-eliminated player
        var attempts = 0
        while players[nextIndex].isEliminated && attempts < players.count {
            nextIndex = (nextIndex + 1) % players.count
            attempts += 1
        }
        
        guard !players[nextIndex].isEliminated else {
            endGame()
            return
        }
        
        activatePlayer(at: nextIndex)
    }
    
    func toggleUptime(_ category: UptimeCategory, for playerIndex: Int) {
        guard playerIndex == currentPlayerIndex, !isPaused else { return }
        
        if players[playerIndex].activeUptimeCategory == category {
            // Stop tracking this uptime
            players[playerIndex].activeUptimeCategory = nil
        } else {
            // Start tracking this uptime
            players[playerIndex].activeUptimeCategory = category
        }
    }
    
    func eliminatePlayer(at index: Int) {
        players[index].isEliminated = true
        players[index].isActive = false
        
        // Check if game is over (only one or zero players left)
        let remainingPlayers = players.filter { !$0.isEliminated }
        if remainingPlayers.count <= 1 {
            endGame()
        } else if index == currentPlayerIndex {
            passToNextPlayer()
        }
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    private func endGame() {
        isGameOver = true
        stopTimer()
    }
    
    func restart(startingPlayerIndex: Int) {
        // Reset all players
        for index in players.indices {
            players[index].countdownTime = players[index].initialTime
            players[index].isEliminated = false
            players[index].isActive = false
            players[index].activeUptimeCategory = nil
            players[index].politicsTime = 0
            players[index].searchTime = 0
            players[index].rulesTime = 0
            players[index].shufflingTime = 0
        }
        
        // Set starting player
        currentPlayerIndex = startingPlayerIndex
        players[startingPlayerIndex].isActive = true
        
        // Reset game state
        isPaused = false
        isGameOver = false
        gameStartTime = Date()
        lastTickTime = nil
        
        // Restart timer
        startTimer()
    }
    
    // MARK: - Statistics
    
    var totalGameTime: TimeInterval {
        Date().timeIntervalSince(gameStartTime)
    }
    
    var totalPoliticsTime: TimeInterval {
        players.reduce(0) { $0 + $1.politicsTime }
    }
    
    var totalSearchTime: TimeInterval {
        players.reduce(0) { $0 + $1.searchTime }
    }
    
    var totalRulesTime: TimeInterval {
        players.reduce(0) { $0 + $1.rulesTime }
    }
    
    var totalShufflingTime: TimeInterval {
        players.reduce(0) { $0 + $1.shufflingTime }
    }
    
    // MARK: - Layout Helper
    
    static func getPositions(for playerCount: Int) -> [PlayerPosition] {
        switch playerCount {
        case 2: return [.left, .right]
        case 3: return [.left, .right, .bottom]
        case 4: return [.top, .bottom, .top, .bottom]
        case 5: return [.top, .bottom, .top, .bottom, .left]
        case 6: return [.top, .bottom, .top, .bottom, .left, .right]
        default: return []
        }
    }
}
