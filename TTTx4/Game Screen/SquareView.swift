//
//  SquareView.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game: GameService
    let index: Int
    var body: some View {
        Button {
            if !game.isThinking {
                game.makeMove(at: index)
            }
        } label: {
            game.gameBoard[index].image.resizable().frame(width: 65, height: 65)
        }
        .disabled(game.gameBoard[index].player != nil)
    }
}

#Preview {
    SquareView(index: 1).environmentObject(GameService())
}
