//
//  GlobalControlsView.swift
//  Midnight Clock
//
//  Created by João Rato on 09/10/2025.
//
import SwiftUI

struct GlobalControlsView: View {
    @ObservedObject var gameState: GameState
    let onMenuTap: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Menu button
            Button(action: onMenuTap) {
                Image(systemName: "line.3.horizontal")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.7))
                    )
            }
            
            // Pause button
            Button(action: { gameState.togglePause() }) {
                Image(systemName: gameState.isPaused ? "play.fill" : "pause.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.7))
                    )
            }
            
            // Politics button
            Button(action: { gameState.toggleGlobalUptime(.politics) }) {
                Image(systemName: GlobalUptimeCategory.politics.iconName)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(gameState.activeGlobalCategory == .politics ? Color.purple.opacity(0.8) : Color.gray.opacity(0.7))
                    )
            }
            
            // Rules button
            Button(action: { gameState.toggleGlobalUptime(.rules) }) {
                Image(systemName: GlobalUptimeCategory.rules.iconName)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(gameState.activeGlobalCategory == .rules ? Color.cyan.opacity(0.8) : Color.gray.opacity(0.7))
                    )
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
        )
    }
}
