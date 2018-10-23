//
//  Model.swift
//  Currency
//
//  Created by Евгений on 22/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class Model: NSObject, XMLParserDelegate {

    static let shared = Model()
    
    var currencies: [Currency] = []
    
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.ruble()
    var toCurrency: Currency = Currency.ruble()
    
    func converter(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        let value = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!)) * amount!
        return String(value)
    }
    
    // Получаем загруженный файл если он имеется
    // Если нет, то берем из корня приложения
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
    // Загружаем свежие данные с сайта cbr.ru и сохранем в каталоге приложения
    func loadXMLFile(date: Date?) {
        var urlStr = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        if date != nil {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            urlStr = urlStr + dateFormat.string(from: date!)
        }
        let url = URL(string: urlStr)
        var errorGlobal: String?
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                do {
                    try data?.write(to: urlForSave)
                    print("Данные загружены!")
                    print(path)
                    self.parseXMLFile()
                }
                catch {
                    print("Error: \(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
            }
            else {
                print("Error: \(error!.localizedDescription)")
                errorGlobal = error?.localizedDescription
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("startLoadXML"), object: self)
        if let errorGlobal = errorGlobal {
            NotificationCenter.default.post(name: NSNotification.Name("errorLoadingXML"), object: self, userInfo: ["error" : errorGlobal])
        }
        task.resume()
    }
    
    // Парсим XML файл
    func parseXMLFile() {
        currencies = [Currency.ruble()]
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        print("Данные обновлены!")
        NotificationCenter.default.post(name: .init("dataUpdate"), object: self)
        for currency in currencies {
            if currency.charCode == fromCurrency.charCode {
                fromCurrency = currency
            }
            if currency.charCode == toCurrency.charCode {
                toCurrency = currency
            }
        }
    }
    
    var currentCurrency: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "ValCurs" {
            if let currentDateStr = attributeDict["Date"] {
                currentDate = currentDateStr
            }
        }
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "NumCode":
            currentCurrency?.numCode = currentCharacter
        case "CharCode":
            currentCurrency?.charCode = currentCharacter
        case "Nominal":
            currentCurrency?.nominal = currentCharacter
            currentCurrency?.nominalDouble = Double(currentCharacter.replacingOccurrences(of: ",", with: "."))
        case "Name":
            currentCurrency?.name = currentCharacter
        case "Value":
            currentCurrency?.value = currentCharacter
            currentCurrency?.valueDouble = Double(currentCharacter.replacingOccurrences(of: ",", with: "."))
        case "Valute":
            currencies.append(currentCurrency!)
        default:
            return
        }
    }
    
    var currentCharacter: String = ""
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacter = string
    }
    
}

class Currency {
    
    var numCode: String?
    var charCode: String?
    var name: String?
    var nominal: String?
    var nominalDouble: Double?
    var value: String?
    var valueDouble: Double?
    
    class func ruble() -> Currency {
        let rub = Currency()
        rub.charCode = "RUR"
        rub.name = "Российский рубль"
        rub.nominal = "1"
        rub.nominalDouble = 1
        rub.value = "1"
        rub.valueDouble = 1
        return rub
    }
    
}
