#Why

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