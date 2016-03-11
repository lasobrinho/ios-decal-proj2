//
//  MainGameViewController.swift
//  Hangman
//
//  Created by Lucas Alves Sobrinho on 3/5/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class MainGameViewController: UIViewController {
    
    var alphabet = [String]()
    var phrase: String?
    var buttons = [UIButton]()
    var labelText = ""
    var errors = 0
    var underscores = 0
    let enabledColor = UIColor(red: 18/255, green: 51/255, blue: 188/255, alpha: 0.85)
    
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGame(true)
    }
    
    func initGame(firstTime: Bool) {
        alphabet.removeAll()
        for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters {
            alphabet.append(String(char))
        }
        for i in 0...25 {
            if firstTime {
                createButton(alphabet[i], offset: i, index: i)
            } else {
                buttons[i].enabled = true
                let attributesEnabled = [
                    NSFontAttributeName: UIFont(name: "Drawing with markers", size: 25)!,
                    NSForegroundColorAttributeName: enabledColor,
                ]
                let myTitle = NSAttributedString(string: (buttons[i].titleLabel?.text)!, attributes: attributesEnabled)
                buttons[i].setAttributedTitle(myTitle, forState: .Normal)
            }
        }
        errors = 0
        getRandomPhrase()
        hangmanImage.image = UIImage(named: "hm1.png")
        phraseLabel.text = ""
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "nb_bg")!)
        updateGame()
    }
    
    func getRandomPhrase () {
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
    }
    
    func buttonAction(sender:UIButton!)
    {
        if phrase!.characters.contains(Character(sender.currentTitle!)){
            alphabet.removeAtIndex(alphabet.indexOf(sender.currentTitle!)!)
        } else {
            errors = errors + 1
            hangmanImage.image = UIImage(named: "hm" + String(errors + 1) + ".png")
        }
        sender.enabled = false
        let attributesDisabled = [
            NSFontAttributeName: UIFont(name: "Drawing with markers", size: 25)!,
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSStrikethroughStyleAttributeName: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)
        ]
        let myTitle = NSAttributedString(string: (sender.titleLabel?.text)!, attributes: attributesDisabled)
        sender.setAttributedTitle(myTitle, forState: .Disabled)
        updateGame()
    }
    
    func updateGame() {
        underscores = 0
        phraseLabel.text = ""
        for c in (phrase?.characters)! {
            if c == " " {
                phraseLabel.text? += " "
            } else if !alphabet.contains(String(c)) {
                phraseLabel.text? += String(c)
            } else {
                underscores += 1
                phraseLabel.text? += "_"
            }
        }
        checkStatus()
        let attributedString = phraseLabel.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(NSKernAttributeName, value: 6.0, range: NSMakeRange(0, attributedString.length))
        phraseLabel.attributedText = attributedString
    }
    
    func checkStatus() {
        if underscores == 0 {
            let alert = UIAlertController(title: "You Won!", message: "You are good at this! Try one more time...", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default, handler: { action in
                self.initGame(false)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        if errors > 5 {
            let alert = UIAlertController(title: "Game Over", message: "The phrase was " + phrase! + ".\nTry one more time...", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.Default, handler: { action in
                self.initGame(false)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func createButton(label: String, offset: Int, index: Int) {
        buttons.append(UIButton(type: UIButtonType.System) as UIButton)
        configureButton()
        buttons[index].setTitle(label, forState: UIControlState.Normal)
        buttons[index].addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        if index < 9 {
            stackView1.addArrangedSubview(buttons[index])
        } else if index < 18 {
            stackView2.addArrangedSubview(buttons[index])
        } else {
            stackView3.addArrangedSubview(buttons[index])
        }
    }
    
    func configureButton() {
        buttons.last?.setTitleColor(enabledColor, forState: .Normal)
        buttons.last?.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        buttons.last?.layer.removeAllAnimations()
        buttons.last?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        buttons.last?.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        buttons.last?.titleLabel?.font = UIFont(name: "Drawing with markers", size: 25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
