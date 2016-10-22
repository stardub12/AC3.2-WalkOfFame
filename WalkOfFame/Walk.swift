//
//  Walk.swift
//  WalkOfFame
//
//  Created by Jason Gresh on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Walk {
    let designer: String
    let description: String
    let location: String
    let sketchURLString: String
    
    init(designer: String, location: String, description: String, sketchURLString: String) {
        self.designer = designer
        self.description = description
        self.location = location
        self.sketchURLString = sketchURLString
    }
    
    convenience init?(withArray arr: [Any]) {
        if let design = arr[8] as? String,
            let descript = arr[9] as? String,
            let loc = arr[10] as? String,
            let sketch = arr[11] as? String  {
            self.init(designer: design, location: loc, description: descript, sketchURLString: sketch)
        }
        else {
            return nil
        }
    }
}
