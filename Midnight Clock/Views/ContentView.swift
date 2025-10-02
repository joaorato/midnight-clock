//
//  ContentView.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import SwiftUI

struct ContentView: View {
    @State private var showingGame = false
    @State private var gameState: GameState?
    
    var body: some View {
        Group {
            if let gameState = gameState, showingGame {
                GameView(gameState: gameState, onExit: {
                    showingGame = false
                    self.gameState = nil
                })
            } else {
                SetupView(onStartGame: { newGameState in
                    self.gameState = newGameState
                    self.showingGame = true
                })
            }
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    ContentView()
}
