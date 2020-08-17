//
//  Photo.swift
//  HWS_100DoS_Day50ChallengeApp
//
//  Created by Jeremy Fleshman on 8/17/20.
//  Copyright © 2020 Jeremy Fleshman. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var fileName: String
    var caption: String
    var imageUrl: URL
}
