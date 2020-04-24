//
//  RootModel.swift
//  Gedis
//
//  Created by whimthen on 2020/4/22.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class RootModel: NSObject {
    
    var name: String = ""
    var isLeaf: Bool = false
    var children: [Server?] = []
    
    init(_ name: String) {
        self.name = name
    }

}
