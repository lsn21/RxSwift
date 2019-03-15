//
//  AppDelegate+rx.swift
//  RxCocoa
//
//  Created by SIARHEI LUKYANAU on 15.03.2019.
//  Copyright © 2019 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)

    import UIKit
    import RxSwift

    extension UIApplication: HasDelegate {
        public typealias Delegate = UIApplicationDelegate
    }

    public class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>, DelegateProxyType, UIApplicationDelegate {
        
        public init(application: UIApplication) {
            super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
        }
        
        public static func registerKnownImplementations() {
            self.register { RxUIApplicationDelegateProxy(application: $0) }
        }
    }

    extension Reactive where Base: UIApplication {
        public var delegate: RxUIApplicationDelegateProxy {
            return RxUIApplicationDelegateProxy.proxy(for: base)
        }
        
        public var didRegisterNotificationSettings: Observable<UIUserNotificationSettings> {
            return delegate.methodInvoked(#selector(UIApplicationDelegate.application(_:didRegister:))).map { a in
                    return try castOrThrow(UIUserNotificationSettings.self, a[1])
                }
        }
    }

    private func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
        if NSNull().isEqual(object) {
            return nil
        }
        
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }

#endif
