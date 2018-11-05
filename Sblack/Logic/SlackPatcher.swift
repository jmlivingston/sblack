//
//  SlackPatcher.swift
//  Sblack
//
//  Created by Francesco Di Lorenzo on 04/02/2018.
//  Copyright © 2018 Francesco Di Lorenzo. All rights reserved.
//

import Foundation

enum SlackPatcher {} // namespace

extension SlackPatcher {
    
    enum Result {
        
        enum FailureReason: String {
            case cannotWriteToTemp = "Cannot write to temporary directory."
            case cannotFindJsToPatch = "Cannot find Slack js to patch."
            case cannotReadJsToPatch = "Cannot read Slack js to patch."
            case cannotWritePatchedJsToTempDir = "Cannot write patched js to temp dir."
            case sblackNotInstalled = "Sblack does not seem to be installed."
            case sblackAlreadyInstalled = "Sblack seems to be already installed. You may want to remove it first."
            case other
        }
        
        case success
        case failure(reason: FailureReason)
    }
    
    static func applySlackBlackTheme(at url: URL) -> Result {
        
        let fm = FileManager.default
        
        let slackJsFilePath = url.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js").path
        
        if !fm.fileExists(atPath: slackJsFilePath) {
            return .failure(reason: .cannotFindJsToPatch)
        }
        
        guard !self.isSblackInstalled(at: url) else {
            return .failure(reason: .sblackAlreadyInstalled)
        }
        
        guard let slackJS = try? String(contentsOfFile: slackJsFilePath) else {
            return .failure(reason: .cannotReadJsToPatch)
        }
    
        let css = try! String(contentsOfFile: Bundle.main.url(forResource: "night_mode", withExtension: "css")!.path)
        let jsTemplate = try! String(contentsOfFile: Bundle.main.url(forResource: "inject_style", withExtension: "js")!.path)
        let ourJs = jsTemplate.replacingOccurrences(of: "{{{CUSTOM_CSS}}}", with: css)
        let patchedSlackJs = slackJS + "\n" + ourJs
        
        let patchedJsPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString)

        do {
            try patchedSlackJs.write(to: patchedJsPath, atomically: true, encoding: .utf8)
        } catch {
            return .failure(reason: .cannotWritePatchedJsToTempDir)
        }
        

        let auth = BLAuthentication()
        
        auth.authenticate(["/bin/rm", "/bin/mv"])
        auth.executeCommand("/bin/rm", withArgs: [slackJsFilePath], andType: nil, andMessage: nil)
        auth.executeCommand("/bin/mv", withArgs: [patchedJsPath.path, slackJsFilePath], andType: nil, andMessage: nil)
        
        return .success
    }
    
    static func removeSlackBlackTheme(at url: URL) -> Result {
        let fm = FileManager.default
        
        let slackJsFilePath = url.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js").path
        
        if !fm.fileExists(atPath: slackJsFilePath) {
            return .failure(reason: .cannotFindJsToPatch)
        }
        
        guard let slackJS = try? String(contentsOfFile: slackJsFilePath) else {
            return .failure(reason: .cannotReadJsToPatch)
        }

        guard
        let patchStartRange = slackJS.range(of: "// <--- Sblack start --->"),
        let patchEndRange = slackJS.range(of: "// <--- Sblack end --->")
        else { return .failure(reason: .sblackNotInstalled) }
        
        let patchRange = patchStartRange.lowerBound...patchEndRange.upperBound
        let unpatchedJs = slackJS.replacingCharacters(in: patchRange, with: "")
        
        let unpatchedJsPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString)

        do {
            try unpatchedJs.write(to: unpatchedJsPath, atomically: true, encoding: .utf8)
        } catch {
            return .failure(reason: .cannotWritePatchedJsToTempDir)
        }

        let auth = BLAuthentication()

        guard auth.authenticate(["/bin/rm", "/bin/mv"]) else {
            return .failure(reason: .other)
        }
        
        auth.executeCommand("/bin/rm", withArgs: [slackJsFilePath], andType: nil, andMessage: nil)
        auth.executeCommand("/bin/mv", withArgs: [unpatchedJsPath.path, slackJsFilePath], andType: nil, andMessage: nil)

        return .success
    }
    
    static func isSblackInstalled(at url: URL) -> Bool {
        let fm = FileManager.default
        
        let slackJsFilePath = url.appendingPathComponent("Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js").path
        
        if !fm.fileExists(atPath: slackJsFilePath) {
            return false
        }
        
        guard let slackJS = try? String(contentsOfFile: slackJsFilePath) else {
            return false
        }
        
        guard
            let _ = slackJS.range(of: "// <--- Sblack start --->"),
            let _ = slackJS.range(of: "// <--- Sblack end --->")
            else { return false }
        
        return true
    }
}
