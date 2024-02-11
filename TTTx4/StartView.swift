//
//  ContentView.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameService
    @State private var gameType: GameType = .undetermined
    @State private var yourName = ""
    @State private var oppName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    var body: some View {
        VStack {
            Image("LaunchScreen")
            .frame(width: 350)
            .padding(20)
            Picker("Select Game", selection: $gameType) {
                Text("Select Game Type").tag(GameType.undetermined)
                Text("Share Device").tag(GameType.single)
                Text("Challenge your device").tag(GameType.bot)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color("AccentColor") , lineWidth: 2))
            Text(gameType.description)
                .padding()
            VStack {
                switch gameType {
                case .single:
                    VStack {
                        TextField("Your Name", text: $yourName)
                        TextField("Opponent Name", text: $oppName)
                    }
                case .bot:
                    TextField("Your Name", text: $yourName)
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            Button("Start Game") {
                game.setupGame(gameType: gameType, p1Name: yourName, p2Name: oppName)
                focus = false
                startGame.toggle()
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                (gameType == .undetermined) ||
                (gameType == .bot && yourName.isEmpty) ||
                (gameType == .single && (yourName.isEmpty || oppName.isEmpty))
            )
            Spacer()
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .fullScreenCover(isPresented: $startGame) { GameView()
        }
    }
}

#Preview {
    StartView().environmentObject(GameService())
}
