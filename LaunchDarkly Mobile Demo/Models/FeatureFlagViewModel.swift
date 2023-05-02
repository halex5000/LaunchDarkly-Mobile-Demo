//
//  FeatureFlagProvider.swift
//  LaunchDarkly Mobile Demo
//
//  Created by Alex Hardman on 5/1/23.
//

import Foundation
import LaunchDarkly

class FeatureFlagViewModel: ObservableObject {
    @Published var isNewStoreExperience = false
    @Published var isPaymentEnabled = false
    @Published var isGogglesEnabled = false
    @Published var isTogglesEnabled = false
    @Published var isFeaturedEnabled = false
    @Published var isLoggedIn = false
    
    @Published var loggedInUser = "anonymous"
    
    let isStoreEnabledKey = "storeEnabled"
    let isNewBillingUI = "billing"
    let isStripeEnabled = "enableStripe"
    let productExperience = "new-product-experience-access"
    let featuredProductLabel = "featured-product-label"
    
    let config = LDConfig(mobileKey: "mob-5af368e3-9b18-4f21-9b95-02cb9333d479")
    
    func loginDevTester() {
        login(username: "alex9000")
        loggedInUser = "Alex - Dev Tester"
    }
    
    func loginBasicUser() {
        login(username: "literally-anyone-but-alex")
        loggedInUser = "Cody"
    }
    
    func login(username: String) {
        isLoggedIn = true
        do {
            var builder = LDContextBuilder()
            builder.trySetValue("username", LDValue(stringLiteral: username))
            builder.trySetValue("device", "iPhone")
            builder.trySetValue("version", "2.0")
            let newContext = try builder.build().get()
            LDClient.get()!.identify(context: newContext)
            print(LDClient.get()!.getConnectionInformation())
            print("successfully changed context in login")
        } catch let error {
            print("do absolutely nothing, it's all going to be okay", error)
        }
    }
    
    func logout() {
        isLoggedIn = false
        loggedInUser = "anonymous"
        do {
            print("logging out")
            var builder = LDContextBuilder()
            builder.anonymous(true)
            builder.trySetValue("device", "iPhone")
            builder.trySetValue("version", "2.0")
            let newContext = try builder.build().get()
            LDClient.get()!.identify(context: newContext)
            print("successfully changed context")
        } catch let error {
            print("do absolutely nothing, it's all going to be okay", error)
        }
    }
    
    init() {
        var contextBuilder = LDContextBuilder()
        contextBuilder.trySetValue("device", "iPhone")
        contextBuilder.trySetValue("version", "2.0")
        contextBuilder.anonymous(true)
        contextBuilder.kind("user")
        guard case .success(let context) = contextBuilder.build()
        else {return}

        LDClient.start(config: config, context: context, startWaitSeconds: 10) { timedOut in
            if timedOut {
                print("timed out")
            } else {
                print("Successfully started LaunchDarkly")
            }
        }
        
        isNewStoreExperience = LDClient.get()!.boolVariation(forKey: isStoreEnabledKey, defaultValue: false)
        isPaymentEnabled = LDClient.get()!.boolVariation(forKey: isStripeEnabled, defaultValue: false)
        print("is payment enabled?:" + String(isPaymentEnabled))
        
        isGogglesEnabled = LDClient.get()!.stringVariation(forKey: productExperience, defaultValue: "toggle").contains("goggle")
        isTogglesEnabled = LDClient.get()!.stringVariation(forKey: productExperience, defaultValue: "toggle").contains("toggle")
        
        print("is goggles enabled: " + String(isGogglesEnabled))
        print("is toggles enabled: " + String(isTogglesEnabled))
        
        isFeaturedEnabled = !LDClient.get()!.stringVariation(forKey: featuredProductLabel, defaultValue: "").isEmpty
        
        print("is featured enabled?: " + String(isFeaturedEnabled))
        print("featured product label: " + LDClient.get()!.stringVariation(forKey: featuredProductLabel, defaultValue: "None"))
        
        LDClient.get()!.observe(keys: [isStoreEnabledKey, isStripeEnabled, productExperience, featuredProductLabel], owner: self, handler: { [self] changedFlags in
            if changedFlags[isStoreEnabledKey] != nil {
                isNewStoreExperience = LDClient.get()!.boolVariation(forKey: isStoreEnabledKey, defaultValue: false)
            }
            
            if changedFlags[isStripeEnabled] != nil {
                isPaymentEnabled = LDClient.get()!.boolVariation(forKey: isStripeEnabled, defaultValue: false)
                
                print("is payment enabled changed to: " + String(isPaymentEnabled))
            }
            
            if changedFlags[productExperience] != nil {
                isGogglesEnabled = LDClient.get()!.stringVariation(forKey: productExperience, defaultValue: "toggle").contains("goggle")
                isTogglesEnabled = LDClient.get()!.stringVariation(forKey: productExperience, defaultValue: "toggle").contains("toggle")
                print("is goggles enabled: " + String(isGogglesEnabled))
                print("is toggles enabled: " + String(isTogglesEnabled))
            }
            
            if changedFlags[featuredProductLabel] != nil {
                print("featured flag changed to: " + LDClient.get()!.stringVariation(forKey: featuredProductLabel, defaultValue: ""))
                isFeaturedEnabled = !LDClient.get()!.stringVariation(forKey: featuredProductLabel, defaultValue: "").isEmpty
            }
        })
    }
    
//    LDClient.get()!.observe(keys: flagKeys, owner: isNewStoreExperience as LDObserverOwner, handler: { [self] changedFlags in
//        if changedFlags["storeEnabled"] != nil {
//            print("something changed")
//            let something = LDClient.get()!.boolVariation(forKey: "storeEnabled", defaultValue: false)
//            print("the new value is: ", something)
//            isNewStoreExperience = something
//        }
//    })
    
//    func fetchFeatureFlag() {
//        // Evaluate the "my-feature-flag" feature flag using the LaunchDarkly client
////        let flagValue = LDClient.get.variation(forKey: newStoreExperienceFlagKey, defaultValue: false)
////
////        // Update the value of isFeatureEnabled based on the flag value
////        isFeatureEnabled = flagValue
//    }
    
//    func setupLDClient() {
//        var contextBuilder = LDContextBuilder(key: "context-key-123abc")
//
//        contextBuilder.trySetValue("firstName", .string("Alex"))
//        contextBuilder.trySetValue("lastName", .string("Hardman"))
//        contextBuilder.trySetValue("groups", .array([.string("beta-testers")]))
//
//        guard case .success(let context) = contextBuilder.build()
//        else {return}
//
//        var config = LDConfig(mobileKey: "mob-5af368e3-9b18-4f21-9b95-02cb9333d479")
//        config.eventFlushInterval = 30.0
//
//        if !isInitialized {
//            print("setting up the LD client, wish me luck!")
//            isInitialized = true;
//            LDClient.start(config: config, context: context, startWaitSeconds: 5) { timedOut in
//                if timedOut {
//                    print("timed out")
//                } else {
//                    print("successfully initialized")
//                }
//            }
//        }
//    }
}
