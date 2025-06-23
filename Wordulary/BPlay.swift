//
//  BPlay.swift
//  Wordulary
//
//  Created by Irfan on 18/06/25.
//

import SwiftUI
import UIKit
import PostgREST

struct BPlay: View {
    
    @State private var items: [SentenceItem] = []
    @State private var currentIndex = 0

    @State private var dragOffset: CGSize = .zero
    @State private var selection: String? = nil
    
    @State private var bscore: Int = 0
    @State private var iscore: Int = 0
    @State private var ascore: Int = 0
    
    @State private var flicker = true
    
    @Binding var path: NavigationPath
    
    @State private var sentenceBackground: Color = Color.white

    
    var body: some View {
        ZStack {
            if currentIndex < items.count {
                let item = items[currentIndex]
                
                

                Color("Col2").ignoresSafeArea()

                VStack {
                    
                    HStack {
                                        Text("SCORE")
                                            .font(.custom("PressStart2P-Regular", size: 17))
                                            .foregroundColor(.green)
                                            .padding(.leading, 8)

                                        Text("\(bscore)")
                                            .font(.custom("PressStart2P-Regular", size: 22))
                                            .foregroundColor(.green)
                                            .shadow(color: .green.opacity(0.8), radius: 5, x: 0, y: 0)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.black.opacity(0.8))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.green, lineWidth: 2)
                                            )
                                            .cornerRadius(8)

                                        Spacer()
                        
                        Text("BEGINNER")
                            .font(.custom("PressStart2P-Regular", size: 16))
                            .foregroundColor(.cyan)
                            .opacity(flicker ? 1 : 0.85)
                            .shadow(color: .cyan.opacity(0.9), radius: 8, x: 0, y: 0)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                            .cornerRadius(10)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                                    flicker.toggle()
                                }
                            }
                        
                    }.padding(25)
                    

                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(sentenceBackground)
                            .frame(width: 320, height: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.purple, lineWidth: 4)
                            )

                        Text(item.sentence).foregroundStyle(Color.black)
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                    }
                    .padding(.top, 60)

                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color("Col3").opacity(0.9))
                            .frame(width: 200, height: 100)
                            .cornerRadius(20)

                        Text(item.option1)
                            .foregroundStyle(Color("Col1"))
                            .font(.system(size: 65, weight: .bold, design: .rounded))
                        
                        
                        
                    }
                    .padding(.top, 100)
                    .offset(x: dragOffset.width)
                    .rotationEffect(.degrees(Double(dragOffset.width / 10)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                dragOffset = gesture.translation
                            }
                            .onEnded { _ in
                                if dragOffset.width > 100 {
                                    selection = "correct"
                                    print("✅ Selected as correct")
                                    
                                    if item.correctOption == "1"{
                                        bscore=bscore+10
                                        
                                        sentenceBackground=Color.green
                                    }
                                    else{
                                        sentenceBackground=Color.red
                                        triggerHapticFeedback(success: false)
                                    }
                                } else if dragOffset.width < -100 {
                                    selection = "wrong"
                                    print("❌ Selected as wrong")
                                    
                                    if item.correctOption == "2"{
                                        bscore=bscore+10
                                        sentenceBackground=Color.green
                                    }
                                    else{
                                        sentenceBackground=Color.red
                                        triggerHapticFeedback(success: false)
                                    }
                                }

                                withAnimation {
                                    dragOffset = .zero
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            sentenceBackground = Color.white
                                            
                                            selection = nil
                                            currentIndex += 1
                                        }
                                    }
                            }
                    )
                    .animation(.spring(), value: dragOffset)
                    
                    HStack{
                        
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 60))
                        
                        Spacer()
                
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 60))

        
                        
                       
                    }.padding(20)

                    Spacer()
                    
                    
                    
                }
            } else {
                VStack {
                    Text("🎉 All items shown")
                        .font(.title)
                        .padding()
                }
            }
        }
        .onAppear {
            items = loadCSV(from: "sentences")
            print("Loaded \(items.count) items")
            
            
            Task {
                await fetchScoreFromSupabase()
            }
            
            
            
        }.onChange(of: bscore) {
            Task {
                await saveOrUpdateScore(bscore)
            }
        }

    }
    
    func saveOrUpdateScore(_ bscore: Int) async {
        guard let user = try? await supabase.auth.session.user else {
            print("❌ User not logged in")
            return
        }

        let payload = ScoreRow(
            user_id: user.id,
            bscore: bscore,
            iscore: 0,
            ascore:0,
            updated_at: ISO8601DateFormatter().string(from: Date())
        )

        do {
            try await supabase
                .from("scores")
                .upsert(payload)
                .execute()

            print("✅ Score saved or updated")
        } catch {
            print("❌ Error saving score: \(error)")
        }
    }
    
    
    
    

    func fetchScoreFromSupabase() async {
        guard let userId = try? await supabase.auth.session.user.id else {
            print("User not logged in")
            return
        }

        do {
            let response: PostgrestResponse<ScoreRow> = try await supabase
                .from("scores")
                .select()
                .eq("user_id", value: userId)
                .limit(1)
                .single()
                .execute()

            let scoreRow = response.value

            // Update state
            bscore = scoreRow.bscore
            iscore = scoreRow.iscore
            ascore = scoreRow.ascore

            print("✅ Scores loaded from Supabase")

        } catch {
            print("❌ Failed to load scores: \(error)")
        }
    }
    
    func triggerHapticFeedback(success: Bool) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(success ? .success : .error)
    }




    
}

#Preview {
    BPlay(path: .constant(NavigationPath()))
}
