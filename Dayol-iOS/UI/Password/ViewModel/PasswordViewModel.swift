//
//  PasswordViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2020/12/20.
//

import Foundation
import RxSwift
import RxCocoa
import CommonCrypto

class PasswordViewModel {
    enum InputType {
        case new
        case check
    }
    
	private var hashedPassword: Data?
	private let hashAlgo: String = "MD5"
    private let type: InputType
    
	let shouldShowVibeAniamtion = PublishSubject<Bool>()
	let isCorrect = PublishSubject<Bool>()
    let shouldCreatePassword = PublishSubject<Bool>()
    let shouldReInputPassword = PublishSubject<Bool>()
    
    var inputtedPassword = "" {
        didSet {
            switch type {
            case .new:
                if hashedPassword == nil, inputtedPassword.count >= 4  {
                    reinputPassword()
                } else {
                    checkValidationIfNeeded(password: inputtedPassword)
                }
            case .check:
                checkValidationIfNeeded(password: inputtedPassword)
            }
        }
    }

    init(type: InputType, password: String? = nil) {
        self.type = type
        if let password = password, let data = password.data(using: .utf8) {
            self.hashedPassword = self.hash(name: hashAlgo, data: data)
        }
	}
    
    func prepareCreatePassword() {
        shouldCreatePassword.onNext(true)
    }
}

// MARK: - Hashing

private extension PasswordViewModel {
	private func hash(name:String, data:Data) -> Data? {
		let algos = ["MD2":    (CC_MD2,    CC_MD2_DIGEST_LENGTH),
					 "MD4":    (CC_MD4,    CC_MD4_DIGEST_LENGTH),
					 "MD5":    (CC_MD5,    CC_MD5_DIGEST_LENGTH),
					 "SHA1":   (CC_SHA1,   CC_SHA1_DIGEST_LENGTH),
					 "SHA224": (CC_SHA224, CC_SHA224_DIGEST_LENGTH),
					 "SHA256": (CC_SHA256, CC_SHA256_DIGEST_LENGTH),
					 "SHA384": (CC_SHA384, CC_SHA384_DIGEST_LENGTH),
					 "SHA512": (CC_SHA512, CC_SHA512_DIGEST_LENGTH)]
		guard let (hashAlgorithm, length) = algos[name]  else { return nil }
		var hashData = Data(count: Int(length))

		_ = hashData.withUnsafeMutableBytes { digestBytes in
			data.withUnsafeBytes { messageBytes in
				hashAlgorithm(messageBytes, CC_LONG(data.count), digestBytes)
			}
		}
		return hashData
	}
}

// MARK: - UI Action

extension PasswordViewModel {
	func inputPassword(number: Int) {
		let text = String(number)
		inputtedPassword.append(text)
	}

	func deletePassword() {
        let _ = inputtedPassword.popLast()
	}

	func clearPassword() {
		inputtedPassword = ""
	}
    
    func reinputPassword() {
        setInputtedPasswordForNewPassword(inputtedPassword)
        prepaerReInputPassword()
    }
}

// MARK: - Password Logics

private extension PasswordViewModel {
       
    func prepaerReInputPassword() {
        shouldReInputPassword.onNext(true)
    }
    
    func setInputtedPasswordForNewPassword(_ password: String) {
        guard let data = password.data(using: .utf8) else { return }
        
        self.hashedPassword = self.hash(name: hashAlgo, data: data)
    }
    
    func reInputPassword() {
        clearPassword()
        shouldReInputPassword.onNext(true)
    }
    
    func checkValidationIfNeeded(password: String) {
        if inputtedPassword.count >= 4 {
            checkValidation(password)
        }
    }
    
    private func checkValidation(_ password: String) {
        guard let data = password.data(using: .utf8), let hashValue = hash(name: hashAlgo, data: data) else { return }
        let equals = hashValue == hashedPassword

        if equals {
            shouldShowVibeAniamtion.onNext(false)
            isCorrect.onNext(true)
        } else {
            shouldShowVibeAniamtion.onNext(true)
            isCorrect.onNext(false)
        }
    }
}
