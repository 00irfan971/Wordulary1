//
//  IPlay.swift
//  Wordulary
//
//  Created by Irfan on 23/06/25.
//


import SwiftUI
import UIKit


struct IPlay: View {
    
    @State private var supData: [SupData] = []
    @State private var items: [SentenceItem] = []
    @State private var currentIndex = 0

    @State private var dragOffset: CGSize = .zero
    @State private var selection: String? = nil
    
    @State private var bscore: Int = 0
    @State private var iscore: Int = 0
    @State private var ascore: Int = 0
    
    @State private var bindex: Int = 0
    @State private var iindex: Int = 0
    @State private var aindex: Int = 0
    
    
    @State private var flicker = true
    
    @Binding var path: NavigationPath
    
    @State private var sentenceBackground: Color = Color.white

    
    
    var body: some View {
        ZStack {
            if iindex < supData.count {
                let item = supData[iindex]
                
                

                Color("Col2").ignoresSafeArea()

                VStack {
                    
                    HStack {
                                        Text("SCORE")
                                            .font(.custom("PressStart2P-Regular", size: 17))
                                            .foregroundColor(.green)
                                            .padding(.leading, 8)

                                        Text("\(iscore)")
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
                        
                        Text("ADVANCED")
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
                        Text(item.sentence)
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(sentenceBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.purple, lineWidth: 4)
                                    )
                            )
                            .padding(.top, 60)

                    }
                    .padding(.top, 60)

                    ZStack {
                        Text(item.word1)
                            .foregroundStyle(Color("Col1"))
                            .font(.system(size: 65, weight: .bold, design: .rounded))
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("Col3").opacity(0.9))
                            )

                        
                        
                        
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
                                
                                var validSwipe = false
                                if dragOffset.width > 100 {
                                    
                                    handleSelection(isCorrect: true)
                                    
                                    
                                    validSwipe = true
                                } else if dragOffset.width < -100 {
                                    
                                    
                                    handleSelection(isCorrect: false)
                                    
                                    validSwipe = true
                                }
                                withAnimation{
                                    dragOffset = .zero
                                }

                                if validSwipe{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            withAnimation {
                                                sentenceBackground = Color.white
                                                
                                                selection = nil
                                                iindex += 1
                                            }
                                        }
                                }
                            }
                    )
                    .animation(.spring(), value: dragOffset)
                    
                    HStack{
                        
                        
                        Button(action:{
                            handleSelection(isCorrect: false)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        sentenceBackground = Color.white
                                        
                                        selection = nil
                                        iindex += 1
                                    }
                                }
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 60))
                        }
                        
                        Spacer()
                
                        Button(action:{
                            handleSelection(isCorrect: true)
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        sentenceBackground = Color.white
                                        
                                        selection = nil
                                        iindex += 1
                                    }
                                }
                            
                            
                        }){
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 60))
                        }

        
                        
                       
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
            //items = loadCSV3(from: "sentences")
            
            
            
            Task {
                
                await loadSentencesI()
                
                if let scores = await fetchScoreFromSupabase() {
                    bscore = scores.bscore
                    iscore = scores.iscore
                    ascore = scores.ascore
                    
                    bindex = scores.bindex
                    iindex = scores.iindex+1
                    aindex = scores.aindex
                }
                
                print("Loaded \(supData.count) items")
            }
            
            
        }.onChange(of: iindex) {
            Task {
                await saveOrUpdateScore(bscore: bscore, iscore: iscore, ascore: ascore,bindex: bindex,iindex:iindex,aindex: aindex)
            }
        }
    }
    
    
    func triggerHapticFeedback(success: Bool) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(success ? .success : .error)
    }
    
    
    func loadSentencesI() async {
        do {
            let response: [SupData] = try await supabase
                .from("idata")
                .select()
                .execute()
                .value
            supData = response
            print("Yaaayyyy")
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    
    func handleSelection(isCorrect: Bool) {
        guard iindex < supData.count else { return }
        let item = supData[iindex]
        
        if isCorrect {
            print("✅ Selected as correct")
            if item.correct == "1" {
                iscore += 5
                sentenceBackground = .green
            } else {
                iscore -= 2
                sentenceBackground = .red
                triggerHapticFeedback(success: false)
            }
        } else {
            print("❌ Selected as wrong")
            if item.correct == "2" {
                iscore += 5
                sentenceBackground = .green
            } else {
                iscore -= 2
                sentenceBackground = .red
                triggerHapticFeedback(success: false)
            }
        }
        
        // Reset after short delay
        
    }

    
}

#Preview {
    IPlay(path: .constant(NavigationPath()))
}

