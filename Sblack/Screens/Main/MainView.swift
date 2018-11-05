//
//  DragView.swift
//  Sblack
//
//  Created by Francesco Di Lorenzo on 04/02/2018.
//  Copyright © 2018 Francesco Di Lorenzo. All rights reserved.
//

import Foundation
import Cocoa

class MainView: NSView {
    
    enum Mode {
        case install
        case remove
    }
    
    // MARK: Subviews
    
    var backgroundView = NSVisualEffectView()
    var iconImageView = NSImageView()
    var titleLabel = NSTextView()
    var modeSegmentedControl = NSSegmentedControl()
    var dropAreaView = DropAreaView()
    var bottomLabel = NSTextView()
    var tweetButton = NSButton()
    var boxyButton = NSButton()
    lazy var bottomStackView = NSStackView(views: [self.tweetButton, self.boxyButton])
    
    // MARK: Interactions
    var userDidTapTweet: Interaction?
    var userDidTapBoxy: Interaction?
    
    var processState: ProcessState = .waitingForDrag {
        didSet { self.update() }
    }
    
    var currentMode: Mode {
        switch self.modeSegmentedControl.selectedSegment {
        case 0: return .install
        case 1: return .remove
        default: fatalError("unhandled mode")
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        self.setup()
        self.update()
        self.style()
        self.autolayout()
    }
    
    func setup() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.iconImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.modeSegmentedControl)
        self.addSubview(self.bottomLabel)
        self.addSubview(self.bottomStackView)
        
        self.addSubview(self.dropAreaView)
        
        self.tweetButton.target = self
        self.tweetButton.action = #selector(self.didTapTweetButton)
        
        self.boxyButton.target = self
        self.boxyButton.action = #selector(self.didTapPayButton)
    }
    
    func style() {
        self.backgroundView.material = .ultraDark
        
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = .white
        self.titleLabel.font = NSFont.systemFont(ofSize: 16)
        self.titleLabel.alignment = .center
        self.titleLabel.isEditable = false
        
        self.modeSegmentedControl.segmentCount = 2
        self.modeSegmentedControl.setLabel("Install", forSegment: 0)
        self.modeSegmentedControl.setLabel("Remove", forSegment: 1)
        self.modeSegmentedControl.setSelected(true, forSegment: 0)
        self.modeSegmentedControl.segmentStyle = .rounded
        self.modeSegmentedControl.setWidth(120, forSegment: 0)
        self.modeSegmentedControl.setWidth(120, forSegment: 1)
        
        self.bottomLabel.backgroundColor = .clear
        self.bottomLabel.textColor = .white
        self.bottomLabel.font = NSFont.systemFont(ofSize: 16)
        self.bottomLabel.alignment = .center
        self.bottomLabel.isEditable = false
        self.bottomLabel.string = "Enjoyed Sblack?"
        
        self.tweetButton.attributedTitle = NSAttributedString(string: "Tweet about it 🐦 ", attributes: [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ])
        self.tweetButton.bezelStyle = .recessed
        
        self.boxyButton.attributedTitle = NSAttributedString(string: "Check out Boxy 💌 ", attributes: [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ])
        self.boxyButton.bezelStyle = .recessed
        
        self.bottomStackView.orientation = .horizontal
    }
    
    func update() {
        
        let bottomViews: [NSView] = [self.bottomLabel, self.tweetButton, self.boxyButton]
        
        switch self.processState {
        case .waitingForDrag:
            self.titleLabel.string = "Drag Slack.app here 👇"
            self.iconImageView.image = #imageLiteral(resourceName: "statusStart")
            self.modeSegmentedControl.isEnabled = true
            self.modeSegmentedControl.isHidden = false
            bottomViews.hide()
        case .applyingTheme:
            self.titleLabel.string = "Applying black magic…"
            self.iconImageView.image = #imageLiteral(resourceName: "statusDragged")
            self.modeSegmentedControl.isEnabled = false
            self.modeSegmentedControl.isHidden = false
            bottomViews.hide()
        case .done:
            self.titleLabel.string = "Done 🤟\n Re-open Slack for the new style!"
            self.iconImageView.image = #imageLiteral(resourceName: "statusDone")
            self.modeSegmentedControl.isHidden = true
            bottomViews.show()
        }
    }
    
    func autolayout() {
    
        let views: [NSView] = [
            self.backgroundView,
            self.iconImageView,
            self.dropAreaView,
            self.titleLabel,
            self.modeSegmentedControl,
            self.tweetButton,
            self.boxyButton,
            self.bottomLabel,
        ]
        
        let constraints: [NSLayoutConstraint] =
                backgroundView.fill(self) +
                iconImageView.center(in: self) +
                dropAreaView.fill(self) +
                [
                    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                    titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                    titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 44),
                    titleLabel.heightAnchor.constraint(equalToConstant: 50),
                
                    modeSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                    modeSegmentedControl.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 25),
                
                    bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                    bottomLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                    bottomLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 25),
                    bottomLabel.heightAnchor.constraint(equalToConstant: 25),
                    
                    bottomStackView.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 0),
                    bottomStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ]
        
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        self.addConstraints(constraints)
    }
    
    
    @objc private func didTapTweetButton() {
        self.userDidTapTweet?()
    }
    
    @objc private func didTapPayButton() {
        self.userDidTapBoxy?()
    }
}

extension NSView {
    func fill(_ other: NSView) -> [NSLayoutConstraint] {
        return [
            self.topAnchor.constraint(equalTo: other.topAnchor),
            self.bottomAnchor.constraint(equalTo: other.bottomAnchor),
            self.leftAnchor.constraint(equalTo: other.leftAnchor),
            self.rightAnchor.constraint(equalTo: other.rightAnchor),
        ]
    }
    
    func center(in other: NSView) -> [NSLayoutConstraint] {
        return [
            self.centerYAnchor.constraint(equalTo: other.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: other.centerXAnchor)
        ]
    }
}

extension Collection where Element: NSView {
    func hide() {
        self.forEach { $0.isHidden = true }
    }
    
    func show() {
        self.forEach { $0.isHidden = false }
    }
}
