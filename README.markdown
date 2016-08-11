#FFSPicker
![badge-tag] ![badge-language] ![badge-license]  
_Delegation is alright in its place, but_ [sometimes] _its place is in hell._

FFSPicker is a wrapper for your UIPickerViews. It handles the most common delegation patterns so your view controllers don't have to.
##Why

Sometimes you need a picker for the input of a text field.

```swift
textField = //...
picker = //...

picker.dataSource = self
picker.delegate = self
textField.inputView = picker

//...

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

Then, some of those times you need multiple pickers.

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

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView {
    case picker1:
        return firstSelections[row]
    case picker2:
        return secondSelections[row]
	case picker 3:
		return thirdSelections[row]
    default:
        return ""
    }
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView {
    case picker1:
        textField.text = firstSelections[row]
    case picker2:
        textField.text = secondSelections[row]
	case picker 3:
		textField.text = thirdSelections[row]
    default:
        break
    }
}
```

**...**

#FFS
All you care about is shoving some data into a picker and knowing which item the user selected.

```swift
picker1 = FFSPicker(withList: firstList, callback: { [unowned self] in self.textField1.text = $0 })
picker2 = FFSPicker(withList: secondList, callback: { [unowned self] in self.textField2.text = $0 })
picker3 = FFSPicker(withList: thirdList, callback: { [unowned self] in self.textField3.text = $0 })

for (textField, picker) in [(textField1, picker1), (textField2, picker2), (textField3, picker3)] {
	textField.inputView = picker.view
}
```

*Better.*

###Better yet...

Not interested in anything else in your closure? Screw it. Just give your picker a text field and it'll update the text for you.
```swift
picker = FFSPicker(withList: myList)
picker.textField = textField
textField.inputView = picker.view
```
> Note: Your text field will be weakly retained

###Storyboard
Already got a picker view? That's cool too. The `init` optionally takes one to be used instead.
```swift
picker = FFSPicker(withList: myList, view: myPickerView)
```
> Note: Your picker view will be **_strongly_** retained. But this shouldn't be a problem.  
> Note: `FFSPicker` does not subclass `UIPickerView`, so you cannot use it on storyboard directly.

#Installation
It's one file so it hardly makes sense to build a framework for it. Still, I will probably support the usual dependency managers by v1.0. **Simply adding the source file to your project manually is likely the best choice**. If you must build the framework, download/clone and drop the project file into your workspace for now.

##Oh, about 1.0.0
I've got some more things I'm thinking about adding in for that milestone, like automatic support for additional components and Objective-C bridging. Until then, **any tagged commit is a tested/safe release**. This is just a pet project so there is no timeline. PRs are always welcome.

[badge-tag]: https://img.shields.io/github/tag/nathanhosselton/FFSPicker.svg
[badge-language]: https://img.shields.io/badge/language-Swift-orange.svg
[badge-license]: https://img.shields.io/github/license/nathanhosselton/FFSPicker.svg