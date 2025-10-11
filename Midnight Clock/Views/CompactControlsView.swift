//
//  CompactControlsView.swift
//  Midnight Clock
//
//  Created by João Rato on 11/10/2025.
//
import SwiftUI

struct CompactControlsView: View {
    @ObservedObject var gameState: GameState
    let onMenuTap: () -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            // Expanded buttons
            if isExpanded {
                HStack(spacing: 15) { // Increased spacing from 15 to 25
                    // Menu button
                    controlButton(
                        icon: "line.3.horizontal",
                        color: .gray,
                        action: {
                            isExpanded = false
                            onMenuTap()
                        }
                    )
                    
                    // Pause button
                    controlButton(
                        icon: gameState.isPaused ? "play.fill" : "pause.fill",
                        color: .gray,
                        action: { gameState.togglePause() }
                    )
                    
                    // Spacer for center button
                    Spacer()
                        .frame(width: 80) // Space for the center X button
                    
                    // Politics button
                    controlButton(
                        icon: GlobalUptimeCategory.politics.iconName,
                        color: gameState.activeGlobalCategory == .politics ? .purple : .gray,
                        action: { gameState.toggleGlobalUptime(.politics) }
                    )
                    
                    // Rules button
                    controlButton(
                        icon: GlobalUptimeCategory.rules.iconName,
                        color: gameState.activeGlobalCategory == .rules ? .cyan : .gray,
                        action: { gameState.toggleGlobalUptime(.rules) }
                    )
                }
                .padding(.horizontal, 20) // Horizontal padding
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.8))
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
            
            // Main toggle button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "xmark.circle.fill" : "ellipsis.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.7))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    )
            }
            .zIndex(2)
        }
    }
    
    private func controlButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color.opacity(0.8))
                )
        }
    }
}
