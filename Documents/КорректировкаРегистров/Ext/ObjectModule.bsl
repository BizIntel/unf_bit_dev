﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает признак активности для записей регистров.
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл
		
		Движение.Прочитать();
		Движение.УстановитьАктивность(ФлагАктивности);
			
	КонецЦикла;
	
КонецПроцедуры // УстановитьАктивностьДвижений()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

#КонецОбласти

#КонецЕсли