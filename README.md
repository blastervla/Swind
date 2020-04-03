# Swind
Databinding for Swift iOS projects, made simple

Minimum requirement:  
![iOSVersion](https://img.shields.io/badge/iOS-10-brightgreen.svg) 
![SwiftVersion](https://img.shields.io/badge/Swift-5-brightgreen.svg) 
![XcodeVersion](https://img.shields.io/badge/Xcode-10-brightgreen.svg)  

## About
Swind is a databinding library intended for Swift. Simple and powerful,
Swind will help you do everything you need to, without all the tedious
boilerplate code you usually need to write to update your views.

Natively supporting MVVM, Swind hooks right in between your View and
ViewModel, simplyfing your life and keeping MVVM's separation of
concerns intact. That way you can worry only about creating great
code, while Swind helps you respect your architecture in a comfortable
way.

## Usage
Using Swind is simple. You don't need to change anything about your view,
Swind will work with all natively supported controls. Just make sure your
ViewController conforms to the `BaseViewProtocol` protocol, create a
Binder for it that conforms to the `BaseBinderProtocol` protocol and
write all your binding logic in its `bind` method. That's it!

Take the following example, for a view containing a `UITextField` and a
`UILabel`.

```
class MyController: UIViewController, BaseViewProtocol {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!

    var viewModel = MyViewModel()
    // ...

    override func viewDidLoad() {
        super.viewDidLoad()

        MyControllerBinder.bind(parent: self, view: self, viewModel: viewModel)
    }
}
```

With the given ViewModel
```
class MyViewModel: BaseViewModel {
    var name: String = ""
    var message: String = ""

    // ...

    var messageForDisplay: String {
        return "Hi \(self.name), welcome back to the BatCave."
    }

    @objc func setNewName(_ text: String) {
        self.name = text
        
        // Call this whenever the ViewModel's state changed,
        // this will notify the view.
        self.notifyChange()
    }
}
```

Now, with our view setup, we just need to write the binding logic. We
create the `MyControllerBinder` class:

```
class MyControllerBinder: BaseBinderProtocol {
    static func bind(parent: BaseViewProtocol, view: Any, viewModel: MyViewModel) {
        guard let view = view as? MyController, let viewModel = viewModel as? RobotModel else { return }

        view.nameTextField.swind_bindForTextChange(viewModel, #selector(viewModel.setNewName))
        // We could have also used view.nameTextField.swind_onTextChange = { ... } 
        // closure. This is more flexible, but less clean than using the 
        // swind_bindForTextChange method.

        // Setup this closure for properties that should be updated whenever the
        // ViewModel's state changes
        viewModel.onChange {
            view.messageLabel.text = viewModel.messageForDisplay
        }

        // Call this once to ensure view is correctly initialized
        viewModel.notifyChange()
    }
}
```

And that's it! The message is now automatically binded to whatever text
we want to display through the ViewModel, and is responsive to any change
in the Name UITextField! Simple as that.

All controls have different binding methods, depending on their general
usage, and allow for further flexibility through their different closures.
Just type `swind_` and check out what each view can do! Even natively inert
views such as UIImageView (or any generic UIView itself!) have binding
options.

## Instalation

Through cocoapods, instalation is simple.
Just add the following line to your podfile:
```
pod 'Swind'
```

## Where to go from here?

You should definitely check out Swind's [documentation](http://TODO.ADD.ME)
for further reference!

## License

Swind uses the Creative Commons Attribution 4.0 International Public License.
Check out the included [LICENSE file](https://raw.githubusercontent.com/blastervla/Swind/master/LICENSE)