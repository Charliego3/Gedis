//
//  MainContentViewController.swift
//  Gedis
//
//  Created by whimthen on 2020/4/21.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class MainContentViewController: NSViewController {
    
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var clipView: NSClipView!
    @IBOutlet var outlineView: NSOutlineView!
    
    var mainWindowController: MainWindowController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        let mainWindowController = self.view.window?.windowController as! MainWindowController
        mainWindowController.mainContentViewController = self
    }
    
    func onServersChanged(servers: [RootModel]?) {
        DataManager.sharedInstance.servers = servers ?? []
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

extension MainContentViewController: NSOutlineViewDataSource {
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

extension MainContentViewController: NSOutlineViewDelegate {
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
            if  model is RootModel {
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
