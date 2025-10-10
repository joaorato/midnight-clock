//
//  EndGameView.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import SwiftUI

struct EndGameView: View {
    @ObservedObject var gameState: GameState
    let onRestart: () -> Void
    let onNewGame: () -> Void
    
    @State private var showingRestartPicker = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 40) {
                        // Header
                        VStack(spacing: 10) {
                            Text("Game Over")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Total Game Time: \(gameState.totalGameTime.formattedTimer())")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                        // Winner section
                        if let winner = gameState.players.first(where: { !$0.isEliminated }) {
                            VStack(spacing: 15) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.yellow)
                                
                                Text(winner.name.isEmpty ? "Winner" : "\(winner.name) Wins!")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Time Remaining: \(winner.countdownTime.formattedTimer())")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.1))
                            )
                            .padding(.horizontal)
                        }
                        
                        // Individual player statistics
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Player Statistics")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(Array(gameState.players.enumerated()), id: \.element.id) { index, player in
                                PlayerStatCard(player: player, rank: eliminationRank(for: player))
                            }
                        }
                        
                        // Aggregate statistics
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Aggregate Statistics")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            AggregateStatsView(gameState: gameState)
                        }
                        
                        // Buttons section
                        VStack(spacing: 15) { // Reduced spacing from default
                            // Restart button
                            Button(action: {
                                showingRestartPicker = true
                            }) {
                                Text("Restart Game")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange.opacity(0.8))
                                    .cornerRadius(15)
                            }
                            
                            // New Game button
                            Button(action: onNewGame) {
                                Text("New Game")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.8))
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
                .alert("Select Starting Player", isPresented: $showingRestartPicker) {
                    ForEach(gameState.players.indices, id: \.self) { index in
                        Button(gameState.players[index].name) {
                            gameState.restart(startingPlayerIndex: index)
                            onRestart()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Choose who goes first in the restarted game")
                }
            }
        }
        .statusBar(hidden: true)
    }
    
    // MARK: - Helper Functions
    
    private func eliminationRank(for player: Player) -> String {
        if !player.isEliminated {
            return "Winner"
        }
        
        // For eliminated players, we'd need to track elimination order
        // For now, just show "Eliminated"
        return "Eliminated"
    }
}

// MARK: - Player Stat Card

struct PlayerStatCard: View {
    let player: Player
    let rank: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header with player name and rank
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(player.name.isEmpty ? "Player" : player.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(rank)
                        .font(.subheadline)
                        .foregroundColor(rank == "Winner" ? .green : .red)
                }
                
                Spacer()
                
                if rank == "Winner" {
                    Image(systemName: "crown.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Time statistics
            VStack(spacing: 12) {
                StatRow(
                    label: "Time Used",
                    value: (player.initialTime - player.countdownTime).formattedTimer(),
                    icon: "clock.fill",
                    color: .blue
                )
                
                StatRow(
                    label: "Time Remaining",
                    value: max(0, player.countdownTime).formattedTimer(),
                    icon: "hourglass",
                    color: player.countdownTime > 0 ? .green : .red
                )
                
                StatRow(
                    label: "Search Time",
                    value: player.searchTime.formattedTimer(),
                    icon: "magnifyingglass",
                    color: .orange
                )
                
                StatRow(
                    label: "Shuffling Time",
                    value: player.shufflingTime.formattedTimer(),
                    icon: "shuffle",
                    color: .yellow
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

// MARK: - Stat Row

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .monospacedDigit()
        }
    }
}

// MARK: - Aggregate Stats View

struct AggregateStatsView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(spacing: 15) {
            AggregateStatCard(
                title: "Total Politics Time",
                value: gameState.politicsTime.formattedTimer(),
                icon: "bubble.left.and.bubble.right.fill",
                color: .purple,
                percentage: percentageOf(gameState.politicsTime)
            )
            
            AggregateStatCard(
                title: "Total Search Time",
                value: gameState.totalSearchTime.formattedTimer(),
                icon: "magnifyingglass",
                color: .orange,
                percentage: percentageOf(gameState.totalSearchTime)
            )
            
            AggregateStatCard(
                title: "Total Rules Time",
                value: gameState.rulesTime.formattedTimer(),
                icon: "book.fill",
                color: .cyan,
                percentage: percentageOf(gameState.rulesTime)
            )
            
            AggregateStatCard(
                title: "Total Shuffling Time",
                value: gameState.totalShufflingTime.formattedTimer(),
                icon: "shuffle",
                color: .yellow,
                percentage: percentageOf(gameState.totalShufflingTime)
            )
            
            // Total non-gameplay time
            let totalUptimeAcrossAll = gameState.politicsTime +
                                       gameState.totalSearchTime +
                                       gameState.rulesTime +
                                       gameState.totalShufflingTime
            
            Divider()
                .background(Color.white.opacity(0.3))
                .padding(.vertical, 10)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Non-Gameplay Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(percentageOf(totalUptimeAcrossAll))% of game time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(totalUptimeAcrossAll.formattedTimer())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.2))
            )
        }
        .padding(.horizontal)
    }
    
    private func percentageOf(_ time: TimeInterval) -> Int {
        let totalTime = gameState.totalGameTime
        guard totalTime > 0 else { return 0 }
        return Int((time / totalTime) * 100)
    }
}

// MARK: - Aggregate Stat Card

struct AggregateStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let percentage: Int
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            // Title and percentage
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                
                Text("\(percentage)% of game")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Value
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .monospacedDigit()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

#Preview {
    let gameState = GameState(
        playerCount: 4,
        initialTime: 1200,
        playerNames: ["Alice", "Bob", "Charlie", "Diana"],
        startingPlayerIndex: 0
    )
    
    // Simulate game started 30 minutes ago
    gameState.gameStartTime = Date().addingTimeInterval(-1800)
    
    // Simulate some game time
    gameState.players[0].countdownTime = 800
    gameState.players[0].searchTime = 45
    
    gameState.players[1].countdownTime = 0
    gameState.players[1].isEliminated = true
    
    gameState.players[2].countdownTime = 600
    gameState.players[2].shufflingTime = 75
    
    gameState.players[3].countdownTime = 450
    
    gameState.politicsTime = 120
    gameState.rulesTime = 180
    gameState.isGameOver = true
    
    return EndGameView(gameState: gameState, onRestart: {}, onNewGame: {})
}
