//
//  Errors.swift
//  Sblack
//
//  Created by Francesco Di Lorenzo on 05/02/2018.
//  Copyright © 2018 Francesco Di Lorenzo. All rights reserved.
//

import Foundation
import Cocoa

typealias ShowErrorCompletion = (NSApplication.ModalResponse) -> Void

func showError(title: String, message: String, buttons: [String] = ["OK"], completion: ShowErrorCompletion? = nil) {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = message
    
    buttons.forEach { alert.addButton(withTitle: $0) }

    let res = alert.runModal()
    
    completion?(res)
}
