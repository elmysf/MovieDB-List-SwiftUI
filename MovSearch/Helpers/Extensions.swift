//
//  Extensions.swift
//  MovSearch
//
//  Created by Sufiandy Elmy on 25/09/23.
//

import Foundation
import UIKit
import SwiftUI

extension String{
    func toEmojiFlag()->String{
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}


extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = style
    return formatter.string(from: self*60) ?? "" //*60 porque se obtienen en minutos desde la API
  }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private struct isPortraitEnvironment: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var isPortrait: Bool {
        get { self[isPortraitEnvironment.self] }
        set { self[isPortraitEnvironment.self] = newValue }
    }
}

extension View {
    func isPortrait(_ isPortrait: Bool) -> some View {
        environment(\.isPortrait, isPortrait)
    }
}
