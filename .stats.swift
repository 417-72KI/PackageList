#!/usr/bin/swift sh

import Foundation
import ShellOut   // @JohnSundell

let packageList = "packages.json"
let calendar = Calendar(identifier: .gregorian)
let fmt = DateFormatter()
fmt.dateFormat = "yyyy-MM-dd"
fmt.timeZone = .init(abbreviation: "UTC")

let start = fmt.date(from: "2019-05-15")!
var date = start
while date <= Date.now {
    defer { date = calendar.date(byAdding: .init(day: 7), to: date)! }

    let rev = try shellOut(to: #"git rev-list -n 1 --before="\#(date)" main"#)

    if !rev.isEmpty {
        try shellOut(to: "git checkout \(rev)")
        let data = try Data(contentsOf: URL(fileURLWithPath: packageList))
        let packages = try JSONDecoder().decode([String].self, from: data)
        print(fmt.string(from: date), ",", packages.count, separator: "")
    }
}
