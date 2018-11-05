//
//  Constants.swift
//  Sblack
//
//  Created by Francesco Di Lorenzo on 05/02/2018.
//  Copyright © 2018 Francesco Di Lorenzo. All rights reserved.
//

import Foundation

enum Constants {
    // TODO: add url
    static let tweetURL = "https://twitter.com/intent/tweet?text=I’ve just made my Slack dark with this free app by the @getboxy team ⚫ 🙌 http://www.sblack.online".urlEscaped
    static let boxyURL = "http://www.boxyapp.co"
    static let helpURL = "https://github.com/frankdilo/sblack/wiki/Sblack-Help"
}

extension String {
    var urlEscaped: String {
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)
        return escapedString!
    }
}
