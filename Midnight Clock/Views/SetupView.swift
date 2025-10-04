// Views/SetupView.swift
import SwiftUI

struct SetupView: View {
    @State private var playerCount = 4
    @State private var initialMinutes = 15
    @State private var playerNames: [String] = ["", "", "", "", "", ""]
    @State private var startingPlayerIndex = 0
    @FocusState private var focusedField: Int?
    
    let onStartGame: (GameState) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Midnight Clock")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // Player Count
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Number of Players")
                                .foregroundColor(.gray)
                            
                            Picker("Players", selection: $playerCount) {
                                ForEach(2...6, id: \.self) { count in
                                    Text("\(count)").tag(count)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Starting Time with Quick Presets
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Starting Time")
                                .foregroundColor(.gray)
                            
                            // Quick preset buttons
                            HStack(spacing: 10) {
                                ForEach([5, 15, 30, 45, 60], id: \.self) { minutes in
                                    Button(action: {
                                        initialMinutes = minutes
                                    }) {
                                        Text("\(minutes)m")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(initialMinutes == minutes ? .black : .white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(initialMinutes == minutes ? Color.white : Color.gray.opacity(0.3))
                                            )
                                    }
                                }
                            }
                            
                            // Custom time stepper
                            HStack {
                                Text("Custom:")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                // Decrement button
                                Button(action: {
                                    if initialMinutes > 1 {
                                        initialMinutes -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                                
                                // Time display/input
                                Text("\(initialMinutes)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 60)
                                    .monospacedDigit()
                                
                                Text("min")
                                    .foregroundColor(.gray)
                                
                                // Increment button
                                Button(action: {
                                    if initialMinutes < 120 {
                                        initialMinutes += 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        
                        // Player Names
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Player Names (Optional)")
                                .foregroundColor(.gray)
                            
                            ForEach(0..<playerCount, id: \.self) { index in
                                TextField("Player \(index + 1)", text: $playerNames[index])
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        
                        // Starting Player
                        HStack {
                            Text("Starting Player:")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Picker("Starting Player", selection: $startingPlayerIndex) {
                                ForEach(0..<playerCount, id: \.self) { index in
                                    Text(playerNames[index].isEmpty ? "Player \(index + 1)" : playerNames[index])
                                        .tag(index)
                                }
                            }
                            .pickerStyle(.menu)
                            .accentColor(.white)
                        }
                        
                        // Start Game button
                        Button(action: startGame) {
                            Text("Start Game")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                    }
                    .frame(maxWidth: 600)
                    
                }
                .padding(40)
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }
    
    private func startGame() {
        // Dismiss keyboard before starting game
        focusedField = nil
        
        let initialTime = TimeInterval(initialMinutes * 60)
        let gameState = GameState(
            playerCount: playerCount,
            initialTime: initialTime,
            playerNames: Array(playerNames.prefix(playerCount)),
            startingPlayerIndex: startingPlayerIndex
        )
        gameState.startTimer()
        onStartGame(gameState)
    }
}

#Preview {
    SetupView(onStartGame: { _ in })
}
