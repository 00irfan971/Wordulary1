//
//  csvParse.swift
//  Wordulary
//
//  Created by Irfan on 12/06/25.
//

import Foundation
import Supabase
func loadCSV(from fileName: String) -> [SentenceItem] {
    guard let filePath = Bundle.main.path(forResource: "simple_sentences_english", ofType: "csv") else {
        print("CSV file not found.")
        return []
    }

    do {
        let content = try String(contentsOfFile: filePath)
        var lines = content.components(separatedBy: "\n")
        lines.removeFirst() // remove header
        
        return lines.compactMap { line in
            let fields = line.components(separatedBy: ",")
            guard fields.count >= 6,
                  let id = Int(fields[0]) else { return nil }
            
            return SentenceItem(
                id: id,
                sentence: fields[1],
                option1: fields[2],
                option2: fields[3],
                correctOption: fields[4],
                notes: fields[5]
            )
        }
    } catch {
        print("Failed to read CSV file: \(error)")
        return []
    }
}

func loadCSV2(from fileName: String) -> [SentenceItem] {
    guard let filePath = Bundle.main.path(forResource: "Advanced_Data", ofType: "csv") else {
        print("CSV file not found.")
        return []
    }

    do {
        let content = try String(contentsOfFile: filePath)
        var lines = content.components(separatedBy: "\n")
        lines.removeFirst() // remove header

        return lines.compactMap { line in
            let fields = line.split(separator: ",", maxSplits: 5).map { String($0) }
            guard fields.count >= 5,
                  let id = Int(fields[0]) else { return nil }

            return SentenceItem(
                id: id,
                sentence: fields[1],
                option1: fields[2],
                option2: fields[3],
                correctOption: fields[4],
                notes: fields.count > 5 ? fields[5] : ""
            )

        }
    } catch {
        print("Failed to read CSV file: \(error)")
        return []
    }
}



func loadCSV3(from fileName: String) -> [SentenceItem] {
    guard let filePath = Bundle.main.path(forResource: "intermediate_Data", ofType: "csv") else {
        print("CSV file not found.")
        return []
    }

    do {
        let content = try String(contentsOfFile: filePath)
        var lines = content.components(separatedBy: "\n")
        lines.removeFirst() // remove header

        return lines.compactMap { line in
            let fields = line.split(separator: ",", maxSplits: 5).map { String($0) }
            guard fields.count >= 5,
                  let id = Int(fields[0]) else { return nil }

            return SentenceItem(
                id: id,
                sentence: fields[1],
                option1: fields[2],
                option2: fields[3],
                correctOption: fields[4],
                notes: fields.count > 5 ? fields[5] : ""
            )

        }
    } catch {
        print("Failed to read CSV file: \(error)")
        return []
    }
}





