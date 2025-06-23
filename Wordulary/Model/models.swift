//
//  models.swift
//  Wordulary
//
//  Created by Irfan on 17/05/25.
//


import Foundation


struct SentenceItem: Identifiable {
    let id: Int
    let sentence: String
    let option1: String
    let option2: String
    let correctOption: String
    let notes: String
}

struct Profile: Decodable {
  let username: String?
  let fullName: String?
  let website: String?

  enum CodingKeys: String, CodingKey {
    case username
    case fullName = "full_name"
    case website
  }
}

struct UpdateProfileParams: Encodable {
  let username: String
  let fullName: String
  let website: String

  enum CodingKeys: String, CodingKey {
    case username
    case fullName = "full_name"
    case website
  }
}

