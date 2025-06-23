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
        
        if (page==0){
            
            HomeView(play: $page)
            
        }
        else{
            PlayView(path: .constant(NavigationPath()))
        }
        
    }
}


#Preview {
    ContentView()
}
