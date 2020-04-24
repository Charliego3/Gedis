//
//  ServerDataManager.swift
//  Gedis
//
//  Created by whimthen on 2020/4/21.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

protocol ServerDataManager {
    
    func notifyOnServerChanged()
    
    func getServers() -> [RootModel]
    
    func newServer(_ name: String) -> Server?
    
}
