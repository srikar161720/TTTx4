//
//  TTTx4App.swift
//  TTTx4
//
//  Created by Srikar Pottabathula on 2/10/24.
//

import SwiftUI

@main
struct TTTx4App: App {
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            StartView().environmentObject(game)
        }
    }
}
