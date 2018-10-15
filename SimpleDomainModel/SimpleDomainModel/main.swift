//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  
  public func convert(_ to: String) -> Money {
    if self.currency == to {
      return Money(amount: self.amount, currency: self.currency)
    }
    switch self.currency {
    case "USD":
      switch to {
      case "GBP":
        return Money(amount: Int(Double(self.amount) * 0.5), currency: "GBP")
      case "EUR":
        return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR")
      case "CAN":
        return Money(amount: Int(Double(self.amount) * 1.25), currency: "CAN")
      default:
        return Money(amount: 0, currency: self.currency)
      }
    case "GBP":
      switch to {
      case "USD":
        return Money(amount: Int(Double(self.amount) * 2), currency: "USD")
      case "EUR":
        return Money(amount: Int(Double(self.amount) * 3), currency: "EUR")
      case "CAN":
        return Money(amount: Int(Double(self.amount) * 2.5), currency: "CAN")
      default:
        return Money(amount: 0, currency: self.currency)
      }
    case "EUR":
      switch to {
      case "USD":
        return Money(amount: Int(Double(self.amount) * 2/3), currency: "USD")
      case "GBP":
        return Money(amount: Int(Double(self.amount) / 3), currency: "GBP")
      case "CAN":
        return Money(amount: Int(Double(self.amount) * 5/6), currency: "CAN")
      default:
        return Money(amount: 0, currency: self.currency)
      }
    case "CAN":
      switch to {
      case "USD":
        return Money(amount: Int(Double(self.amount) * 0.8), currency: "USD")
      case "GBP":
        return Money(amount: Int(Double(self.amount) / 2.5), currency: "GBP")
      case "EUR":
        return Money(amount: Int(Double(self.amount) * 6/5), currency: "EUR")
      default:
        return Money(amount: 0, currency: self.currency)
      }
    default:
      return Money(amount: 0, currency: self.currency)
    }
  }
  
  public func add(_ to: Money) -> Money {
    return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    return Money(amount: self.convert(from.currency).amount - from.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case JobType.Hourly(let amt):
      return Int(amt * Double(hours))
    case JobType.Salary(let amt):
      return amt
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case JobType.Hourly(let Oamt):
      self.type = JobType.Hourly(Oamt + amt)
    case JobType.Salary(let Oamt):
      self.type = JobType.Salary(Int(Double(Oamt) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {return _job }
    set(value) {
      if self.age <= 16 {
        return
      }
    _job = value
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {return _spouse }
    set(value) {
      if self.age <= 18 {
        return
      }
      _spouse = value
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    self.members.append(spouse1)
    self.members.append(spouse2)
  
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if self.members[1].age < 21 && self.members[2].age < 21 {
      return false
    }else{
      self.members.append(child)
      return true
    }
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for i in members {
      if let myJob = i.job {
        switch myJob.type {
        case Job.JobType.Hourly(let Oamt):
          income += Int(Oamt * Double(2000))
        case Job.JobType.Salary(let Oamt):
          income += Oamt
        }
      }
    }
    return income
  }
}






