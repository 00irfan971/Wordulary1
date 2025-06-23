//
//  ContentView1.swift
//  Wordulary
//
//  Created by Irfan on 17/05/25.
//

import SwiftUI

struct ContentView: View {
    //@Environment(\.supabaseClient) private var supabaseClient
    
    @State var page:Int=0

    
    var body: some View {
        
            
            HomeView(play: $page)
        
        
    }
}


#Preview {
    ContentView()
}
