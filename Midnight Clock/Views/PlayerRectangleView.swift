//
//  PlayerRectangleView.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import SwiftUI

struct PlayerRectangleView: View {
    let player: Player
    let isActive: Bool
    let size: CGSize
    let onTapTimer: () -> Void
    let onTapUptime: (UptimeCategory) -> Void
    let onEliminate: () -> Void
    
    var body: some View {
        ZStack {
            // Background with highlight for active player
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(borderColor, lineWidth: isActive ? 6 : 2)
                )
            
            VStack(spacing: 15) {
                // Player name
                if !player.name.isEmpty {
                    Text(player.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(player.isEliminated ? 0.3 : 1.0))
                }
                
                // Timer display (tappable to pass turn)
                Button(action: onTapTimer) {
                    Text(displayTime)
                        .font(.system(size: timerFontSize, weight: .bold, design: .monospaced))
                        .foregroundColor(timerColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .disabled(player.isEliminated)
                
                // Uptime icons
                if !player.isEliminated {
                    HStack(spacing: 20) {
                        ForEach(UptimeCategory.allCases, id: \.self) { category in
                            Button(action: { onTapUptime(category) }) {
                                Image(systemName: category.iconName)
                                    .font(.title2)
                                    .foregroundColor(uptimeIconColor(for: category))
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(player.activeUptimeCategory == category ? Color.white.opacity(0.2) : Color.clear)
                                    )
                            }
                        }
                    }
                }
                
                // Eliminate button (skull icon)
                if !player.isEliminated && isActive {
                    Button(action: onEliminate) {
                        Image(systemName: "skull.fill")
                            .font(.title3)
                            .foregroundColor(.red.opacity(0.7))
                            .padding(8)
                    }
                }
            }
            .padding()
        }
        .frame(width: size.width, height: size.height)
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        if player.isEliminated {
            return Color.gray.opacity(0.3)
        }
        return Color(white: 0.15)
    }
    
    private var borderColor: Color {
        if player.isEliminated {
            return Color.gray.opacity(0.3)
        }
        if isActive {
            return .blue
        }
        return Color.gray.opacity(0.5)
    }
    
    private var timerColor: Color {
        if player.isEliminated {
            return .white.opacity(0.3)
        }
        if player.isLowTime {
            return .red
        }
        return .white
    }
    
    private var displayTime: String {
        if let activeCategory = player.activeUptimeCategory {
            // Show uptime for active category
            return player.uptimeFor(category: activeCategory).formattedTimer()
        } else {
            // Show countdown
            return max(0, player.countdownTime).formattedTimer()
        }
    }
    
    private var timerFontSize: CGFloat {
        // Scale font based on rectangle size
        let baseSize = min(size.width, size.height)
        return baseSize * 0.25
    }
    
    private func uptimeIconColor(for category: UptimeCategory) -> Color {
        if player.activeUptimeCategory == category {
            return .white
        }
        return .white.opacity(0.6)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        PlayerRectangleView(
            player: Player(name: "Test Player", initialTime: 1200, position: .top),
            isActive: true,
            size: CGSize(width: 400, height: 300),
            onTapTimer: {},
            onTapUptime: { _ in },
            onEliminate: {}
        )
    }
}
