//
//  MainWindowController.swift
//  Gedis
//
//  Created by whimthen on 2020/4/21.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class MainWindowController: NSWindowController {
    
    @IBOutlet var title: NSTextField!
    var mainSplitViewController: MainSplitViewController? = nil
    var mainSidebarViewController: SidebarViewController? = nil
    var mainContentViewController: MainContentViewController? = nil
    var selectedServer: Server? = nil
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.setContentSize(NSSize(width: 800, height: 530))
    }
    
    @IBAction func toggleSidebar(_ sender: Any) {
        self.mainSplitViewController?.toggleSidebar(sender)
    }
    
    @IBAction func newServerClicked(_ sender: Any) {
        if mainSplitViewController != nil {
            NewServerViewController.newServerViewController?.reset()
            mainSplitViewController?.onShowNewAccountSheet()
        } else {
            NSLog("MainWindowController: Error mainViewController is nil")
        }
    }
    
}
