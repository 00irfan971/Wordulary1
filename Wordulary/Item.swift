//
//  Item.swift
//  Wordulary
//
//  Created by Irfan on 17/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
