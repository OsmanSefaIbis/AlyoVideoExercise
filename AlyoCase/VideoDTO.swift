//
//  VideoDTO.swift
//  AlyoCase
//
//  Created by Sefa İbiş on 12.03.2024.
//

import Foundation

struct VideoItem: Decodable {
    let t: String?
    let u: String?
}

typealias VideoItems = [VideoItem]
