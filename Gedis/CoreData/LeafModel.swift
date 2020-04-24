//
//  LeafModel.swift
//  Gedis
//
//  Created by whimthen on 2020/4/22.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class ServerModel: NSObject {
    
    var name: String = ""
    var hasChildren: Bool = false
    
    init(_ name: String) {
        self.name = name
    }

}
