import Flutter
import FirebaseMessaging
import Firebase
import CoreMotion
import CallKit

@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "swiftTimer", binaryMessenger: controller.binaryMessenger)
        
        var isOnPhoneCall: Bool {
            return CXCallObserver().calls.contains { $0.hasEnded == false }
        }
        
        var count = 0
        var lastActive = Date()
        var lastBackground = Date()
        var lastInactive = Date()
        
        channel.setMethodCallHandler({
            [unowned self] (methodCall, result) in
            if methodCall.method == "swift-sendNotification"
            {
                // Get back to Sloff notification
                let center = UNUserNotificationCenter.current()
                
                center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in})
                
                let content = UNMutableNotificationContent()
                content.title = "I see you! 👀"
                content.body = "Return to Sloff, or you'll lose your focus."
                
                let date = Date().addingTimeInterval(5)
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                // let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: "exit-notification", content: content, trigger: trigger)
                
                
                // Handle application state changes
                switch application.applicationState {
                case .active:
                    print("statusACTIVE " + Date().description)
                    count = 0
                    result("")
                    lastActive = Date()
                    
                    break
                case .inactive:
                    print("statusINACTIVE " + Date().description)
                    lastInactive = Date()
                    
                    if count < 1
                    {
                        center.add(request) { (error) in}
                        count += 1

                        result("EXIT-NOTIFICATION")
                    }
                    break
                case .background:
                    print("statusBACKGROUND " + Date().description)
                    lastBackground = Date()
                    
                    if count < 1
                    {
                        if Date() > lastActive.addingTimeInterval(4) && !isOnPhoneCall
                        {
                            center.add(request) { (error) in}
                            count += 1
                            
                            result("EXIT-NOTIFICATION")
                        } else {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["exit-notification"])
                            result("")
                            print("CANCELLED NOTIFICATION")
                        }
                    }
                    break
                default:
                    break
                }
            }
        })
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
