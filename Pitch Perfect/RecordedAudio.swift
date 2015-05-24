//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Sulaiman Azhar on 23.11.14.
//  Copyright (c) 2014 Kazmi. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(url: NSURL!, text: String!) {
        filePathUrl = url
        title = text
    }
    
}