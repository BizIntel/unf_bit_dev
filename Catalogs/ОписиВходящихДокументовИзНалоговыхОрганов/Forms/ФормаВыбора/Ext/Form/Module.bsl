﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Организация = Параметры.Отбор.Организация;
		
		// Установка значения отбора в компоновщике настроек.
		ЭлементОтбораДанных = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
		ЭлементОтбораДанных.ПравоеЗначение = Организация;
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование = Истина;
		
		// Удаление отбора из параметров.
		Параметры.Отбор.Удалить("Организация"); 
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("НалоговыйОрган") Тогда
		НалоговыйОрган = Параметры.Отбор.НалоговыйОрган;
		
		// Установка значения отбора в компоновщике настроек.
		ЭлементОтбораДанных = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НалоговыйОрган");
		ЭлементОтбораДанных.ПравоеЗначение = НалоговыйОрган;
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование = Истина;
		
		// Удаление отбора из параметров.
		Параметры.Отбор.Удалить("НалоговыйОрган"); 
	КонецЕсли;
	
	Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти