//
//  DataManager.swift
//  Gedis
//
//  Created by whimthen on 2020/4/21.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class DataManager: NSObject {
    
    static let sharedInstance = DataManager.init()
    let context: NSManagedObjectContext

//    static let favortiesModel = RootModel("Favorites")
//    static let serversModel = RootModel("Servers")
    
    let serverEntityName = "Server"
    var servers: [RootModel] = []
    let allServers: [RootModel] = [
        RootModel("Favorites"),
        RootModel("Servers")
    ]
    
    private override init() {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        self.context = delegate.persistentContainer.viewContext
        super.init()
        for root in getServers() {
            for server in root.children {
                if server!.isFavorite {
                    allServers[0].children.append(server)
                } else {
                    allServers[1].children.append(server)
                }
            }
        }
    }
    
    func fetch(request: NSFetchRequest<NSFetchRequestResult>) -> Any? {
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Failed")
            return nil
        }
    }
    
}

extension DataManager: ServerDataManager {
    
    func newServer(_ name: String) -> Server? {
        guard let newEntity = NSEntityDescription.entity(forEntityName: serverEntityName, in: context) else {
            return nil
        }
        let server = Server.init(entity: newEntity, insertInto: context)
        server.name = name
        return server
    }
    
    func addServer(name: String) -> Server? {
        guard let newEntity = NSEntityDescription.entity(forEntityName: serverEntityName, in: context) else {
            return nil
        }
        
        let newServer = Server.init(entity: newEntity, insertInto: context)
        newServer.name = name
        
        do {
            try context.save()
            self.notifyOnServerChanged()
        } catch {
            print(error)
        }
        
        return newServer
    }
    
    func notifyOnServerChanged() {
    }
    
    func getServers() -> [RootModel] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: serverEntityName)
        let savedServers = self.fetch(request: request) as! [Server]?
        let servers: [RootModel] = [
            RootModel("Favorites"),
            RootModel("Servers")
        ]
        if savedServers != nil && savedServers?.count != 0 {
            for server in savedServers! {
                if server.isFavorite {
                    servers[0].children.append(server)
                } else {
                    servers[1].children.append(server)
                }
            }
        }
        return servers
    }
    
    func initServers() {
        servers = getServers()
    }
    
}
