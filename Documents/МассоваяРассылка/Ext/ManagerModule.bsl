﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("ПометкаУдаления");
	Поля.Добавить("Номер");
	Поля.Добавить("ДатаРассылки");
	Поля.Добавить("СпособОтправки");
	Поля.Добавить("Состояние");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗаголовокПредставление = НСтр("ru='Рассылка'");
	
	Если Данные.ПометкаУдаления Тогда
		Состояние = НСтр("ru='(удалена)'");
	Иначе
		Состояние = "(" + НРег(Данные.Состояние) + ")";
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1 %2: %3 %4 %5'"),
		ЗаголовокПредставление,
		Данные.СпособОтправки,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Данные.Номер, Истина, Истина),
		?(ЗначениеЗаполнено(Данные.ДатаРассылки), "от " + Формат(Данные.ДатаРассылки, "ДЛФ=D"), ""),
		Состояние);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли