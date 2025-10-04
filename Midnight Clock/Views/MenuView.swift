//
//  MenuView.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import SwiftUI

struct MenuView: View {
    @ObservedObject var gameState: GameState
    let onResume: () -> Void
    let onRestart: () -> Void
    let onNewGame: () -> Void
    
    @State private var showingRestartPicker = false
    @State private var selectedStartingPlayer = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Game Menu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Resume button
                Button(action: onResume) {
                    Text("Resume Game")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                }
                
                // Restart button (same setup, reselect starting player)
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
                
                // Settings placeholder
                Button(action: {}) {
                    Text("Settings (Coming Soon)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(15)
                }
                .disabled(true)
                
                Spacer()
            }
            .padding(40)
            .frame(maxWidth: 500)
            .alert("Select Starting Player", isPresented: $showingRestartPicker) {
                ForEach(gameState.players.indices, id: \.self) { index in
                    Button(gameState.players[index].name.isEmpty ? "Player \(index + 1)" : gameState.players[index].name) {
                        gameState.restart(startingPlayerIndex: index)
                        onResume()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Choose who goes first in the restarted game")
            }
        }
    }
}
