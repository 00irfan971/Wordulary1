//
//  PlayView.swift
//  Wordulary
//
//  Created by Irfan on 19/06/25.
//

import SwiftUI

struct PlayView: View {
    
    @State var x: Int = 0
    
    @Binding var path: NavigationPath
    
    @Binding var shouldRefresh: Bool
    
    var body: some View {

            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.black, Color("Col2")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    Text("🎮 SELECT YOUR LEVEL")
                        .font(.custom("PressStart2P-Regular", size: 18))
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan.opacity(0.9), radius: 10, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                        .padding(.top, 140)

                    // Beginner
                    NavigationLink(destination: BPlay(path: $path)) {
                        Text("BEGINNER")
                            .font(.custom("PressStart2P-Regular", size: 16))
                            .foregroundColor(.green)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 50)
                            .background(Color.black.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green, lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .shadow(color: .green.opacity(0.8), radius: 6, x: 0, y: 0)
                    }

                    // Intermediate (placeholder, inactive)
                    NavigationLink(destination: IPlay(path: $path)) {
                        Text("INTERMEDIATE")
                            .font(.custom("PressStart2P-Regular", size: 16))
                            .foregroundColor(.yellow)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 50)
                            .background(Color.black.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .shadow(color: .green.opacity(0.8), radius: 6, x: 0, y: 0)
                    }

                    // Advanced
                    NavigationLink(destination: APlay(path: $path)) {
                        Text("ADVANCED")
                            .font(.custom("PressStart2P-Regular", size: 16))
                            .foregroundColor(.red)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 45)
                            .background(Color.black.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                            .cornerRadius(12)
                            .shadow(color: .red.opacity(0.9), radius: 6, x: 0, y: 0)
                    }
                    
                    Spacer()
                }
                .padding()
            }.onDisappear {

                shouldRefresh = true
            }
    }
}


#Preview {
    PlayView(path: .constant(NavigationPath()),shouldRefresh: .constant(false))
}

