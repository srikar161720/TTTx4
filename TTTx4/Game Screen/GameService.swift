//
//  GameService.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

@MainActor
class GameService: ObservableObject {
    @Published var p1 = Player(gamePiece: .x, name: "Player 1")
    @Published var p2 = Player(gamePiece: .o, name: "Player 2")
    @Published var possibleMoves = Move.all
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset
    @Published var isThinking = false
    
    var gameType = GameType.single
    
    var currentPlayer: Player {
        if p1.isCurrent {
            return p1
        } else {
            return p2
        }
    }
    
    var gameStarted: Bool {p1.isCurrent || p2.isCurrent}
    
    var boardDisabled: Bool {
        gameOver || !gameStarted || isThinking
    }
    
    func setupGame(gameType: GameType, p1Name: String, p2Name: String) {
        switch gameType {
        case .single:
            self.gameType = .single
            p2.name = p2Name
        case .bot:
            self.gameType = .bot
            p2.name = UIDevice.current.name
        case .undetermined:
            break
        }
        p1.name = p1Name
    }
    
    func reset() {
        p1.isCurrent = false
        p2.isCurrent = false
        p1.moves.removeAll()
        p2.moves.removeAll()
        gameOver = false
        possibleMoves = Move.all
        gameBoard = GameSquare.reset
    }
    
    func updateMoves(index: Int) {
        if p1.isCurrent {
            p1.moves.append(index + 1)
            gameBoard[index].player = p1
        } else {
            p2.moves.append(index + 1)
            gameBoard[index].player = p2
        }
    }
    
    func checkIfWinner() {
        if p1.isWinner || p2.isWinner {
            gameOver = true
        }
    }
    
    func toggleCurrent() {
        p1.isCurrent.toggle()
        p2.isCurrent.toggle()
    }
    
    func makeMove(at index: Int) {
        if gameBoard[index].player == nil {
            withAnimation {
                updateMoves(index: index)
            }
            checkIfWinner()
            if !gameOver {
                if let matchingIndex = possibleMoves.firstIndex(where: {$0 == (index + 1)}) {
                    possibleMoves.remove(at: matchingIndex)
                }
                toggleCurrent()
                if gameType == .bot && currentPlayer.name == p2.name {
                    Task {
                        await deviceMove()
                    }
                }
            }
            if possibleMoves.isEmpty {
                gameOver = true
            }
        }
    }
    
    func deviceMove() async {
        isThinking.toggle()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let move = possibleMoves.randomElement() {
            if let matchingIndex = Move.all.firstIndex(where: {$0 == move}) {
                makeMove(at: matchingIndex)
            }
        }
        isThinking.toggle()
    }
}
