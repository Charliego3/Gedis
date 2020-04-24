//
//  ServerModel.swift
//  Gedis
//
//  Created by whimthen on 2020/4/22.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class ServerModel: NSObject {
    
    var name: String = ""
    var host: String = ""
    var port: Int16 = 6379
    var password: String = ""
    
    init(_ name: String) {
        self.name = name
    }

}
