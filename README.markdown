# FFSPicker
###### Delegation is alright in its place, but (sometimes) its place is in hell.
![badge-tag] ![badge-language] ![badge-license]  

FFSPicker is a wrapper for your UIPickerViews. It handles the most common delegation patterns so your view controllers don't have to.

## Why
Sometimes you need a picker view for the input of a text field.

```swift
textField = //…
pickerView = //…

pickerView.dataSource = self
pickerView.delegate = self
textField.inputView = pickerView

//…

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return mySelections.count
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return mySelections[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    textField.text = mySelections[row]
}

```

Then, some of those times you need multiple picker views.

```swift
// Triple the above boilerplate

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView {
    case picker1:
        return firstSelections.count
    case picker2:
        return secondSelections.count
    case picker3:
	return thirdSelections.count
    default:
        return 0
    }
}

//etc
```

**...**

## FFS
All you care about is shoving some data into a picker view and updating a text field.

```swift
let firstPicker = FFSPicker(withList: firstList, managing: firstTextField)
let secondPicker = FFSPicker(withList: secondList, managing: secondTextField)
let thirdPicker = FFSPicker(withList: thirdList, managing: thirdTextField)
```

*Better.*

>Note: Your text field will be weakly retained.

### Well, I care about a bit more
Okay then. We expose a callback to hand back the object from your list and even pass in the text field (if you gave us one) for added convenience:

```swift
//Though `FFSPicker` is generic, Swift lets you specify your concrete type in the callback.
func didSelect(thing: Foo, for textField: UITextField?) {
    //Your logic here
}

let picker = FFSPicker(withList: firstList, managing: firstTextField, callback: didSelect)
//Or if you've already initialized
picker.callback = didSelect
```

>Tip: By declaring a function as we show above you effectively create your own delegate method, which is why we don't provide a delegate protocol. Our pattern allows you the freedom to alternatively configure individual handlers for each of your pickers.

Since FFSPicker is all about reducing boilerplate, when you give us a text field we automatically configure the corresponding UIPickerView object as that field's `inputView`. But this may be overreaching in some cases, so you can disable that part of FFS while still letting us update your text field's text:

```swift
picker.shouldManageTextFieldInputView = false
```

### Storyboard
Already have a UIPickerView? That's cool too. The `init` optionally takes one to be used instead.

```swift
let picker = FFSPicker(withList: myList, wrapping: myPickerView)
//Then ask for it back like
picker.view
```

>Note: Your UIPickerView will be _strongly_ retained. But this shouldn't be a problem.

>Note: `FFSPicker` does not subclass `UIPickerView`, so you cannot use it on Storyboard directly.

## Installation
It's one source file so it hardly makes sense to build a framework for it. Still, I will probably support the usual dependency managers eventually. **Simply adding the source file to your project manually is likely the best choice though**. If you must build the framework, download/clone and drop the project file into your workspace for now.

[badge-tag]: https://img.shields.io/github/tag/nathanhosselton/FFSPicker.svg
[badge-language]: https://img.shields.io/badge/language-Swift-orange.svg
[badge-license]: https://img.shields.io/github/license/nathanhosselton/FFSPicker.svg
