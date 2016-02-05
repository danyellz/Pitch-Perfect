//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by TY on 2/2/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
