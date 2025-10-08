//
//  PomodoroPhase.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import Foundation

/// Represents the different phases of a Pomodoro session
enum PomodoroPhase: String, Codable, CaseIterable {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
    
    var systemImageName: String {
        switch self {
        case .focus:
            return "brain.head.profile"
        case .shortBreak:
            return "cup.and.saucer.fill"
        case .longBreak:
            return "bed.double.fill"
        }
    }
    
    var description: String {
        self.rawValue
    }
}
