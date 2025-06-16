//
//  csvParse.swift
//  Wordulary
//
//  Created by Irfan on 12/06/25.
//

import Foundation
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
