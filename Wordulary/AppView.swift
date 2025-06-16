//
//  AppView.swift
//  Wordulary
//
//  Created by Irfan on 17/06/25.
//

import SwiftUI

enum AppRoute {
  case loading
  case auth
  case profile
  case content
}

struct AppView: View {
  @State private var route: AppRoute = .loading

  var body: some View {
    Group {
      if route == .loading {
        ProgressView("Loading...")
      } else if route == .auth {
        AuthView()
      } else if route == .profile {
        ProfileView {
          route = .content
        }
      } else if route == .content {
        ContentView()
      }
    }
    .task {
      for await state in supabase.auth.authStateChanges {
        guard [.initialSession, .signedIn, .signedOut].contains(state.event) else { continue }

        if let session = state.session {
          let isComplete = await isProfileComplete(userID: session.user.id)
          route = isComplete ? .content : .profile
        } else {
          route = .auth
        }
      }
    }
  }

  func isProfileComplete(userID: UUID) async -> Bool {
    do {
      let profile: Profile = try await supabase
        .from("profiles")
        .select()
        .eq("id", value: userID)
        .single()
        .execute()
        .value

      return !(profile.username?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    } catch {
      print("Error checking profile completion:", error)
      return false
    }
  }
}


#Preview {
    AppView()
}
