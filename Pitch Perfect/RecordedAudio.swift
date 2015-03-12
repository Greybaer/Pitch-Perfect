//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Greybear on 3/5/15.
//  Copyright (c) 2015 Infinite Loop, LLC. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePath: NSURL!
    var title: String!
    
    //GB - 3/11/15 Modified to use constructor to init variables.
    init(filePath: NSURL, title: String){
        self.filePath=filePath
        self.title=title
    }
}
