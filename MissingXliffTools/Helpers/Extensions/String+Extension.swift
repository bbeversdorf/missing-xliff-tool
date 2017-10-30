//
//  String+Extension.swift
//  MissingXliffTools
//
//  Created by brianbeversdorf on 11/11/17.
//  Copyright © 2017 brianbeversdorf. All rights reserved.
//

import Foundation

extension String {
    var escaped: String {
        return self.replacingOccurrences(of: "\n", with: "\\n")
    }
}
