//
//  NewServerViewController.swift
//  Gedis
//
//  Created by whimthen on 2020/4/22.
//  Copyright © 2020 whimthen. All rights reserved.
//

import Cocoa

class NewServerViewController: NSViewController {

    @IBOutlet var nameField: NSTextField!
    @IBOutlet var hostField: NSTextField!
    @IBOutlet var portField: NSTextField!
    @IBOutlet var passwordField: NSSecureTextField!
    @IBOutlet var showPassword: NSButton!
    @IBOutlet var stepper: NSStepper!
    @IBOutlet var testConnectionBtn: NSButton!
    @IBOutlet var cancelBtn: NSButton!
    @IBOutlet var okBtn: NSButton!
    
    static var newServerViewController: NewServerViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewServerViewController.newServerViewController = self
        self.preferredContentSize = view.frame.size
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func onOK(_ sender: Any) {
        NSLog("NewServer onOK.....")
        self.dismiss(self)
    }
    
    @IBAction func testConnection(_ sender: NSButton) {
        NSLog("Test Connection......")
        self.testConnectionBtn.image = nil
        self.cancelBtn.isEnabled = false
        self.okBtn.isEnabled = false
        let isLoading = self.testConnectionBtn.ay.startLoading(message: "Connecting...")
        if isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                _ = self.testConnectionBtn.ay.stopLoading()
                self.testConnectionBtn.image = NSImage.init(named: "NSStatusAvailable")
                self.testConnectionBtn.imagePosition = .imageLeading
                self.testConnectionBtn.title = "Connect Successful"
                self.cancelBtn.isEnabled = true
                self.okBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func showPassword(_ sender: NSButton) {
        NSLog("ShowPassword is checked? \(String(describing: (self.passwordField.cell as? NSSecureTextFieldCell)?.echosBullets))")
        NSLog("self.passwordField.cell \(String(describing: self.passwordField.cell))")
        if sender.state == .on {
            (self.passwordField.cell as? NSSecureTextFieldCell)?.echosBullets = true
//            self.passwordField.cell = NSTextFieldCell(textCell: self.passwordField.stringValue)
        } else {
            (self.passwordField.cell as? NSSecureTextFieldCell)?.echosBullets = false
        }
    }
    
    @IBAction func portStep(_ sender: NSStepper) {
        self.portField.stringValue = "\(sender.integerValue)"
    }
    
    func reset() {
        self.nameField.stringValue = ""
        self.hostField.stringValue = ""
        self.portField.stringValue = "6379"
        self.passwordField.stringValue = ""
        self.stepper.integerValue = 6379
        self.showPassword.state = .off
    }
    
}
