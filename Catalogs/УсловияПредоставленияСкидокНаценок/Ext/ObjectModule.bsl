﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИспользуютсяВалюты = ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций");
	
	Если УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж Тогда
		
		ПроверяемыеРеквизиты.Очистить();
		ПроверяемыеРеквизиты.Добавить("ОбластьОграничения");
		ПроверяемыеРеквизиты.Добавить("КритерийОграниченияПримененияЗаОбъемПродаж");
		ПроверяемыеРеквизиты.Добавить("ТипСравнения");
		Если  КритерийОграниченияПримененияЗаОбъемПродаж = Перечисления.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Сумма 
			И ИспользуютсяВалюты 
		Тогда
			ПроверяемыеРеквизиты.Добавить("ВалютаОграничения");
		КонецЕсли;
		
	ИначеЕсли УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаКомплектПокупки Тогда
		
		ПроверяемыеРеквизиты.Очистить();
		ПроверяемыеРеквизиты.Добавить("КомплектПокупки");
		ПроверяемыеРеквизиты.Добавить("КомплектПокупки.Номенклатура");
		ПроверяемыеРеквизиты.Добавить("КомплектПокупки.КоличествоУпаковок");
		ПроверяемыеРеквизиты.Добавить("КомплектПокупки.Количество");
		//ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Новый Массив, Отказ, Новый Структура("ИмяТЧ","КомплектПокупки"));	
		
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Добавить("Наименование");
	ПроверяемыеРеквизиты.Добавить("УсловиеПредоставления");
	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		УчитыватьПродажуТолькоОпределенногоСпискаНоменклатуры = УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж И 
																(ОтборПродажПоНоменклатуре.Количество() > 0);
															КонецЕсли;
	
	Если УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаКомплектПокупки Тогда
		ОтборПродажПоНоменклатуре.Очистить();
	ИначеЕсли УсловиеПредоставления = Перечисления.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж Тогда
		КомплектПокупки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЭтоГруппа Тогда
		ВалютаОграничения = Константы.ВалютаУчета.Получить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
