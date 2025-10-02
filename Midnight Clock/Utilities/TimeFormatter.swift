//
//  TimeFormatter.swift
//  Midnight Clock
//
//  Created by João Rato on 02/10/2025.
//
import Foundation

extension TimeInterval {
    func formattedTimer() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}
