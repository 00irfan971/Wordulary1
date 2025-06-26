//
//  HomeView.swift
//  Wordulary
//
//  Created by Irfan on 18/06/25.
//

import SwiftUI

struct HomeView: View {
    let word = "WORDULARY"
  
    @Binding var play:Int
    
    @State private var bscore: Int = 0
    @State private var iscore: Int = 0
    @State private var ascore: Int = 0
    
    @State private var path = NavigationPath()
    
    @State private var shouldRefreshScores = false
    
    var body: some View {
        
        NavigationStack(path:$path){
        
            ZStack{
                Color("Col2").ignoresSafeArea()
                
                VStack{
                    
                    HStack(spacing: 6) {
                        ForEach(Array(word), id: \.self) { letter in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.brown)
                                    .frame(width: 35, height: 35)
                                    .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                                
                                Text(String(letter))
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                            }
                        }
                    }
                    .padding(.bottom,20)
                    
                    
                    
                    ZStack {
                        // Neon green glowing background
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color.black, Color.green.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 340, height: 180)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.green, lineWidth: 1.5)
                                    .shadow(color: .green, radius: 10)
                            )
                            .shadow(color: .green.opacity(0.6), radius: 4, x: 0, y: 0)
                        
                        VStack(spacing: 16) {
                            Text("💥 SCORE BOARD 💥")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .shadow(color: .green, radius: 6)
                            
                            HStack(spacing: 30) {
                                VStack(spacing: 6) {
                                    Text("Beginner")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 3)
                                    
                                    Text("\(bscore)")
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                        .shadow(color: .green, radius: 4)
                                }
                                
                                VStack(spacing: 6) {
                                    Text("Intermediate")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 3)
                                    
                                    Text("\(iscore)")
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                        .shadow(color: .green, radius: 4)
                                }
                                
                                VStack(spacing: 6) {
                                    Text("Advanced")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 3)
                                    
                                    Text("\(ascore)")
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                        .shadow(color: .green, radius: 4)
                                }
                            }
                        }
                    }.padding(.bottom,60)
                    
                    
                    
                    NavigationLink(destination: PlayView(path: .constant(NavigationPath()),shouldRefresh: $shouldRefreshScores )) {
                        Text("Play!")
                            .font(.custom("PressStart2P-Regular", size: 26))
                            .foregroundColor(.blue)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 45)
                            .background(Color.black.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.9), radius: 6, x: 0, y: 0)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out", role: .destructive) {
                    Task {
                      try? await supabase.auth.signOut()
                    }
                  }.foregroundStyle(Color.red)
                }
              }
            
        }.onAppear{
            
            Task {
                if let scores = await fetchScoreFromSupabase() {
                    bscore = scores.bscore
                    iscore = scores.iscore
                    ascore = scores.ascore
                }
            }
            
        }.onChange(of: shouldRefreshScores) {
            if shouldRefreshScores {
                Task {
                    if let scores = await fetchScoreFromSupabase() {
                        bscore = scores.bscore
                        iscore = scores.iscore
                        ascore = scores.ascore
                    }
                    shouldRefreshScores = false
                }
            }
        }


        
    }
}

#Preview {
    HomeView(play: .constant(0))
}
