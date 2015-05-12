//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Benjamin Uliana on 2015-04-26.
//  Copyright (c) 2015 SquashOnline. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathURL: NSURL?
    var title: String?
    
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
    
}
