//
//  FFSPicker.swift
//  https://github.com/nathanhosselton/FFSPicker
//
//  Copyright 2016, Nathan Hosselton; nathanhosselton@gmail.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit.UIPickerView
import UIKit.UITextField

/**
 A wrapper class for `UIPickerView` that automatically handles
 delegation for the common pattern of single-component pickers
 used to select from a list of strings (usually: as the input
 view of a text field).
 
 ```
 let picker = FFSPicker(withList: mySelections, callback: { [unowned self] in self.textField.text = $0 })
 textField.inputView = picker.view
 ```
 
 Especially useful when dealing with multiple pickers.
 */
final public class FFSPicker {

    /// The data source for the underlying UIPickerView.
    public let list: [String]

    /// The underlying UIPickerView being managed.
    public let view: UIPickerView

    /**
     The text field to be optionally managed.
     
     If provided, `FFSPicker` will automatically update the
     text field with the text of the current picker selection.
     Usually, you would use this as an alternative to providing
     a closure when the closure would fulfill the same purpose.

     - Note: The text field is weakly retained.
    */
    public var textField: UITextField? {
        get {
            return manager.textField
        }
        set {
            manager.textField = newValue
        }
    }

    private let manager: FFSPickerViewManager

    /**
     The designated initializer for this class.
     
     - Parameter list: The data source for the underlying `UIPickerView`.
     
     - Parameter view: *Optional* The `UIPickerView` to be used.
     
     - Parameter callback: A closure that passes in the string value
        of the picker view's currently-selected row.

     - Returns: A new, fully constructed FFSPicker
     */
    public init(withList list: [String], view: UIPickerView = UIPickerView(), callback: ((String) -> Void)? = nil) {
        self.list = list
        self.view = view

        manager = FFSPickerViewManager(counter: list.count, titler: { list[$0] }, handler: callback)
        self.view.dataSource = manager
        self.view.delegate = manager
    }

}

// MARK: Internal

final private class FFSPickerViewManager: NSObject {
    let count: () -> Int
    let title: (Int) -> String
    let handle: ((String) -> Void)?
    weak var textField: UITextField?

    init(counter: @autoclosure @escaping  () -> Int, titler: @escaping (Int) -> String, handler: ((String) -> Void)?) {
        self.count = counter
        self.title = titler
        self.handle = handler
    }

}

extension FFSPickerViewManager: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return count()
    }

}

extension FFSPickerViewManager: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return title(row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = title(row)
        handle?(title(row))
    }
    
}
