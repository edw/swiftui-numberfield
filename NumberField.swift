//
//  NumberField.swift
//
//  Created by Edwin Watkeys on 9/20/19.
//  Copyright © 2019 Edwin Watkeys.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software
// is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//

import SwiftUI

struct NumberField : View {
    let label: String
    @Binding var number: Decimal?
    let formatter: NumberFormatter
    @State var displayedText: String? = nil
    @State var lastFormattedNumber: Decimal? = nil
    
    var body: some View {
        let b = Binding<String>(
            get: { return self.displayedText ?? "" },
            set: { newValue in
                self.displayedText = newValue
                self.number = self.formatter.number(from: newValue)?.decimalValue
        })

        return TextField(label, text: b, onEditingChanged: { inFocus in
            if inFocus {
                let textField = UIResponder.currentFirstResponder()
                print("\(String(describing: textField))")
            } else {
                self.lastFormattedNumber = self.formatter.number(from: b.wrappedValue)?.decimalValue
                if self.lastFormattedNumber != nil {
                    b.wrappedValue = self.formatter.string(for: self.lastFormattedNumber!) ?? ""
                }
            }
        })
            .padding()
            .keyboardType(.decimalPad)
    }
}
