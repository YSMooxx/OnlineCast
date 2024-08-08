//
//  String+Extension.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation

extension String {
    
    func containsSubstring(substring: String, caseInsensitive: Bool = true) -> Bool {
        if caseInsensitive {
            return self.range(of: substring, options: .caseInsensitive) != nil
        } else {
            return self.contains(substring)
        }
    }
}
