//
//  GameView.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Image("LaunchScreen")
            .frame(width: 350)
            .padding(20)
            if [game.p1.isCurrent, game.p2.isCurrent].allSatisfy{$0 == false} {
                Text("Select a player to start")
            } else {
                Text("   ")
            }
            HStack {
                Button(game.p1.name) {
                    game.p1.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.p1.isCurrent))
                Button(game.p2.name) {
                    game.p2.isCurrent = true
                    if game.gameType == .bot {
                        Task {
                            await game.deviceMove()
                        }
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.p2.isCurrent))
            }
            .disabled(game.gameStarted)
            Spacer()
            VStack (spacing: 8) {
                HStack {
                    ForEach(0...3, id: \.self) {index in
                        SquareView(index: index)
                    }
                }
                VStack {
                    if game.gameOver {
                        Text("Game Over").font(.largeTitle)
                        if game.possibleMoves.isEmpty {
                            Text("Nobody wins").font(.largeTitle)
                        } else {
                            Text("\(game.currentPlayer.name) wins!").font(.largeTitle)
                        }
                    } else {
                        HStack {
                            ForEach(4...7, id: \.self) {index in
                                SquareView(index: index)
                            }
                        }
                        HStack {
                            ForEach(8...11, id: \.self) {index in
                                SquareView(index: index)
                            }
                        }
                    }
                } .frame(maxHeight: 138)
                HStack {
                    ForEach(12...15, id: \.self) {index in
                        SquareView(index: index)
                    }
                }
            }
            .overlay {
                if game.isThinking {
                    VStack {
                        Text("Thinking...")
                        ProgressView().tint(Color("BackgroundColor"))
                        Image(systemName: "brain.filled.head.profile").foregroundColor(Color("BackgroundColor")).padding().scaleEffect(1.5)
                    }
                    .padding(10)
                    .bold()
                    .foregroundColor(Color("BackgroundColor"))
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("ThinkingColor").opacity(0.90)))
                }
            }
            .disabled(game.boardDisabled)
            HStack {
                if game.gameOver {
                    Button("New Game") {
                        game.reset()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                Button("End Game") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.bordered)
            }
            Spacer()
        }
        .onAppear {game.reset()}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}

#Preview {
    GameView().environmentObject(GameService())
}

struct PlayerButtonStyle: ButtonStyle {
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(isCurrent ? Color.green : Color.gray))
            .foregroundColor(.white)
    }
}
