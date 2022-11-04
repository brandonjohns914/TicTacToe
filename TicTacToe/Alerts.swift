//
//  Alerts.swift
//  TicTacToe
//
//  Created by Brandon Johns on 10/31/22.
//

import SwiftUI

struct AlertItem: Identifiable
{
    let id = UUID()
    
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext
{
    static let humanWin = AlertItem(title: Text("You Win"), message: Text("Winner"), buttonTitle: Text("Hell Yeah"))
    
    static let computerWin = AlertItem(title: Text("You Lost"), message: Text("Loser"), buttonTitle: Text("Hell Naw"))
    
    static let draw = AlertItem(title: Text("You Tie"), message: Text("Tie"), buttonTitle: Text("Try again"))
}
