//
//  SidebarViewController.swift
//  Gedis
//
//  Created by whimthen on 2020/4/21.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class SidebarViewController: NSViewController {
    
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var clipView: NSClipView!
    @IBOutlet var outlineView: NSOutlineView!
    @IBOutlet var searchBar: NSSearchField!
//    var searching: Notification = Notification.init(name: Notification.Name.init("FilterServers"))
    
    var mainWindowController: MainWindowController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.initServers()
        self.onServersChanged(servers: DataManager.sharedInstance.servers)
//        self.searchBar.textDidEndEditing = 

//        self.searchBar.observe(KeyPath<NSSearchField, String>()) { (searchBar, value) in
//
//        }
        
        // Listening on servers changed
//        DataManager.sharedInstance.servers
//        .subscribe(onNext: { (rootModels) in
//            print("SidebarViewController: onNext servers=\(String(describing: rootModels))")
//            self.onServersChanged(servers: rootModels)
//        })
//        .disposed(by: (NSApplication.shared.delegate as! AppDelegate).mainDisposeBag)
//        self.onServersChanged(servers: DataManager.sharedInstance.getServers())
    }
    
    override func viewDidAppear() {
        self.mainWindowController = self.view.window?.windowController as? MainWindowController
        self.mainWindowController!.mainSidebarViewController = self
        self.outlineView.expandItem(nil, expandChildren: true)
    }
    
    @IBAction func searchAction(_ sender: NSSearchField) {
        let text = sender.stringValue
        NSLog("Search Text: \(text)")
        if text == "" {
            self.onServersChanged(servers: nil)
        } else {
            let all = DataManager.sharedInstance.getServers()
            let servers = all.filter({ root in
                let children = root.children.filter({ server in
                    return (server?.name?.lowercased().contains(text.lowercased()) ?? false)
                })
                root.children = children
                return true
            })
            self.onServersChanged(servers: servers)
        }
    }
    
    @IBAction func connectAndExand(_ sender: NSOutlineView) {
        NSLog("Connecting.....")
        let selectedIndex = sender.selectedRow
        let model = sender.item(atRow: selectedIndex)
        if model is RootModel {
            return
        }
        NSLog("Connect leafModel....")
    }
    
    func onServersChanged(servers: [RootModel]?) {
        DataManager.sharedInstance.servers = servers ?? DataManager.sharedInstance.allServers
        NSLog("onServersChanged Servers \(String(describing: DataManager.sharedInstance.servers))")
        self.outlineView.reloadData()
        expandAll()
    }
    
    private func expandAll() {
        // Expand all by default
        for server in DataManager.sharedInstance.servers {
            self.outlineView.expandItem(server)
        }
    }
    
}

extension SidebarViewController: NSOutlineViewDataSource {
    
    // 通过这个方法, NSOutlineView获得每个层级需要显示的节点数, 当数据为顶级节点(根结点)时, 仅显示两层结构
    // 当NSOutlineView需要展示数据时, 第一步会调用此方法
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? RootModel {
            return item.children.count
        }
        return DataManager.sharedInstance.servers.count
    }
    
    // 通过这个方法, NSOutlineView知道每个层级节点的显示数据
    // 当NSOutlineView需要展示数据时, 第二步会调用此方法
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? RootModel {
            return item.children[index]!
        }
        return DataManager.sharedInstance.servers[index]
    }
    
    // 通过这个方法, NSOutlineView可以判断本层级节点是否可以展开(是否有子节点)
    // 当NSOutlineView需要展示数据时, 第三步会调用此方法
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        item is RootModel
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        item
    }
    
}

extension SidebarViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        outlineView.draggingDestinationFeedbackStyle = .gap
    }

    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
            outlineView.draggingDestinationFeedbackStyle = .sourceList
        }

    func outlineView(_ outlineView: NSOutlineView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, item: Any) -> Bool {
        false
    }

    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        true
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        item is RootModel && DataManager.sharedInstance.servers.contains(item as! RootModel)
    }
    
    // 通过这个代理方法, NSOutlineView生成每个节点的视图
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var cell: NSTableCellView?
        if item is RootModel {
            cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
            cell?.textField?.stringValue = (item as? RootModel)?.name ?? ""
        } else {
            cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as? NSTableCellView
            cell?.textField?.stringValue = (item as? Server)?.name ?? ""
        }
        return cell
    }
    
    func outlineViewSelectionIsChanging(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        let selectedIndex = outlineView.selectedRow
        
        let model = outlineView.item(atRow: selectedIndex)
        if model is RootModel || model is Server {
            return
        }
        NSLog("NSOutlineView Selection item is \(String(describing: model))")
        if self.mainWindowController != nil {
            if let server = model as? Server {
                self.mainWindowController?.title.stringValue = "Gedis - " + (server.name ?? "")
            }
//            self.mainWindowController!.selectedServer.accept(server)
        }
    }
    
}
