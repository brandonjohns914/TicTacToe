//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Brandon Johns on 11/3/22.
//https://www.youtube.com/watch?v=MCLiPW2ns2w&list=PL8seg1JPkqgHyWCBHwXGmfysQpEQTfC3z&index=7 

import SwiftUI

final class GameViewModel: ObservableObject
{
    let columns: [GridItem] = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    func processPlayerMove(for position: Int)
    {
        if isSquareOccupied(in: moves, forIndex: position) {
            return
        }
        moves[position] = Move(player: .human , boardIndex: position)
        
        //check for win condition or draw
        if checkWinCondition(for: .human, in: moves)
        {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves)
        {
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer , boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves)
            {
                alertItem = AlertContext.computerWin
                return
            }
        }
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int)-> Bool{
        return moves.contains(where:{$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int
    {
        // if AI can win then win
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5] ,[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap{$0}.filter {$0.player == .computer}
        let computerPosition = Set(computerMoves.map({$0.boardIndex}))

        for pattern in winPatterns
        {
            let winPositions = pattern.subtracting(computerPosition)
            if winPositions.count == 1
            {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable{
                    return winPositions.first!
                }
            }
        }
        // AI cant win then block
        let humanMoves = moves.compactMap{$0}.filter {$0.player == .human}
        let humanPosition = Set(humanMoves.map({$0.boardIndex}))

        for pattern in winPatterns
        {
            let winPositions = pattern.subtracting(humanPosition)
            if winPositions.count == 1
            {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable{
                    return winPositions.first!
                }
            }
        }
        
        
        // AI cant block take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare)
        {return centerSquare}
        
        
        // AI cant take middle square take random square
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition)
        {
             movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?])-> Bool
    {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        
        let playerMoves = moves.compactMap{$0}.filter {$0.player == player}
        let playerPosition = Set(playerMoves.map({$0.boardIndex}))
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {
            return true
        }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?])-> Bool
    {
        return moves.compactMap{$0}.count == 9
    }
    
    func resetGame()
    {
        moves = Array(repeating: nil, count: 9)
    }
    enum Player
    {
        case human, computer
        
    }

    struct Move
    {
        let player: Player
        let boardIndex: Int
        
        var indicator: String {
            return player == .human ? "xmark": "circle"
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            GameView()
        }
    }

    struct GameBoardView: View {
        
        var proxy: GeometryProxy
        var body: some View {
            Circle()
                .foregroundColor(.red).opacity(0.5)
                .frame(width: proxy.size.width/3 - 15, height: proxy.size.height/3 - 160)
        }
    }

    struct PlayerIndicatorView: View {
        
        var systemImageName: String
        
        var body: some View {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
}
