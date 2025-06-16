//
//  TestView.swift
//  Wordulary
//
//  Created by Irfan on 09/06/25.
//
import SwiftUI
/*
 struct WordView: View {
 
 @State private var dragOffset: CGSize = .zero
 @State private var currentIndex = 0
 @State private var selection: String? = nil
 
 
 var body: some View {
 ZStack{
 Color("Col2").ignoresSafeArea()
 
 VStack{
 
 ZStack{
 RoundedRectangle(cornerRadius: 16)
 .fill(Color.white)
 .frame(width: 320, height: 150)
 .overlay(
 RoundedRectangle(cornerRadius: 16)
 .stroke(Color.purple, lineWidth: 4)
 )
 
 Text("I have a _____ dog.").font(.system(size: 25,weight: .bold,design: .rounded))
 }.padding(.top,180)
 
 
 ZStack{
 Rectangle().foregroundStyle(Color("Col3").opacity(0.9)).frame(width:200,height: 100).cornerRadius(20)
 
 Text("Big").foregroundStyle(Color("Col1")).font(.system(size: 65,weight: .bold,design: .rounded))
 }.padding(.top,100).offset(x: dragOffset.width)
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
 } else if dragOffset.width < -100 {
 selection = "wrong"
 print("❌ Selected as wrong")
 }
 
 
 withAnimation {
 dragOffset = .zero
 selection = nil
 currentIndex += 1
 }
 }
 )
 .animation(.spring(), value: dragOffset)
 
 Spacer()
 }
 
 
 }
 }
 }
 
 #Preview {
 WordView()
 }
 
 */
