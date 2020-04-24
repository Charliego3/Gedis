//
//  MainSplitViewController.swift
//  Gedis
//
//  Created by whimthen on 2020/4/21.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    
    let newServerViewController = NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: "NewServerViewController") as! NewServerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        let mainWindowController = self.view.window?.windowController as! MainWindowController
        mainWindowController.mainSplitViewController = self
    }
    
    func onShowNewAccountSheet() {
        self.presentAsSheet(newServerViewController)
    }
    
}
