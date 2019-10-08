//
//  DecimalField.swift
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

extension UIResponder {
    static var _currentFirstResponder: UIResponder?
    
    @objc func findFirstResponder(sender: UIResponder) {
        UIResponder._currentFirstResponder = self
    }
    
    static func currentFirstResponder() -> UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
}

struct DecimalField : View {
    let label: String
    @Binding var value: Decimal?
    let formatter: NumberFormatter
    @State var displayedText: String? = nil
    @State var lastFormattedValue: Decimal? = nil
    
    var body: some View {
        let b = Binding<String>(
            get: { return self.displayedText ?? "" },
            set: { newValue in
                self.displayedText = newValue
                self.value = self.formatter.number(from: newValue)?.decimalValue
        })
        
        return TextField(label, text: b, onEditingChanged: { inFocus in
            if inFocus {
                let textField = UIResponder.currentFirstResponder()
                print("\(String(describing: textField))")
            } else {
                self.lastFormattedValue = self.formatter.number(from: b.wrappedValue)?.decimalValue
                if self.lastFormattedValue != nil {
                    DispatchQueue.main.async {
                        b.wrappedValue = self.formatter.string(for: self.lastFormattedValue!) ?? ""
                    }
                }
            }
        })
            .padding()
            .keyboardType(.decimalPad)
    }
}

struct TipCalculator: View {
    @State var dollarValue: Decimal?
    @State var tipRate: Decimal?
    @State var totalValue: Decimal?
    
    static var currencyFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.isLenient = true
        return nf
    }
    
    static var percentFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.isLenient = true
        return nf
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Text("Check Amount")
                        Divider()
                        DecimalField(label: "Amount", value: $dollarValue, formatter: Self.currencyFormatter)
                    }
                    
                    HStack {
                        Text("Tip Rate")
                        Divider()
                        DecimalField(label: "Rate", value: $tipRate, formatter: Self.percentFormatter)
                    }
                }
                .padding()
                Button("Add Tip") {
                    if let dollarValue = self.dollarValue, let tipRate = self.tipRate {
                        self.totalValue = dollarValue * (1.0 + tipRate)
                    } else {
                        self.totalValue = nil
                    }
                }
                .padding()
                VStack {
                    HStack {
                        Text("Tip Amount")
                        Divider()
                        if totalValue != nil {
                            Text(Self.currencyFormatter.string(for: totalValue! - dollarValue!) ?? "-")
                        } else {
                            Text("-")
                        }
                        Spacer()
                    }
                    HStack {
                        Text("Total")
                        Divider()
                        if totalValue != nil {
                            Text(Self.currencyFormatter.string(for: totalValue) ?? "-")
                        } else {
                            Text("-")
                        }
                        Spacer()
                    }
                }
                .padding()
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }
    }
}

struct DecimalField_Previews: PreviewProvider {
    
    static var previews: some View {
        TipCalculator()
    }
}