//
//  ContentView.swift
//  Slot Machine
//
//  Created by Sergei on 21.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    let defaults = Foundation.UserDefaults.standard
    
    @State private var highscore: Int = Foundation.UserDefaults.standard.integer(forKey: "HighScore")
    
    @State private var coins: Int = 100
    
    @State private var betAmount: Int = 10
    
    @State private var reels: Array = [0, 1 , 2]
    
    @State private var showingInfoView: Bool = false
    
    @State private var isActiveBet10: Bool = true
    
    @State private var isActiveBet20: Bool = false
    
    @State private var showingModal: Bool = false
    
    @State private var animatingSymbol: Bool = false
    
    @State private var animatingModal: Bool = false
      
    //MARK: - FUNCTION
    
    func spinReels(){
        reels[0] = Int.random(in: 0...symbols.count - 1)
        reels[1] = Int.random(in: 0...symbols.count - 1)
        reels[2] = Int.random(in: 0...symbols.count - 1)
        
        playSound(sound: "spin", type: "mp3")
    }
    
    func checkWin(){
        if(reels[0]) == reels[1] && reels[1] == reels[2] && reels[0] == reels[2]
        {
            self.playerWins()
            if coins > highscore{
                newHighScore()
            }else{
                playSound(sound: "win", type: "mp3")
            }
        }else{
            self.playerLoses()
        }
     }
    
    func playerWins(){
        coins += betAmount * 10
        
    }
    
    func newHighScore(){
        highscore = coins
        defaults.set(highscore, forKey: "HighScore")
        playSound(sound: "hight-score", type: "mp3")
    }
    
    func playerLoses(){
        coins -= betAmount
  
    }
    
    func activateBet20(){
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func activateBet10(){
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func isGameOver(){
        if coins <= 0{
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
    }
    
    var body: some View {
        ZStack {
            
            //Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            
            VStack(alignment: .center, spacing: 5) {
  
                LogoView()
                Spacer()
                
                //Score
                HStack {
                    HStack{
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack{
                        
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("Hight\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
 
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                VStack(alignment: .center, spacing: 0){
                    
                    //Reel 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .offset(y: animatingSymbol ? 0 : -50)
                            .opacity(animatingSymbol ? 1 : 0)
                            .animation(.easeOut(duration:  Double.random(in: 0.5...0.7)))
                            .onAppear(perform:{
                                self.animatingSymbol.toggle()
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0){
                        
                        //Reel 2
                        ZStack {
                        ReelView()
                        Image(symbols[reels[1]])
                            .resizable()
                            .modifier(ImageModifier())
                            .offset(y: animatingSymbol ? 0 : -50)
                            .opacity(animatingSymbol ? 1 : 0)
                            .animation(.easeOut(duration:  Double.random(in: 0.5...0.7)))
                            .onAppear(perform:{
                                self.animatingSymbol.toggle()
                            })
                        }
                        
                        //Reel 3
                        ZStack {
                            
                            ReelView()
                        Image(symbols[reels[2]])
                            .resizable()
                            .modifier(ImageModifier())
                            .offset(y: animatingSymbol ? 0 : -50)
                            .opacity(animatingSymbol ? 1 : 0)
                            .animation(.easeOut(duration:  Double.random(in: 0.5...0.7)))
                            .onAppear(perform:{
                                self.animatingSymbol.toggle()
                            })
                            
                        }
                    }
                    
                    Button(action:{
                        
                        withAnimation{
                            self.animatingSymbol = false
                        }
                        self.spinReels()
                        
                        withAnimation{
                            self.animatingSymbol = true
                        }
                        
                        self.checkWin()
                        self.isGameOver()
                    }){
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                }
                .layoutPriority(2)
                
                Spacer()
                
                HStack{
                   
                    HStack {
                         
                        Button(action: {
                            self.activateBet20()
                        }){
                             Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    HStack {
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.activateBet10()
                        }){
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
                
            }
            .overlay(
            Button(action:{
                self.resetGame()
            }){
                Image(systemName:"arrow.2.circlepath.circle")
            }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            
            .overlay(
            Button(action:{
                self.showingInfoView = true
            }){
                Image(systemName:"info.circle")
            }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            if $showingModal.wrappedValue{
                ZStack{
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0){
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16){
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.coins = 100
                            }){
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                     Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundColor(Color("ColorPink"))
                                    )
                                    .padding(.bottom, 20)
                                
                            }
                            
                        }
                        
                    }.frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                }
            }
        }//ZStack
        .sheet(isPresented: $showingInfoView){
            InfoView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
