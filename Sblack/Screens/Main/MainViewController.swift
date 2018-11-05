//
//  ViewController.swift
//  Sblack
//
//  Created by Francesco Di Lorenzo on 04/02/2018.
//  Copyright © 2018 Francesco Di Lorenzo. All rights reserved.
//

import Cocoa

enum ProcessState {
    case waitingForDrag
    case applyingTheme
    case done
}

class MainViewController: NSViewController {
    
    var processState: ProcessState = .waitingForDrag {
        didSet { self.updateView() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInteractions()
    }
    
    func setupInteractions() {
        self.rootView.dropAreaView.dragDidEnd = { [unowned self] url in
            
            let res: SlackPatcher.Result
            
            switch self.rootView.currentMode {
            case .install:
                res = SlackPatcher.applySlackBlackTheme(at: url)
            case .remove:
                res = SlackPatcher.removeSlackBlackTheme(at: url)
            }
            
            if case .failure(let reason) = res {
                if reason != .other {
                    showError(title: "Error", message: reason.rawValue)
                }
                self.processState = .waitingForDrag
                return
            }
            
            self.processState = .applyingTheme
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                switch res {
                case .success:
                    self.processState = .done
                case .failure(_):
                    break
                }
            }
        }
        
        self.rootView.userDidTapTweet = {
            let ws = NSWorkspace.shared
            ws.open(URL(string: Constants.tweetURL)!)
        }
        
        self.rootView.userDidTapBoxy = {
            let ws = NSWorkspace.shared
            ws.open(URL(string: Constants.boxyURL)!)
        }
    }
    
    func updateView() {
        self.rootView.processState = self.processState
    }
}

extension MainViewController {
    var rootView: MainView {
        return self.view as! MainView
    }
}
