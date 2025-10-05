# ⏱️ Midnight Clock: An MTG Commander Timer

A sleek, multiplayer timer app for Magic: The Gathering Commander games, designed to track individual player time while also monitoring non-gameplay activities.

## ✨ Features

### ⏲️ Individual Player Timers
- Countdown timers for each player (chess clock style)
- Players are eliminated when their time runs out
- Low time warning at ≤10% remaining
- Support for 2-6 players

### 📊 Uptime Tracking
Track time spent on non-gameplay activities:
- 💬 **Politics** - Negotiations and table talk
- 🔍 **Search** - Library and graveyard searches
- 📖 **Rules** - Rules discussions and judge calls
- 🔀 **Shuffling** - Deck shuffling

### 🎮 Smart Game Management
- Dynamic table layouts matching physical seating
- Tap to switch active player
- Pause/resume functionality
- Player elimination tracking
- In-game menu with restart option

### 📈 Post-Game Statistics
- Individual player breakdowns
- Time usage analysis
- Aggregate statistics across all players
- Winner declaration with time remaining

## 🎯 How to Use

### Setup
1. Select number of players (2-6)
2. Set starting time per player (quick presets or custom)
3. Enter player names (optional)
4. Choose starting player
5. Tap **Start Game**

### During Game
- **Tap active player's timer** → Pass turn to next player clockwise
- **Tap any inactive player** → Activate that player (for responses)
- **Tap uptime icons** → Track non-gameplay activities
- **Tap pause button** → Pause all timers
- **Tap menu** → Access restart/new game options
- **Tap eliminate (X)** → Remove player from game

### After Game
- View detailed statistics for each player
- See aggregate time spent on each activity
- Choose to restart with same setup (choosing the starting player) or start new game

## 🎨 Interface

### Player Layouts
- **2 Players**: Vertical split (top vs bottom)
- **3 Players**: 2 facing horizontally + 1 at bottom
- **4 Players**: 2v2 facing (left vs right)
- **5 Players**: 2v2 + 1 at bottom
- **6 Players**: 3v3 facing (left vs right)

All layouts are optimized for landscape orientation and mimic physical table seating.

## 🛠️ Technical Details

- **Platform**: iOS
- **Framework**: SwiftUI
- **Minimum iOS**: 17.0
- **Screen**: Stays awake during active games

## 📱 Requirements

- iOS 17.0 or later
- iPhone or iPad
- Landscape orientation support
