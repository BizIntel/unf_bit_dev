﻿
&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Номенклатура = Параметры.Отбор.Владелец;
		
		ИспользоватьПодсистемуПроизводство = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Получить();
		ИспользоватьПодсистемуРаботы = Константы.ФункциональнаяОпцияИспользоватьПодсистемуРаботы.Получить();
		
		Если НЕ ЗначениеЗаполнено(Номенклатура)
			ИЛИ Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ВидРабот
			ИЛИ Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
			ИЛИ Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Операция Тогда
			
			АвтоЗаголовок = Ложь;
			Если ИспользоватьПодсистемуПроизводство И ИспользоватьПодсистемуРаботы Тогда
				Заголовок = НСтр("ru = 'Спецификации хранятся только для запасов и работ'");
			ИначеЕсли ИспользоватьПодсистемуПроизводство Тогда
				Заголовок = НСтр("ru = 'Спецификации хранятся только для запасов'");
			Иначе
				Заголовок = НСтр("ru = 'Спецификации хранятся только для работ'");
			КонецЕсли;
			Элементы.Список.ТолькоПросмотр = Истина;
			
		ИначеЕсли Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас И НЕ ИспользоватьПодсистемуПроизводство Тогда
			
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Спецификации хранятся только для работ'");
			Элементы.Список.ТолькоПросмотр = Истина;
			
		ИначеЕсли Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа И НЕ ИспользоватьПодсистемуРаботы Тогда
			
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Спецификации хранятся только для запасов'");
			Элементы.Список.ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры // ПриСозданииНаСервере()

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормыСпецификации");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормыСпецификации");
	
КонецПроцедуры

#КонецОбласти