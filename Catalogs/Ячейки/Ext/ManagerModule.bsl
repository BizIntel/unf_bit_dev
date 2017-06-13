﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец")
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец)
		И (Параметры.Отбор.Владелец.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Розница
		ИЛИ Параметры.Отбор.Владелец.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет) Тогда
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Для структурной единицы данного типа нельзя использовать ячейки!'");
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
