﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру значений по умолчанию для документа для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПоУмолчанию() Экспорт
	
	СтруктрураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктрураЗначенияПоУмолчанию.Вставить("Документ",           Неопределено);
	СтруктрураЗначенияПоУмолчанию.Вставить("ТекущееУведомление", Неопределено);
	СтруктрураЗначенияПоУмолчанию.Вставить("Статус",             Перечисления.СтатусыИнформированияГИСМ.ПустаяСсылка());
	СтруктрураЗначенияПоУмолчанию.Вставить("ДальнейшееДействие", Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка());
	
	Возврат СтруктрураЗначенияПоУмолчанию;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
// 	ДанныеЗаписи - данные для записи в регистр
//
Процедура ВыполнитьЗаписьВРегистрПоДаннымСтруктура(ДанныеЗаписи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СтатусыИнформированияГИСМ.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает статус документа.
//
// Параметры:
// 	Документ - документ, для которого необходимо обновить статус
// 	Статус - статус документа
// 	ДальнейшееДействие - дальнейшее действие по документу
//
// Возвращаемое значение:
//	ПеречислениеСсылка.СтатусыИнформированияГИСМ - новый статус документа
//
Функция ОбновитьСтатус(Документ, Статус, ДальнейшееДействие) Экспорт
	
	НовыйСтатус             = Неопределено;
	НовоеДальнейшееДействие = Неопределено;
	
	НаборЗаписей = НаборЗаписей(Документ);
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		Если ЗаписьНабора.Статус <> Статус Тогда
			ЗаписьНабора.Статус = Статус;
			НовыйСтатус = Статус;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие <> ДальнейшееДействие Тогда
			ЗаписьНабора.ДальнейшееДействие = ДальнейшееДействие;
			НовоеДальнейшееДействие = ДальнейшееДействие;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НовыйСтатус)
		Или ЗначениеЗаполнено(НовоеДальнейшееДействие) Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Возврат НовыйСтатус;
	
КонецФункции

// Функция определяет, является ли статус уведомления неактуальным.
//
// Параметры:
// 	Статус - статус, который необходимо проверить
//
// Возвращаемое значение:
//	Булево - статус заявки является неактуальным
//
Функция ЭтоСтатусНеАктуальногоУведомления(Статус) Экспорт

	Если Статус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ
		Или Статус = Перечисления.СтатусыИнформированияГИСМ.Отсутствует
		Или Статус = Перечисления.СтатусыИнформированияГИСМ.ПустаяСсылка() Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

// Удаляет запись из регистра по переданному документу.
//
// Параметры:
// 	Документ - документ, данные по которому необходимо удалить
//
Процедура УдалитьЗаписьИзРегистра(Документ) Экспорт

	НаборЗаписей = РегистрыСведений.СтатусыИнформированияГИСМ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаборЗаписей(ДокументСсылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Статусы.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК Статусы
	|ГДЕ
	|	Статусы.Документ = &ДокументСсылка
	|ИЛИ Статусы.ТекущееУведомление = &ДокументСсылка");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	НаборЗаписей = Неопределено;
	Если Выборка.Следующий() Тогда
		
		НаборЗаписей = РегистрыСведений.СтатусыИнформированияГИСМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Выборка.Документ, Истина);
		НаборЗаписей.Прочитать();
		
	Иначе
		
		ТипыУведомлений = Метаданные.РегистрыСведений.СтатусыИнформированияГИСМ.Ресурсы.ТекущееУведомление.Тип.Типы();
		
		Если ТипыУведомлений.Найти(ТипЗнч(ДокументСсылка)) <> Неопределено Тогда
			Основание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Основание");
		Иначе
			Основание = Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Основание) Тогда
			Документ = Основание;
		Иначе
			Документ = ДокументСсылка;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.СтатусыИнформированияГИСМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Документ, Истина);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗначенияПоУмолчанию());
		НоваяЗапись.Документ           = Документ;
		НоваяЗапись.ТекущееУведомление = ДокументСсылка;
		
	КонецЕсли;
	
	Возврат НаборЗаписей;
	
КонецФункции

#КонецОбласти

#КонецЕсли