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
 used to select from a list of strings, and typically as the input
 view of a text field.

 ```
 let picker = FFSPicker(withList: myList, managing: textField)
 ```

 Especially useful when dealing with multiple pickers.
 */
final public class FFSPicker<T: CustomStringConvertible> {
    /// The data source for the underlying `UIPickerView`. Usually, this will be an array
    /// of `String`, but can be any object that provides a `description` via `CustomStringConvertible`
    public let list: [T]

    /// The underlying `UIPickerView` object being managed.
    /// - Note: If you're not interested in provided one yourself, this will contain the object we create for you.
    public let view: UIPickerView

    /**
     The `UITextField` object to be optionally managed.
     
     If provided, `FFSPicker` will automatically update the text field with the text of the current picker selection.
     If no text field is provided, this property will be `nil`.

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
            manager.textField?.inputView = shouldManageTextFieldInputView ? view : nil
        }
    }

    /// The closure that `FFSPicker` will call when an item is selected in the `view`,
    /// providing the object from the corresponding position in the `list`, as well as
    /// the associated `textField`, if present.
    public var callback: ((T, UITextField?) -> Void)? {
        get { return manager.handle }
        set { manager.handle = newValue }
    }

    /// Set to false if you do not wish for `FFSPicker` to automatically set its `view` as the
    /// `inputView` of the provided `textField`. This property's value is `true` by default.
    public var shouldManageTextFieldInputView: Bool = true {
        didSet {
            manager.textField?.inputView = shouldManageTextFieldInputView ? view : nil
        }
    }

    /**
     The designated initializer for this class.

     - Parameter list: The data source for the underlying `UIPickerView`.
     
     - Parameter view: *Optional* An existing `UIPickerView` to be wrapped.

     - Parameter managing: *Optional* An existing `UITextField` whose `text` and `inputView` should be managed.
     
     - Parameter callback: *Optional* A closure that passes in the string value
        of the picker view's currently-selected row, as well as its corresponding text field for convenience.
     */
    public init(withList list: [T], wrapping view: UIPickerView = UIPickerView(), managing field: UITextField? = nil, callback: ((T, UITextField?) -> Void)? = nil) {
        self.list = list
        self.view = view

        manager = FFSPickerViewManager(counter: list.count, grabber: { list[$0] }, handler: callback)

        self.textField = field
        self.view.dataSource = manager
        self.view.delegate = manager
    }

    // MARK: Private

    private let manager: FFSPickerViewManager

    final private class FFSPickerViewManager: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let count: () -> Int
        let grab: (Int) -> T
        var handle: ((T, UITextField?) -> Void)?
        weak var textField: UITextField?

        init(counter: @autoclosure @escaping () -> Int, grabber: @escaping (Int) -> T, handler: ((T, UITextField?) -> Void)?) {
            count = counter
            grab = grabber
            handle = handler
        }

        func numberOfComponents(in _: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return count()
        }

        func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return grab(row).description
        }

        func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            textField?.text = grab(row).description
            handle?(grab(row), textField)
        }
    }
}
