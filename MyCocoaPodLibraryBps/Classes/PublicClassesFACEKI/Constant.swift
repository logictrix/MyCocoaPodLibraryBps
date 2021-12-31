//
//  Constant.swift
//
//

import UIKit

let objUser = UserData()

//let bundlePath = Bundle(forClass: GANavigationMenuViewController.self).pathForResource("resources", ofType: "bundle")
//let bundle = Bundle(path: bundlePath!)

let frameworkImageBundle = Bundle(for: Logger.self)
let pathImage = frameworkImageBundle.path(forResource: "Resources", ofType: "bundle")
let resourcesBundleImg = Bundle(url: URL(fileURLWithPath: pathImage!))

let frameworkBundle = Bundle(identifier: "org.cocoapods.MyCocoaPodLibraryBps")
let Storyboard = UIStoryboard(name: "MainFACEKI", bundle: frameworkBundle)
let userDefault = UserDefaults.standard

let NoImageAlert = "Please select Image to add."
let Ok = "Ok"
let cancel = "Cancel"
let Camera = "Camera"
let appName = "FACEKI"
let noCamera = "You don't have camera"
let noInternet = "There is no internet Connection"
let serverError = "Server error! Please try after some time."
let serverError1 = "Server error, pull down to refresh"
let deviceType = "iOS"

//MARK: - signUp Screen String
let nameAlert = "Please enter the user name"
let firstNameAlert = "Please enter the first name"
let lastNameAlert = "Please enter last name"
let emailAlert = "Please enter your email"
let validEmail = "Please enter valid email"
let validPhone = "Contact Number Should be 10 digits."
let password = "Please enter the password"
let validPassword = "Password require atleast 1 uppercase letter and 1 lowercase letter, 1 digit, 1 special character (@$!%*?&), length from 8-12"
let confirmPasswordAlert = "Please confirm the password"
let mismatchPassword = "Confirm password did not match with password"
let newPassword = "Please enter the New Password"
let lastPassword = "Please enter the Previous Password"
let successfullyregistered = "You have successfully registered"
let profileImageAlert = "Please select Profile Photo"
let mobileAlert = "Please enter your contact number"
let invalidMobileAlert = "invalid contact number"
let addres1Alert = "Please mention your address"
let countryAlert = "Please mention your country"
let stateAlert = "Please mention your state"

//MARK: LogIn Screen String
let logInSuccess = "You have successfully logged In"

//MARK:-userdefault
let RegistrationToken = "RegistrationToken"
let BirthDate = "BirthDate"
let IpStr = "IpStr"
let UserPassword = "UserPassword"
let UserId = "userID"
let UserEmail = "UserEmail"
let UserName = "UserName"
let Name = "Name"
let Firstname = "Firstname"
let Lastname = "Lastname"
let IsUserLoggedIn = "IsUserLoggedIn"
let IsCompletingProfile = "IsCompletingProfile"
let FirstTimeUser = "FirstTimeUser"
let IsSkipped = "IsSkipped"
let LogedUserImageString = "LogedUserImageString"
