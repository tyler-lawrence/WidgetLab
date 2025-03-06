# WidgetLab

In this Lab we will learn how to make a simple static Widget for an existing iOS app. The basic app, CoffeeCounter, tracks how many cups of coffee a user consumes. 

https://github.com/user-attachments/assets/4d9a8d72-13aa-47c2-aecb-06bd72545d85
 

## 1. Setup persistence across targets
Before we get started with the widget we'll want to set up 
1. add capability: app group
![add-app-group](https://github.com/user-attachments/assets/f5bfe82e-ebfb-4c6b-a65f-95c5b500ed5f)

2. Create the app group.
Press the + button to create a new app group. A good convention to follow is start with *group* and then reverse domain matching your bundle. 

I'll name mine `group.com.academy.CoffeeCounter`

![create-group](https://github.com/user-attachments/assets/6d3bda76-f86c-4802-b00c-9b8b04df002e)

3. add the app group to your DataController (warning 1.3 in Xcode)

## 2. Create Widget Extension
- File > New > Target ... select Widget Extension
- Name it `CoffeesConsumedWidget`
- make sure the option *Include Configuration App Intent* is unchecked
- If you see a popup asking you to active the scheme, select Activate

## 3. Modify the sample code
Xcode provides some sample code for us. We'll modify the code they shared to fit our needs. Our goal is to have a simple static widget showing how many coffees have been consumed. The sample code is built around the idea of logging an emoji, which isn't too far from our purpose. 

1. Modify the `SimpleEntry` struct so it will show an Int representing coffees consumed.
  - Change `emoji: String` to `coffeesConsumed: Int`
  - We don't care about initializing a date so let's provide a default value. Change `date: Date` to `date: Date = Date.now`

We'll get some errors sprinkled throughout the file. That's fine, it actually helps us identify the places we need to update our code so our new struct is properly called.

2. Let's go to the `CoffeesConsumedWidgetView` and fix those errors.
  - This is where we design what the widget looks like. I'm going to keep it simple with a VStack and two Text views
```
VStack {
  Text("Coffees Consumed")
  Text(entry.coffeesConsumed.formatted())
}
```
3. Navigate to the Previews area and fix those errors. I'm going to put 2 and 4 as the values for coffeesConsumed
```
SimpleEntry(coffeesConsumed: 2)
SimpleEntry(coffeesConsumed: 4)
```

4. Now we'll move on to the `Provider` struct and fix those errors
  - in the `placeholder` method add a simpleEntry with an updated version `SimpleEntry(coffeesConsumed: 2)`
  - repeat in the `getSnapshot` method
  - we can simplify the `getTimeline` method a bit for our static widget. In our example, we're just showing the number of coffees consumed, we don't necessarily care about a timeline. We'll modify the method so the entries array just contains one SimpleEntry element
```
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
  let entry = SimpleEntry(coffeesConsumed: 2)
  let timeline = Timeline(entries: [entry], policy: .atEnd)
    completion(timeline)
}
```
Great! We can now preview our widget. If you want to run the simulator make sure to update the scheme at the top of Xcode (to the left of where you select your simulator). Currently, it will always show our placeholder values. Next we'll take a look at how to get the actual information we care about, total coffees consumed!

## 4. Replace the sample data with real coffees consumed
1.  We already have an object to track our data in `DataController`. Let's initialize a `DataController` in our Provider struct.
```
let dataController = DataController()
```
This will give us an error `Cannot find DataController in scope`. That's because our Widget is a new target that doesn't *know* about the other files in the app target. We can fix that by adding the necessary files to our Widget target

2. Navigate to the DataController file. In the file inspector (shown in the image below), press the plus button in the Target Membership section

![update-target](https://github.com/user-attachments/assets/5bf716f4-a55f-4ca9-ab35-637730578ec9)

Check the box for `CoffeesConsumedWidgetExtension`. Now our widget target knows about our DataController class. 

3. Update all the calls to SimpleEntry.
   - now that we have a DataController we can access our coffeesConsumed property instead of hardcoding a value into the SimpleEntry
   - replace all occurrences of SimpleEntry with `SimpleEntry(coffeesConsumed: dataController.coffeeCount)`

Let's try running the simulator. If everything works we would expect our widget to show us the same number as our ContentView shows us. However, we're still seeing a 0 in our widget. This is where we'll bring in the work we started in step 1.

4. Add a capability to our WidgetExtension target.
  - This is the same process as step one, but make sure you have the CoffeesConsumedWidgetExtension selected.
![add-app-group-to-widget-target](https://github.com/user-attachments/assets/acfd3ff2-7859-4b86-81d3-a6b374528eb5)
In the App Groups section, you should see the group we created in step 1.2. Check that box. 
![add-target](https://github.com/user-attachments/assets/c79a18c6-f2bc-4ac7-8e58-b14007bd31a8)

Great! Now our widget target and our app target are accessing the same app group. However, there's one more step to complete. Currently the widget isn't responding to changes when we interact with the app in ContentView. 

5. Tell our widget to update
 - Navigate to DataController file
 - import WidgetKit
 - add this line to the `incrementCoffeeCount` method
 ```
WidgetCenter.shared.reloadAllTimelines()
```
Now every time we call the `incrementCoffeeCount` method, we'll tell our widget that it should reload the timeline which will then get the correct information to display in the widget.

### Resources 
Below are the resources I used when creating this activity
- [WWDC 23 - Bring Widgets to LIfe](https://developer.apple.com/videos/play/wwdc2023/10028)
- Paul Hudson, HWS+ Creating a Simple Widget (can't share link)
- [Developer Documentation - Creating a Widget Extension](https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension)
