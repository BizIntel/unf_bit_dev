﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НалоговыеОрганы.Ссылка,
	|	""ФНС "" + НалоговыеОрганы.Код КАК Представление,
	|	1 КАК Порядок
	|ИЗ
	|	Справочник.НалоговыеОрганы КАК НалоговыеОрганы
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОрганыПФР.Ссылка,
	|	""ПФР "" + ОрганыПФР.Код,
	|	2
	|ИЗ
	|	Справочник.ОрганыПФР КАК ОрганыПФР
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОрганыФСГС.Ссылка,
	|	""Росстат "" + ОрганыФСГС.Код,
	|	3
	|ИЗ
	|	Справочник.ОрганыФСГС КАК ОрганыФСГС
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	Представление";
	
	КонтролирующиеОрганы.Загрузить(Запрос.Выполнить().Выгрузить());
	
	// Установка текущей строки.
	Если Параметры.Свойство("ТекущаяСтрока") И ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		НайденныеСтроки = КонтролирующиеОрганы.НайтиСтроки(Новый Структура("Ссылка", Параметры.ТекущаяСтрока));
		Если НайденныеСтроки.Количество() = 1 Тогда
			Элементы.КонтролирующиеОрганы.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтролирующиеОрганыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если ТипЗнч(Значение) = Тип("Число") Тогда
		ДанныеСтроки = КонтролирующиеОрганы.НайтиПоИдентификатору(Значение);
		Если ДанныеСтроки <> Неопределено Тогда
			Закрыть(ДанныеСтроки.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти