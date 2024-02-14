//
//  DeviceManager.swift
//  KEDeviceManager
//
//  Created by Эля Корельская on 14.02.2024.
//

import UIKit

open class DeviceManager {

    // MARK: - Properties

    public static let sharedInstance = DeviceManager()
    public static let fileName = "Apple_mobile_device_types.txt"
    public var devicesInfo: [String: String] = [:]
    public var url = URL(string: "https://gist.githubusercontent.com/adamawolf/3048717/raw/07ad6645b25205ef2072a560e660c636c8330626/Apple_mobile_device_types.txt")!

    // MARK: - Init

    private init() {
        loadModelsFromCache()
    }

    // MARK: - Public

    // проверка наличия файла в директории Document
    public func loadModelsFromCache() {
        var modelsString = devicesFile
        if let documentsDirectory = FileManager.default.documentsDirectory {
            let fileURL = FileManager.default.fileURL(for: DeviceManager.fileName, in: documentsDirectory)
            if let fileData = FileManager.default.contents(atPath: fileURL.path) {
                modelsString = String(decoding: fileData, as: UTF8.self)
            }
            devicesInfo = parseDeviceFile(content: modelsString)
        }
    }

    // парсинг
    public func parseDeviceFile(content: String) -> [String: String] {
        let lines = content.components(separatedBy: "\n")
        for line in lines {
            let components = line.components(separatedBy: ":")
            if components.count == 2 {
                let key = components[0].trimmingCharacters(in: .whitespaces)
                let value = components[1].trimmingCharacters(in: .whitespaces)
                devicesInfo[key] = value
            }
        }
        return devicesInfo
    }

    public func loadModelsFromServerIfNeeded(completion: @escaping () -> Void) {
        var needToLoadModels = true
        if let documentsDirectory = FileManager.default.documentsDirectory {
            let fileURL = FileManager.default.fileURL(for: DeviceManager.fileName, in: documentsDirectory)
            if FileManager.default.fileExists(atPath: fileURL.path),
               let fileCreationDate = FileManager.default.fileCreationDate(fileURL: fileURL),
               Calendar.current.isDateInToday(fileCreationDate) {
                needToLoadModels = false
            }
            if needToLoadModels {
                downloadNewFile(url: url, fileURL: fileURL) { [weak self] newDevicesInfo in
                    self?.devicesInfo = newDevicesInfo ?? [:]
                    completion()
                }
            } else {
                completion()
            }
        } else { completion() }
    }

    // парсим файл в директории Document
    public func parsingFileInDocument(fileURL: URL) -> [String: String] {
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            let devicesData = parseDeviceFile(content: fileContent)
            return devicesData
        } catch let error {
            print("Ошибка при чтении файла: \(error.localizedDescription)")
        }
        return [:]
    }

    // загружаем файл из сети
    public func downloadNewFile(url: URL, fileURL: URL, completion: @escaping ([String: String]?) -> Void) {
        NetworkManager().downloadFile(url: url, fileURL: fileURL) { [weak self] result in
            switch result {
            case .success:
                print("Файл в документах скачан успешно")
                let devicesInfo = self?.parsingFileInDocument(fileURL: fileURL)
                completion(devicesInfo)
            case .failure(let error):
                print("Ошибка при скачивании файла: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // по ключу отдаем значение девайса
    public func getDeviceDescription(key: String) -> String? {
        return devicesInfo[key]
    }

    // показываем информацию о конкретном девайсе
    public func showUsingDevice() -> String {
        return getDeviceDescription(key: getModelName()) ?? "not device"
    }
}
extension DeviceManager {

    // получаем данные о модели
    public func getModelName() -> String {
        var machineString = String()
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        machineString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return machineString
    }
}
