//
//  ContentView.swift
//  d4_xo_game
//
//  Created by Shaimaa on 5/8/20.
//  Copyright © 2020 Shaimaa. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct field {
    var player : String
    var enabled : Bool
}

struct XOGame: View {
    //  @State var fields: [[field]] = .init(repeating: .init(repeating: field(player: "", enabled: true), count: 3), count:3)
    @State var fieldsEasyWay: [[field]] = [[field(player: "", enabled: true),field(player: "", enabled: true),field(player: "", enabled: true)],
                                           [field(player: "", enabled: true),field(player: "", enabled: true),field(player: "", enabled: true)],
                                           [field(player: "", enabled: true),field(player: "", enabled: true),field(player: "", enabled: true)]]
    @State var playerTurn : String = "X"
    @State var changingColorArray = [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.6641962757)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))] // for palayer:x&y&winner
    @State var changingColor = Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) // in the beginning, then will be template
    @State var changingColorBorder = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) // after changing the backgroung from white to other color
    @State var colorCounter = 0
    @State var winner = ""
    @State var winStatus = false
    @State var drawCounter = 0
    @State var colorPlayerTurnOff = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    @State var soundP : AVAudioPlayer!
    var body: some View {
        ZStack{
           
            Group{
                changingColor.opacity(0.5)
                .background(
                Image("spaace")
                    .resizable()
                    .scaledToFill()
                )
            }.edgesIgnoringSafeArea(.all)
            Button(action: {
                let url = Bundle.main.path(forResource: "rain-03", ofType: "mp3")
                self.soundP = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                self.soundP.play()
            }) {
               // Image(systemName: "play.rectangle")
                Image(systemName: "play.circle")
                    .font(.system(size: 40.0, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            }.offset(x: -150, y: -270)
            Button(action: {
                    self.soundP.stop()
            }) {
                Image(systemName: "stop.circle")
                    .font(.system(size: 40.0, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            }.offset(x: -100, y: -270)
            VStack{
                Text(winner)
                    .font(.system(size: 70))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .offset(y: -20)
                if self.winStatus == false {
                Text("\(playerTurn) Turn")
                    .font(.system(size: 40))
                    .foregroundColor(colorPlayerTurnOff)
                    .offset(y: -40)
                }
                VStack(spacing: 10){
                    ForEach(0 ..< 3) { r in
                        HStack(spacing: 10){
                            ForEach(0 ..< 3) { c in
                                Button(action: {
                                    if self.fieldsEasyWay[r][c].enabled{
                                        self.fieldsEasyWay[r][c].player = self.playerTurn
                                        self.changingColor = self.changingColorArray[self.colorCounter]
//                                        self.colorCounter += 1
                                        self.drawCounter += 1
                                        self.checkWinner()
                                        if self.winStatus == false {
                                            self.playerTurn = self.playerTurn == "X" ? "O" : "X"
                                            self.changingColor = self.playerTurn == "X" ? self.changingColorArray[0] : self.changingColorArray[1]
                                            self.changingColorBorder = Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                                            self.fieldsEasyWay[r][c].enabled = false
                                        }
                                        else {
                                            self.colorPlayerTurnOff = self.changingColorArray[2]
                                            self.changingColor = self.changingColorArray[2]
                                            self.fieldsEasyWay[0][0].enabled = false
                                            self.fieldsEasyWay[0][1].enabled = false
                                            self.fieldsEasyWay[0][2].enabled = false
                                            self.fieldsEasyWay[1][0].enabled = false
                                            self.fieldsEasyWay[1][1].enabled = false
                                            self.fieldsEasyWay[1][2].enabled = false
                                            self.fieldsEasyWay[2][0].enabled = false
                                            self.fieldsEasyWay[2][1].enabled = false
                                            self.fieldsEasyWay[2][2].enabled = false
                                            
                                        }
                                    }
                                }) {
                                    Text(self.fieldsEasyWay[r][c].player)
                                        .font(.system(size: 60))
                                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                        .frame(width: 90, height: 90, alignment: .center)
                                        .border(self.changingColorBorder, width: 5)
                                        .background(Color.white)
                                    
                                }
                            }
                        }
                    }
                }
                if self.winner != "" {
                    Button(action: {
                        self.restartG()
                        
                    }) {
                        Text("Restart")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .frame(width: 180, height: 40, alignment: .center)
                            .background(Color.white)
                    }.offset(y: 40)
                }
            }
            
        }
    }
    func checkWinner (){
        let r1 = fieldsEasyWay[0][0].player == self.playerTurn && fieldsEasyWay[0][1].player == self.playerTurn && fieldsEasyWay[0][2].player == self.playerTurn
        let r2 = fieldsEasyWay[1][0].player == self.playerTurn && fieldsEasyWay[1][1].player == self.playerTurn && fieldsEasyWay[1][2].player == self.playerTurn
        let r3 = fieldsEasyWay[2][0].player == self.playerTurn && fieldsEasyWay[2][1].player == self.playerTurn && fieldsEasyWay[2][2].player == self.playerTurn
        let c1 = fieldsEasyWay[0][0].player == self.playerTurn && fieldsEasyWay[1][0].player == self.playerTurn && fieldsEasyWay[2][0].player == self.playerTurn
        let c2 = fieldsEasyWay[0][1].player == self.playerTurn && fieldsEasyWay[1][1].player == self.playerTurn && fieldsEasyWay[2][1].player == self.playerTurn
        let c3 = fieldsEasyWay[0][2].player == self.playerTurn && fieldsEasyWay[1][2].player == self.playerTurn && fieldsEasyWay[2][2].player == self.playerTurn
        let d1 = fieldsEasyWay[0][0].player == self.playerTurn && fieldsEasyWay[1][1].player == self.playerTurn && fieldsEasyWay[2][2].player == self.playerTurn
        let d2 = fieldsEasyWay[0][2].player == self.playerTurn && fieldsEasyWay[1][1].player == self.playerTurn && fieldsEasyWay[2][0].player == self.playerTurn
        
        if r1 || r2 || r3 || c1 || c2 || c3 || d1 || d2 {
            self.winner = ("\(self.playerTurn) win")
            self.winStatus = true
        }
        else if drawCounter == 9{
            self.winner = "Draw"
            self.winStatus = true
        }
    }
    
    func restartG() {
        fieldsEasyWay = [[field(player: "", enabled: true),field(player: "", enabled: true),field(player: "", enabled: true)],
                         [field(player: "", enabled: true),field(player: "", enabled: true),field(player: "", enabled: true)],
                         [field(player: "", enabled: true),field(player: "", enabled: true),field(player: "", enabled: true)]]
        self.playerTurn = "X"
        self.winner = ""
        self.winStatus = false
        self.drawCounter = 0
        self.colorPlayerTurnOff = Color.white
        self.changingColor = Color.white
         self.changingColorBorder = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        XOGame()
    }
}
