//
//  GameModels.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

enum GameType {
    case single, bot, undetermined
    
    var description: String{
        switch self {
        case .single:
            return "Share your iPhone/iPad and play against a friend."
        case .bot:
            return "Play against this iPhone/iPad."
        case .undetermined:
            return ""
        }
    }
}

enum GamePiece: String {
    case x, o
    var image: Image {
        Image(self.rawValue)
    }
}

struct Player {
    let gamePiece: GamePiece
    var name: String
    var moves: [Int] = []
    var isCurrent = false
    var isWinner: Bool {
        for moves in Move.winningMoves {
            if moves.allSatisfy(self.moves.contains) {
                return true
            }
        }
        return false
    }
}

enum Move {
    static var all = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    static var winningMoves = [
        [1,2,3,4],
        [5,6,7,8],
        [9,10,11,12],
        [13,14,15,16],
        [1,5,9,13],
        [2,6,10,14],
        [13,7,11,15],
        [4,8,12,16],
        [1,6,11,16],
        [4,7,10,13],
    ]
}
