# OBD Insight

![Swift](https://img.shields.io/badge/Swift-5-orange)
![iOS](https://img.shields.io/badge/iOS-14%2B-blue)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-green)
![CoreData](https://img.shields.io/badge/Database-CoreData-purple)
![Status](https://img.shields.io/badge/status-in%20development-yellow)

iOS приложение для учета автомобилей и работы с OBD-данными.

## Технологии

- Swift
- SwiftUI
- Core Data
- MVVM (упрощенная архитектура)

## Платформа

- iOS 14+
- SwiftUI
- Xcode 12.4

## Архитектура

Проект использует упрощенную архитектуру MVVM.

Основные компоненты:

- View — интерфейс приложения
- Model — Core Data модели
- Persistence — управление базой данных

## Возможности

- регистрация автомобилей
- хранение информации о машине
- работа с OBD адаптером
    - чтение ошибок
    - возможность стирать ошибки
    - подключение к приборной панели
    - экран показаний всех считываемых датчиков
- расчет показателей расхода топлива

## Статус

Проект находится в стадии разработки.
