//
//  LoginViewController.swift
//  RVenture
//
//  Created by Joshua Rutkowski on 2/28/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    //MARK:- Properties
    var isHost: String? = "RV Owner"
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    //MARK:- Computed Properties
    // Container View for login input
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white// TODO: Set to white as default
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    // Login button
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.4394537807, green: 0.449608624, blue: 0.1603180766, alpha: 1)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    // Input Text Views and Line Separators for Name, Email Address, and Passowrd
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // Logo Image
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"logo-white.pdf")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let isHostLabel: UILabel = {
        let label = UILabel()
        label.text = "Register as a host"
        label.textAlignment = NSTextAlignment.left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "start your next RVenture"
        label.textAlignment = NSTextAlignment.left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isHostSwitch: UISwitch = {
        let hostSwitch = UISwitch()
        hostSwitch.translatesAutoresizingMaskIntoConstraints = false
        hostSwitch.onTintColor = .white
        hostSwitch.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        hostSwitch.layer.borderColor = #colorLiteral(red: 0.4394537807, green: 0.449608624, blue: 0.1603180766, alpha: 1)
        hostSwitch.layer.borderWidth = 1
        hostSwitch.layer.cornerRadius = hostSwitch.frame.height/2
        return hostSwitch
    }()
    
    let loginRegisterSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        return sc
    }()
    
    
    
    //MARK:- View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    
    fileprivate func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.5370696501, green: 0.5526979324, blue: 0.1988666176, alpha: 1)
        
        view.addSubview(loginRegisterSegmentedController)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImageView)
        view.addSubview(isHostSwitch)
        view.addSubview(isHostLabel)
        view.addSubview(titleLabel)
        
        setupLoginRegisterSegmentedControl()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLogoImageView()
        setupLoginSwitch()
        setupTitleLabel()
        setupHostLabel()
    }
    
    // MARK: - Functions
    
    func setupTitleLabel() {
        titleLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
    }
    
    
    func setupLogoImageView() {
        logoImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 42).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -96).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedController.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
    
    func setupInputsContainerView() {
        // Container view constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        // Subviews
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // Name Text
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // Separator
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Email Text Field
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Separator
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Password Text Field
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func setupLoginSwitch() {
        isHostSwitch.leftAnchor.constraint(equalTo: loginRegisterButton.leftAnchor).isActive = true
        isHostSwitch.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        isHostSwitch.heightAnchor.constraint(equalToConstant: 32).isActive = true
        isHostSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupHostLabel() {
        isHostLabel.leadingAnchor.constraint(equalTo: isHostSwitch.trailingAnchor, constant: 12).isActive = true
        isHostLabel.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        isHostLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        isHostLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
    }
    
    
    //MARK:- Helper Functions
    
    @objc fileprivate func handleSwitch() {
        if isHostSwitch.isOn {
            print("Switch ON")
            isHost = "Landowner"
        } else {
            print("Switch OFF")
            isHost = "Normal"
        }
    }
    
    @objc func handleRegister() {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let accountType = isHost else {
                print("Form is not valid")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            
            // Saves email, password, and account type into Firebase Database, nested within "users" and user ID
            let ref = Database.database().reference(fromURL: "https://rventure-a96cc.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email, "Account Type": accountType]
            
            usersReference.updateChildValues(values) { (userError, ref) in
                if userError != nil {
                    print(userError)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedController.titleForSegment(at: loginRegisterSegmentedController.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height on inputContainerView when "Login" or "Register" is selected
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 100 : 150
        
        // Change height of name text field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // Change height of email text field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Change height of password text field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("Form is not valid")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedController.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    
    
    
    
    
}


