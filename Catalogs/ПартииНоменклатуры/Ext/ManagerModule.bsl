﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец")
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец)
		И НЕ Параметры.Отбор.Владелец.ИспользоватьПартии Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Для номенклатуры не ведется учет по партиям!'");
		Сообщение.Сообщить();
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПолученияДанныхВыбора()

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
