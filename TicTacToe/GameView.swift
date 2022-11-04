//
//  GameView.swift
//  TicTacToe
//
//  Created by Brandon Johns on 10/27/22.
//

import SwiftUI


struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns , spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameViewModel.GameBoardView(proxy: geometry)
                            
                            GameViewModel.PlayerIndicatorView(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: {alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: viewModel.resetGame))
                
            })
        }
    }
    

}





