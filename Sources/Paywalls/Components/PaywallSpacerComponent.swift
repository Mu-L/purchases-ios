//
//  File.swift
//  
//
//  Created by Josh Holtz on 6/12/24.
//

import Foundation

public extension PaywallComponent {
    struct SpacerComponent: PaywallComponentBase {

        let type: String
        public let displayPreferences: [DisplayPreference]?

        public init(
            displayPreferences: [DisplayPreference]? = nil
        ) {
            self.type = "spacer"
            self.displayPreferences = displayPreferences
        }

        var focusIdentifiers: [FocusIdentifier]? = nil

    }
}
