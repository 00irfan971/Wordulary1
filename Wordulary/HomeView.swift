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
    
    var body: some View {
        
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

                                Text("35")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                    .shadow(color: .green, radius: 4)
                            }

                            VStack(spacing: 6) {
                                Text("Intermediate")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                    .shadow(color: .green, radius: 3)

                                Text("25")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                    .shadow(color: .green, radius: 4)
                            }

                            VStack(spacing: 6) {
                                Text("Advanced")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                    .shadow(color: .green, radius: 3)

                                Text("30")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                    .shadow(color: .green, radius: 4)
                            }
                        }
                    }
                }.padding(.bottom,60)

                
                
                Button(action: {play=1}, label: {
                    
                    Text("Play!").frame(width:190,height:100).background(Color("Col1")).foregroundStyle(Color.white).cornerRadius(10).font(.system(size: 30,weight: .bold)).shadow(radius: 10)
                })
            }
            
            
        }
        
    }
}

#Preview {
    HomeView(play: .constant(0))
}
