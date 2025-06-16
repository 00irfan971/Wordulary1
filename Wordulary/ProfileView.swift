//
//  ProfileView.swift
//  Wordulary
//
//  Created by Irfan on 17/06/25.
//

import SwiftUI

struct ProfileView: View {
  @State var username = ""
  @State var fullName = ""
  @State var website = ""
  @State var isLoading = false

  var onComplete: () -> Void

    var body: some View {
      NavigationStack {
        ZStack {
          Color("Col2")
            .ignoresSafeArea()

          VStack(spacing: 24) {
            Text("🧑‍💼 Profile Setup")
              .font(.largeTitle.bold())
              .foregroundColor(.white)
              .shadow(color: .cyan, radius: 6)

            Group {
              neonTextField(title: "Username", text: $username)
              neonTextField(title: "Full Name", text: $fullName)
            }

            Button(action: updateProfileButtonTapped) {
              Text("Save Profile")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(color: .cyan.opacity(0.8), radius: 6)
            }
            .padding(.horizontal)

            if isLoading {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
            }

            Spacer()
          }
          .padding(.top, 200)
        }
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
              Button("Sign Out", role: .destructive) {
              Task {
                try? await supabase.auth.signOut()
              }
            }.foregroundStyle(Color.red)
          }
        }
        .task {
          await getInitialProfile()
        }
      }
    }



  func neonTextField(title: String, text: Binding<String>) -> some View {
    TextField(title, text: text)
      .padding()
      .background(Color.black.opacity(0.3))
      .foregroundColor(.white)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.cyan, lineWidth: 1.5)
          .shadow(color: .cyan, radius: 5)
      )
      .cornerRadius(10)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
      .padding(.horizontal)
  }


  func getInitialProfile() async {
    do {
      let currentUser = try await supabase.auth.session.user

      let profile: Profile = try await supabase
        .from("profiles")
        .select()
        .eq("id", value: currentUser.id)
        .single()
        .execute()
        .value

      username = profile.username ?? ""
      fullName = profile.fullName ?? ""
      website = profile.website ?? ""
    } catch {
      debugPrint(error)
    }
  }

  func updateProfileButtonTapped() {
    Task {
      isLoading = true
      defer { isLoading = false }

      do {
        let currentUser = try await supabase.auth.session.user

        try await supabase
          .from("profiles")
          .update(
            UpdateProfileParams(
              username: username,
              fullName: fullName,
              website: website
            )
          )
          .eq("id", value: currentUser.id)
          .execute()

        onComplete()
      } catch {
        debugPrint(error)
      }
    }
  }
}


#Preview {
  ProfileView {
    print("Completed")
  }
}

