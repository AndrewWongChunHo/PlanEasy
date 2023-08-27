//
//  StoreVM.swift
//  PlanEasy
//
//  Created by Croquettebb on 8/5/2023.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

class StoreVM: ObservableObject {
    
    
    @Published private(set) var subscriptions: [StoreKit.Product] = []
    @Published private(set) var purchasedSubscription: [StoreKit.Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    private let productIds: [String] = ["subscription.yearly"]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        updateListenerTask = listenserForTransaction()
        
        Task {
            await requestProducts()
            
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenserForTransaction() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("transaction failed verification")
                }
            }
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            subscriptions = try await StoreKit.Product.products(for: productIds)
            print(subscriptions)
        } catch {
            print("Failed product request from app store server: \(error)")
        }
    }
    
    func purchase(_ product: StoreKit.Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            await updateCustomerProductStatus()
            
            await transaction.finish()
            
            return transaction
            
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: {$0.id == transaction.productID}) {
                        purchasedSubscription.append(subscription)
                    }
                default:
                    break
                }
                await transaction.finish()
            } catch {
                print("failed updating products")
            }
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}
