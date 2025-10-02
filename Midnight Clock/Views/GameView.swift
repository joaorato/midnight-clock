//
//  GameView.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import SwiftUI

struct GameView: View {
    @ObservedObject var gameState: GameState
    let onExit: () -> Void
    
    @State private var showingMenu = false
    @State private var showingEndGame = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Main game board
                playerLayout(in: geometry.size)
                
                // Top controls overlay
                VStack {
                    HStack {
                        // Menu button
                        Button(action: { showingMenu = true }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Pause button
                        Button(action: { gameState.togglePause() }) {
                            Image(systemName: gameState.isPaused ? "play.fill" : "pause.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Pause overlay
                if gameState.isPaused {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            gameState.togglePause()
                        }
                    
                    Text("PAUSED")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingMenu) {
                MenuView(
                    gameState: gameState,
                    onResume: { showingMenu = false },
                    onRestart: { 
                        // Restart logic - for now just close menu
                        showingMenu = false
                    },
                    onNewGame: {
                        gameState.stopTimer()
                        onExit()
                    }
                )
            }
            .onChange(of: gameState.isGameOver) { isOver in
                if isOver {
                    showingEndGame = true
                }
            }
            .fullScreenCover(isPresented: $showingEndGame) {
                EndGameView(gameState: gameState, onNewGame: {
                    gameState.stopTimer()
                    onExit()
                })
            }
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true // Keep screen awake
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            gameState.stopTimer()
        }
    }
    
    @ViewBuilder
    private func playerLayout(in size: CGSize) -> some View {
        let playerCount = gameState.players.count
        
        switch playerCount {
        case 2:
            twoPlayerLayout(in: size)
        case 3:
            threePlayerLayout(in: size)
        case 4:
            fourPlayerLayout(in: size)
        case 5:
            fivePlayerLayout(in: size)
        case 6:
            sixPlayerLayout(in: size)
        default:
            EmptyView()
        }
    }
    
    // MARK: - 2 Player Layout (Top vs Bottom, facing each other)
        
    private func twoPlayerLayout(in size: CGSize) -> some View {
        VStack(spacing: 0) {
            // Top player (upside down)
            ZStack {
                playerRectangle(for: 0, size: CGSize(width: size.width - 40, height: size.height / 2 - 20))
            }
            .frame(width: size.width - 40, height: size.height / 2 - 20)
            .rotationEffect(.degrees(180))
            
            // Bottom player (normal orientation)
            ZStack {
                playerRectangle(for: 1, size: CGSize(width: size.width - 40, height: size.height / 2 - 20))
            }
            .frame(width: size.width - 40, height: size.height / 2 - 20)
        }
        .frame(width: size.width, height: size.height)
    }
    
    // MARK: - 3 Player Layout (2 facing horizontally + 1 at bottom)
        
    private func threePlayerLayout(in size: CGSize) -> some View {
        VStack(spacing: 0) {
            // Top section: 2 players facing each other horizontally
            HStack(spacing: 20) { // Added spacing of 20
                // Left player (rotated 90° clockwise - facing right)
                ZStack {
                    playerRectangle(for: 0, size: CGSize(width: size.height * 0.66 - 20, height: size.width / 2 - 30))
                }
                .frame(width: size.width / 2 - 30, height: size.height * 0.66 - 20) // Adjusted width to account for spacing
                .rotationEffect(.degrees(90))
                
                // Right player (rotated 90° counter-clockwise - facing left)
                ZStack {
                    playerRectangle(for: 1, size: CGSize(width: size.height * 0.66 - 20, height: size.width / 2 - 30))
                }
                .frame(width: size.width / 2 - 30, height: size.height * 0.66 - 20) // Adjusted width to account for spacing
                .rotationEffect(.degrees(-90))
            }
            .frame(height: size.height * 0.66 - 20)
            
            // Bottom player (normal orientation)
            ZStack {
                playerRectangle(for: 2, size: CGSize(width: size.width - 40, height: size.height * 0.34 - 20))
            }
            .frame(width: size.width - 40, height: size.height * 0.34 - 20)
        }
        .frame(width: size.width, height: size.height)
    }
    
    // MARK: - 4 Player Layout (2v2 facing)
    
    private func fourPlayerLayout(in size: CGSize) -> some View {
        HStack(spacing: 20) {
            // Left side (2 players stacked)
            VStack(spacing: 20) {
                playerRectangle(for: 0, size: CGSize(width: size.width / 2 - 30, height: size.height / 2 - 30))
                    .rotationEffect(.degrees(180))
                
                playerRectangle(for: 2, size: CGSize(width: size.width / 2 - 30, height: size.height / 2 - 30))
                    .rotationEffect(.degrees(180))
            }
            
            // Right side (2 players stacked)
            VStack(spacing: 20) {
                playerRectangle(for: 1, size: CGSize(width: size.width / 2 - 30, height: size.height / 2 - 30))
                
                playerRectangle(for: 3, size: CGSize(width: size.width / 2 - 30, height: size.height / 2 - 30))
            }
        }
        .padding(20)
    }
    
    // MARK: - 5 Player Layout (2v2 facing + 1 left)
    
    private func fivePlayerLayout(in size: CGSize) -> some View {
        HStack(spacing: 20) {
            // Far left player (perpendicular)
            playerRectangle(for: 4, size: CGSize(width: size.width * 0.25 - 20, height: size.height - 40))
                .rotationEffect(.degrees(90))
            
            // Left side (2 players stacked)
            VStack(spacing: 20) {
                playerRectangle(for: 0, size: CGSize(width: size.width * 0.375 - 25, height: size.height / 2 - 30))
                    .rotationEffect(.degrees(180))
                
                playerRectangle(for: 2, size: CGSize(width: size.width * 0.375 - 25, height: size.height / 2 - 30))
                    .rotationEffect(.degrees(180))
            }
            
            // Right side (2 players stacked)
            VStack(spacing: 20) {
                playerRectangle(for: 1, size: CGSize(width: size.width * 0.375 - 25, height: size.height / 2 - 30))
                
                playerRectangle(for: 3, size: CGSize(width: size.width * 0.375 - 25, height: size.height / 2 - 30))
            }
        }
        .padding(20)
    }
    
    // MARK: - 6 Player Layout (2v2 facing + 2 on ends)
    
    private func sixPlayerLayout(in size: CGSize) -> some View {
        HStack(spacing: 20) {
            // Far left player (perpendicular)
            playerRectangle(for: 4, size: CGSize(width: size.width * 0.2 - 20, height: size.height - 40))
                .rotationEffect(.degrees(90))
            
            // Left side (2 players stacked)
            VStack(spacing: 20) {
                playerRectangle(for: 0, size: CGSize(width: size.width * 0.3 - 25, height: size.height / 2 - 30))
                    .rotationEffect(.degrees(180))
                
                playerRectangle(for: 2, size: CGSize(width: size.width * 0.3 - 25, height: size.height / 2 - 30))
                    .rotationEffect(.degrees(180))
            }
            
            // Right side (2 players stacked)
            VStack(spacing: 20) {
                playerRectangle(for: 1, size: CGSize(width: size.width * 0.3 - 25, height: size.height / 2 - 30))
                
                playerRectangle(for: 3, size: CGSize(width: size.width * 0.3 - 25, height: size.height / 2 - 30))
            }
            
            // Far right player (perpendicular)
            playerRectangle(for: 5, size: CGSize(width: size.width * 0.2 - 20, height: size.height - 40))
                .rotationEffect(.degrees(-90))
        }
        .padding(20)
    }
    
    // MARK: - Player Rectangle Helper
    
    private func playerRectangle(for index: Int, size: CGSize) -> some View {
        PlayerRectangleView(
            player: gameState.players[index],
            isActive: gameState.currentPlayerIndex == index,
            size: size,
            onTapTimer: {
                if gameState.currentPlayerIndex == index {
                    gameState.passToNextPlayer()
                } else {
                    gameState.activatePlayer(at: index)
                }
            },
            onTapUptime: { category in
                gameState.toggleUptime(category, for: index)
            },
            onEliminate: {
                gameState.eliminatePlayer(at: index)
            }
        )
    }
}

#Preview {
    let gameState = GameState(
        playerCount: 4,
        initialTime: 1200, // 20 minutes
        playerNames: ["Alice", "Bob", "Charlie", "Diana"],
        startingPlayerIndex: 0
    )
    gameState.startTimer()
    
    return GameView(gameState: gameState, onExit: {})
}
