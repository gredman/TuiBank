//
//  NumberFormatterExtension.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

extension NumberFormatter {
    class func currencyFormatter() -> NumberFormatter {
        let numberFormatter: NumberFormatter
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }
}
