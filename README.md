![Model2App: Turn your Swift data model into a working CRUD app.](https://raw.githubusercontent.com/Q-Mobile/Model2App/master/logo.png)

<p align="center">
    <a href="https://travis-ci.org/Q-Mobile/Model2App"><img src="https://img.shields.io/travis/Q-Mobile/Model2App.svg?style=flat" alt="CI Status"/></a>
    <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
    <img src="https://img.shields.io/badge/Swift-4.2-orange.svg" />
    <a href="https://cocoapods.org/pods/Model2App"><img src="https://img.shields.io/cocoapods/v/Model2App.svg?style=flat" alt="Version" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat" alt="Carthage" /></a>
    <a href="https://raw.githubusercontent.com/q-mobile/Model2App/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
    <a href="https://twitter.com/karolkulesza"><img src="https://img.shields.io/badge/contact-@karolkulesza-blue.svg?style=flat" alt="Twitter: @karolkulesza" /></a>
</p>

`Model2App` is a simple library that lets you quickly generate a `CRUD` iOS app based on just a data model defined in Swift. (`CRUD` - Create Read Update Delete). Ever wanted to quickly validate a data model for your next awesome iOS app? `Model2App` lets you save hours/days by generating a fully working app with persistence layer, validation and many more features. Just define your model, hit `⌘ + R` and enjoy your app. 😎

`Model2App` uses [Realm](https://github.com/realm/realm-cocoa) ❤️ under the hood and can be treated as its extension in development activities, especially in the phase of defining or validating a data model for a bigger project.

<center>
<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Demo/Model2App_Demo.gif"/>
</center>


## 🔷 Features

#### ✴️ Automatically generate:  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ App menu based on a list of classes defined by your app  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Objects list views, per each model class    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Dynamic object view for creating, updating and viewing objects of a given class, based on list of model properties   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Object property cells, based either on property type or on declared control type (see supported control types below)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Logic to handle different control types to change the values of object properties  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Validation logic for creating/updating objects using set of predefined rules or custom one using a closure  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Logic for persisting created objects in local storage (`Realm`)     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Logic for invoking object update session and deleting objects   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Logic for setting relationships between objects, in case of `Object` properties  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Related objects' sections for objects which are referenced by other objects (inverse relationships)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Logic for creating a related object from a given object view  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Logic to traverse (infinitely) between related objects   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Out of the box zoom-in & zoom-out navigation animations  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ & a bunch of many more small features

#### ✴️ Customize default app configuration:  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Adjust app menu (layout, order, background, menu items' icons/layout/alphas, font names/sizes/colors, animations and more)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Pick any menu item icon from provided bundle (`MenuIcons`), provide your own, or let `Model2App` pick one for you  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Adjust objects list views (cell layout/background, displayed object properties, images layout, animations and more)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Adjust object view property cells (cell layout/background, font names/sizes/colors, images layout, placeholders and more)    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Adjust object view Related Objects' headers (header layout/background, font names/sizes/colors)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Adjust picker list views (cell layout/background, font names/sizes/colors)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Hide a specific class from app menu or hide a specific property of a given class from object view  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Adjust default animation configuration: presentation/dismissal animation duration, damping ratio or initial spring velocity  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Specify whether image views presented in cells should be rounded or not  

#### ✴️ Other features:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Supports both iPhones and iPads  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Supports both portrait and landscape orientations  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Validates your data model for declared relationships and declared control types for properties  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Enables using emoji character for menu icon image   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Flexibility & Extensibility: Apart from configuration parameters defined in `M2AConfig` class which can be overridden, most of the classes & methods used for core app features have `open` access modifier, so you can customize or extend selected parts of `Model2App` framework in your app

#### ✴️ Supported control types:  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `TextField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `NumberField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `FloatDecimalField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `DoubleDecimalField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `CurrencyField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `PhoneField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `EmailField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `PasswordField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `URLField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `ZIPField`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `Switch`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `DatePicker`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `TimePicker`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `DateTimePicker`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `TextPicker`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `ObjectPicker`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✏️ `ImagePicker`  


## 🔷 Requirements

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Xcode 10.1+  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✅ Swift 4.2+


## 🔷 Installation

`Model2App` is available through both [CocoaPods](https://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).

#### ✴️ CocoaPods

In order to install `Model2App` via CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'Model2App'
```

Then run the following command:

```bash
$ pod install
```

#### ✴️ Carthage

In order to install `Model2App` via Carthage, simply add the following line to your Cartfile:

```ogdl
github "Q-Mobile/Model2App" ~> 0.1.0
```

Then run the following command:

```bash
$ carthage update
```

Please remember to add all `*.framework` files from `Carthage/Build/*` to your project (Not only `Model2App.framework`), apart from other standard steps for [Carthage](https://github.com/Carthage/Carthage#quick-start)

## 🔷 Usage

#### ✴️ Model definition:  

After installing `Model2App`, simply define your data model by subclassing `ModelClass`, as in example below or as in example app available in this repo (`Model2AppTestApp`) and hit `⌘ + R`. (NOTE: Sample data model visible below is just a small excerpt from the example app, please refer to `Model2AppTestApp` source for a more extended model)

```swift
@objcMembers class Company : ModelClass {
    dynamic var name : String?
    dynamic var phoneNumber : String?
    dynamic var industry : String?
}

@objcMembers class Person : ModelClass {
    dynamic var firstName : String?
    dynamic var lastName : String?
    dynamic var salutation : String?
    dynamic var phoneNumber : String?
    dynamic var privateEmail : String?
    dynamic var workEmail : String?
    let isKeyOpinionLeader = OptionalProperty<Bool>()
    dynamic var birthday : Date?
    dynamic var website : String?
    dynamic var note : String?
    dynamic var picture : Data?
    dynamic var company : Company?
}

@objcMembers class Deal : ModelClass {
    dynamic var name : String?
    let value = OptionalProperty<Int>()
    dynamic var stage : String?
    dynamic var closingDate : Date?
    dynamic var company : Company?
}      
```

#### ✴️ Customizing default model configuration:

If you'd like to customize the default class/property configuration, simply override some or all of the computed type properties defined by `ModelClass`:

```swift
@objcMembers class Company : ModelClass {
    // (model properties defined earlier)

    override class var pluralName: String { return "Companies" }
    override class var menuIconFileName: String { return "users" }
    override class var menuOrder: Int { return 2 }
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("employees", sourceType: Person.self, sourceProperty: #keyPath(Person.company)),
            InverseRelationship("deals", sourceType: Deal.self, sourceProperty: #keyPath(Deal.company))
        ]
    }

    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(name) : PropertyConfiguration(
                placeholder: "Enter company name",
                validationRules: [.Required]
            ),
            #keyPath(phoneNumber) : PropertyConfiguration(
                placeholder: "Enter phone number"
            ),
            #keyPath(industry) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Consulting", "Education", "Financial Services", "Government", "Manufacturing", "Real Estate", "Technology", "Other"]
            )
        ]
    }
}

@objcMembers class Person : ModelClass {
    // (model properties defined earlier)

    override class var pluralName: String { return "People" }
    override class var menuIconFileName: String { return "user-1" }
    override class var menuIconIsFromAppBundle: Bool { return true }
    override class var menuOrder: Int { return 1 }

    override class var listViewCellProperties: [String] {
        return [#keyPath(picture), #keyPath(firstName), #keyPath(lastName)]
    }

    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10-[picture]-[firstName]-5-[lastName(>=50)]-|" // OR: (with slightly weaker readability but more safe): "H:|-10-[#keyPath(picture)]-[#keyPath(firstName)]-5-[#keyPath(lastName)(>=50)]"
        ]
    }

    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(firstName) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter first name",
                validationRules: [.Required]
            ),
            #keyPath(lastName) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter last name",
                validationRules: [.Required]
            ),
            #keyPath(salutation) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Mr.", "Ms.", "Mrs.", "Dr.", "Prof."],
                validationRules: [.Required]
            ),
            #keyPath(phoneNumber) : PropertyConfiguration(
                controlType: .PhoneField,
                placeholder: "Enter phone number",
                validationRules: [.MinLength(length: 9), .MaxLength(length: 12)]
            ),
            #keyPath(privateEmail) : PropertyConfiguration(
                controlType: .EmailField,
                placeholder: "Enter email address",
                validationRules: [.Email]
            ),
            #keyPath(workEmail) : PropertyConfiguration(
                controlType: .EmailField,
                placeholder: "Enter email address",
                validationRules: [.Required, .Email, .Custom(isValid: { object in
                    if let workEmail = object[#keyPath(workEmail)] as? String,
                       let privateEmail = object[#keyPath(privateEmail)] as? String,
                       workEmail == privateEmail {
                            UIUtilities.showValidationAlert("Work Email cannot be the same as Private Email.")
                            return false
                    }
                    return true
                })]
            ),
            #keyPath(birthday) : PropertyConfiguration(
                controlType: .DatePicker,
                validationRules: [.Required]
            ),
            #keyPath(website) : PropertyConfiguration(
                controlType: .URLField,
                placeholder: "Enter URL",
                validationRules: [.URL]
            ),
            #keyPath(note) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter note",
                validationRules: [.MaxLength(length: 1000)]
            ),
            #keyPath(company) : PropertyConfiguration(
                validationRules: [.Required]
            ),
            #keyPath(picture) : PropertyConfiguration(
                controlType: .ImagePicker
            )
        ]
    }
}

@objcMembers class Deal : ModelClass {
    // (model properties defined earlier)

    override class var pluralName: String { return "Deals" }
    override class var menuIconFileName: String { return "money" }

    override class var listViewCellProperties: [String] {
        return [#keyPath(name), "value", #keyPath(stage)]
    }

    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10@750-[name(>=50)]-(>=10)-[value(>=50)]-|",
            "H:|-10@750-[stage]-(>=10)-[value]",
            "V:|-10@750-[value]-10@750-|",
            "V:|-10@750-[name]-[stage]-|"
        ]
    }

    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(name) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter deal name",
                validationRules: [.Required]
            ),
            "value" : PropertyConfiguration(
                controlType: .CurrencyField,
                placeholder: "Enter deal value",
                validationRules: [.Required]
            ),
            #keyPath(stage) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Prospecting", "Qualified", "Reviewed", "Quote", "Won", "Lost"],
                validationRules: [.Required]
            ),
            #keyPath(company) : PropertyConfiguration(
                validationRules: [.Required]
            )
        ]
    }
}      
```

#### ✴️ Customizable `ModelClass` type properties:  

✏️ `displayName` - Display name of this class. If not provided, inferred from the class name  
✏️ `pluralName` - Plural name of this class. Used to name list of objects or menu items. If not provided, `<ClassName> - List` is used  
✏️ `menuIconFileName` - Name of the image file used for menu icon in root menu of the app  
✏️ `menuIconIsFromAppBundle` - Specifies whether `Model2App` should look for menu icon file in main app bundle. If `false`, `Model2App`'s bundle will be used  
✏️ `menuOrder` - Order of menu item for this class in root menu of the app  
✏️ `propertyConfigurations` - Dictionary of property configurations for this class  
✏️ `inverseRelationships` - List of inverse relationships for this class (Should be defined if there are any `to-one` relationships from other classes and if you would like to present a section of related objects)  
✏️ `listViewCellProperties` - List of properties used in list view cell's for this class. Should contain all properties specified in `listViewCellLayoutVisualFormats`  
✏️ `listViewCellLayoutVisualFormats` - List of visual formats for list view cell layout, using Apple's Auto Layout Visual Format Language  
✏️ `isHiddenInRootView` - Specifies whether a given model class should be hidden in root menu of the app (Useful in case of child entities that should only be displayed in related objects section, for a given object)  


#### ✴️ `PropertyConfiguration`'s properties:  

✏️ `controlType` - Specifies the type of UI control used for this property  
✏️ `placeholder` - Specifies the placeholder value used when no value is provided for this property  
✏️ `pickerValues` - Specifies the list of potential picker values for this property. Valid only for `TextPicker` ControlType  
✏️ `validationRules` - Specifies the list of validation rules for this property (evaluated when creating a new object of this class)  
✏️ `isHidden` - Specifies whether this property should be hidden on UI  


#### ✴️ Supported validation rules (`ValidationRule`):  

✏️ `Required`  
✏️ `MinLength(length: Int)`   
✏️ `MaxLength(length: Int)`  
✏️ `MinValue(value: Double)`   
✏️ `MaxValue(value: Double)`   
✏️ `Email`   
✏️ `URL`   
✏️ `Custom(isValid: (ModelClass) -> Bool)`   


#### ✴️ Customizing default app configuration:

`M2AConfig` class defines default app configuration that can be optionally subclassed by the app. Please refer to both `M2AConfig` class source and `AppConfig.swift` file in `Model2AppTestApp` example app.

#### ✴️ Remarks for model definition:

* As highlighted above, `Model2App` uses [Realm](https://github.com/realm/realm-cocoa) under the hood, so it has similar considerations as for the model definition:
	* All property attributes must follow the rules specified in Realm documentation: [https://realm.io/docs/swift/latest#property-cheatsheet](https://realm.io/docs/swift/latest#property-cheatsheet). In a nutshell, all model properties should be declared as `@objc dynamic var` (or just `dynamic var` if the class itself is declared using `objcMembers`), except for the `OptionalProperty` (used for numbers/bool), which should be declared using just `let`.
	* String, Date and Data properties can be optional. Object properties (defining relationships) must be optional. Storing optional numbers is done using `OptionalProperty` (alias for Realm's `RealmOptional`).


## 🔷 Example App

📱`Model2AppTestApp` directory in this repo contains an example app that defines a very simple CRM-related data model. Open `Model2AppTestApp/Model2AppTestApp.xcworkspace` and run this test app to see what are the effects of applying `Model2App` library to a sample data model.


<center>
<table bordercolor=white>
  <tr>
    <th>
      <img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/AppMenu.png" width="240"/>
    </th>
    <th>
      <img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ListView_People.png" width="240"/>
    </th>
    <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ListView_Companies.png" width="240"/>
    </th>
  </tr>
</table>
<table bordercolor=white>
  <tr>
	 <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ListView_Products.png" width="240"/>
    </th>
    <th>
      <img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ListView_Activities.png" width="240"/>
    </th>
    <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ListView_Deals.png" width="240"/>
    </th>
  </tr>
</table>
<table bordercolor=white>
  <tr>
	 <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/NewObjectView_Person.png" width="240"/>
    </th>
    <th>
      <img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Company.png" width="240"/>
    </th>
    <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Person.png" width="240"/>
    </th>
  </tr>
</table>
<table bordercolor=white>
  <tr>
	 <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Product.png" width="240"/>
    </th>
    <th>
      <img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Activity_CreateNewRelatedObject.png" width="240"/>
    </th>
    <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Company_CreateNewRelatedObject.png" width="240"/>
    </th>
  </tr>
</table>
<table bordercolor=white>
  <tr>
	 <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Person_DateEdit.png" width="240"/>
    </th>
    <th>
      <img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_PersonPhotoEdit.png" width="240"/>
    </th>
    <th>
    	<img src="https://raw.githubusercontent.com/Q-Mobile/Model2App/master/Model2AppTestApp/Screenshots/ObjectView_Deal_PriceEdit.png" width="240"/>
    </th>
  </tr>
</table>
</center>



## 🔷 Limitations / Known Issues

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⚠️ Version `0.1.0` of `Model2App` does not handle data model migrations, so if you change your data model after the initial app launch, you'll get an error and will have to remove the app, prior the next launch, in order to see the updated model. Handling model migrations is planned in Roadmap for future releases.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⚠️ In case of `OptionalProperty` properties you cannot use `#keyPath` to safely reference a given property (for example from `propertyConfigurations` or `listViewCellProperties` definition)


## 🔷 Roadmap / Features for Future Releases

Version `0.1.0` of `Model2App` contains a limited set of features. There are many functionalities that could extend its value:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Searching on object list views  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Filtering on object list views  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Sorting on object list views   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Handling cascade deletions   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Handling model migrations  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Support for control type: “Slider"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Support for control type: “TextView"    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Support for control type: “Button"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Support for one-to-many relationships (so far only inverse one-to-many relationships are supported)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ Option to use emoji as menu item icon, instead of images  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☘️ ... and many more! Stay tuned! ❤️


## 🔷 Contributing

👨🏻‍🔧 Feel free to contribute to `Model2App` by creating a pull request, following these guidelines:

1. Fork `Model2App`
2. Create your feature branch
3. Commit your changes, along with unit tests
4. Push to the branch
5. Create pull request


## 🔷 Credits / Acknowledgments

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;🎨 Icons used by `Model2App` were designed by Lucy G from [Flaticon](https://www.flaticon.com/)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;💚 Special thanks to all the people behind [Realm](https://github.com/realm/realm-cocoa)


## 🔷 Author

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;👨‍💻 [Karol Kulesza](https://github.com/karolkulesza) ([@karolkulesza](https://twitter.com/karolkulesza))


## 🔷 License

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;📄 Model2App is available under the MIT license. See the LICENSE file for more info.
