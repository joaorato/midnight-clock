// Views/SetupView.swift
import SwiftUI

struct SetupView: View {
    @State private var playerCount = 4
    @State private var initialMinutes = 20
    @State private var playerNames: [String] = ["", "", "", "", "", ""]
    @State private var startingPlayerIndex = 0
    
    let onStartGame: (GameState) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
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
                    
                    // Starting Time
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Starting Time (minutes)")
                            .foregroundColor(.gray)
                        
                        Picker("Time", selection: $initialMinutes) {
                            Text("10 min").tag(10)
                            Text("20 min").tag(20)
                            Text("30 min").tag(30)
                            Text("45 min").tag(45)
                            Text("60 min").tag(60)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Player Names
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Player Names (Optional)")
                                .foregroundColor(.gray)
                            
                            ForEach(0..<playerCount, id: \.self) { index in
                                TextField("Player \(index + 1)", text: $playerNames[index])
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    
                    // Starting Player
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Starting Player")
                            .foregroundColor(.gray)
                        
                        Picker("Starting Player", selection: $startingPlayerIndex) {
                            ForEach(0..<playerCount, id: \.self) { index in
                                Text(playerNames[index].isEmpty ? "Player \(index + 1)" : playerNames[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.white)
                    }
                    
                    Spacer()
                    
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
                .padding(40)
                .frame(maxWidth: 600)
            }
        }
        // REMOVED the rotation effect - it should be in landscape by default
    }
    
    private func startGame() {
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
