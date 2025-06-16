//
//  AuthViiew.swift
//  Wordulary
//
//  Created by Irfan on 17/06/25.
//
import SwiftUI

struct AuthView: View {
  @State private var email = ""
  @State private var isLoading = false
  @State private var result: Result<Void, Error>?

  var body: some View {
    ZStack {
      // 🔵 Background - Neon style
        Color("Col2")
        .ignoresSafeArea()

      VStack(spacing: 30) {
          
        Text("🔐 Sign In")
          .font(.largeTitle.bold())
          .foregroundColor(.white)
          .shadow(color: .cyan, radius: 10)

        // 🔹 Neon TextField
        TextField("Enter your email", text: $email)
          .padding()
          .background(Color.black.opacity(0.3))
          .foregroundColor(.white)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.cyan, lineWidth: 2)
              .shadow(color: .cyan, radius: 6)
          )
          .cornerRadius(10)
          .keyboardType(.emailAddress)
          .textContentType(.emailAddress)
          .autocapitalization(.none)
          .padding(.horizontal)

        // 🔹 Neon Button
        Button(action: signInButtonTapped) {
          Text("Send OTP")
            .font(.headline)
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
              LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(12)
            .shadow(color: .cyan, radius: 8)
        }
        .padding(.horizontal)

        // 🔹 Loading indicator
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
        }

        // 🔹 Result Message
        if let result {
          switch result {
          case .success:
            Text("✅ Check your inbox!")
              .foregroundColor(.green)
              .fontWeight(.bold)
              .shadow(color: .green, radius: 6)
          case .failure(let error):
            Text(error.localizedDescription)
              .foregroundColor(.red)
              .fontWeight(.semibold)
              .multilineTextAlignment(.center)
          }
        }

        Spacer()
      }
      .padding(.top,200)
    }
    .onOpenURL { url in
      Task {
        do {
          try await supabase.auth.session(from: url)
        } catch {
          self.result = .failure(error)
        }
      }
    }
  }

  func signInButtonTapped() {
    Task {
      isLoading = true
      defer { isLoading = false }

      do {
        try await supabase.auth.signInWithOTP(
          email: email,
          redirectTo: URL(string: "io.supabase.user-management://login-callback")
        )
        result = .success(())
      } catch {
        result = .failure(error)
      }
    }
  }
}

#Preview {
    AuthView()
}
