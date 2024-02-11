//
//  GameSquare.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

struct GameSquare {
    var id: Int
    var player: Player?

    var image: Image {
        if let player = player {
            return player.gamePiece.image
        } else {
            return Image("none")
        }
    }
    
    static var reset: [GameSquare] {
        var squares = [GameSquare]()
        for index in 1...16 {
            squares.append(GameSquare(id: index))
        }
        return squares
    }
}
