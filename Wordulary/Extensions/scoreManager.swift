//
//  scoreManager.swift
//  Wordulary
//
//  Created by Irfan on 23/06/25.
//

import Foundation
import PostgREST
import UIKit

// Reusable model
struct ScoreRow: Codable {
    let user_id: UUID
    let bscore: Int
    let iscore: Int
    let ascore: Int
    let bindex: Int
    let iindex: Int
    let aindex: Int
    let updated_at: String
}


// MARK: - Supabase Helpers
func fetchScoreFromSupabase() async -> (bscore: Int, iscore: Int, ascore: Int, bindex: Int, iindex: Int, aindex: Int)? {
    guard let userId = try? await supabase.auth.session.user.id else {
        print("❌ User not logged in")
        return nil
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
        print("✅ Scores fetched from Supabase")
        return (scoreRow.bscore, scoreRow.iscore, scoreRow.ascore,
                scoreRow.bindex, scoreRow.iindex, scoreRow.aindex)

    } catch {
        print("❌ Failed to fetch scores: \(error)")
        return nil
    }
}


func saveOrUpdateScore(bscore: Int, iscore: Int, ascore: Int,
                       bindex: Int, iindex: Int, aindex: Int) async {
    guard let user = try? await supabase.auth.session.user else {
        print("❌ User not logged in")
        return
    }

    let payload = ScoreRow(
        user_id: user.id,
        bscore: bscore,
        iscore: iscore,
        ascore: ascore,
        bindex: bindex,
        iindex: iindex,
        aindex: aindex,
        updated_at: ISO8601DateFormatter().string(from: Date())
    )

    do {
        try await supabase
            .from("scores")
            .upsert(payload)
            .execute()
        print("✅ Score and index updated")
    } catch {
        print("❌ Error saving score and index: \(error)")
    }
}



// MARK: - Haptic Feedback
func triggerHapticFeedback(success: Bool) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(success ? .success : .error)
}

