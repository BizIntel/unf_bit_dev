﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("ОснованиеСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьБезУчетаОтправленныхСтрок = Неопределено;
	ДанныеЗаполнения.Свойство("ЗаполнитьБезУчетаОтправленныхСтрок", ЗаполнитьБезУчетаОтправленныхСтрок);
	
	Основание = ДанныеЗаполнения.ОснованиеСсылка;
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС") Тогда
		Требование = Основание.Требование;
	Иначе
		Требование = Основание;
	КонецЕсли;
	
	Дата           =  ТекущаяДатаСеанса();
	НалоговыйОрган = Требование.НалоговыйОрган;
	Организация    = Требование.Организация;
	
	ОписьВходящихДокументов = ДокументооборотСКОВызовСервера.ПолучитьОписьВходящихДокументовПоТребованию(ЭтотОбъект.Требование);
	
	ДанныеТребования = Справочники.ДокументыРеализацииПолномочийНалоговыхОрганов.ДанныеТребованияОПредставленииПоясненийКДекларацииНДС(ЭтотОбъект.Требование);
	ОтправленныеРанееСтроки = Неопределено;
	Если ЗаполнитьБезУчетаОтправленныхСтрок <> Истина Тогда
		ОтправленныеРанееСтроки = Документы.ПоясненияКДекларацииПоНДС.ОтправленныеРанееСтроки(ЭтотОбъект.Требование);
	КонецЕсли;
	
	ДанныеКопирования = Неопределено;
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС") Тогда
		ДанныеКопирования = Документы.ПоясненияКДекларацииПоНДС.ДанныеПоясненияКДекларацииПоНДС(Основание);
	КонецЕсли;
	
	Если ДанныеТребования <> Неопределено Тогда
		Если ДанныеТребования.Свойство("Раздел8") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел8(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
		Если ДанныеТребования.Свойство("Раздел8_1") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел8_1(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
		Если ДанныеТребования.Свойство("Раздел9") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел9(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
		Если ДанныеТребования.Свойство("Раздел9_1") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел9_1(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
		Если ДанныеТребования.Свойство("Раздел10") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел10(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
		Если ДанныеТребования.Свойство("Раздел11") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел11(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
		Если ДанныеТребования.Свойство("Раздел12") Тогда
			Документы.ПоясненияКДекларацииПоНДС.ЗаполнитьРаздел12(ЭтотОбъект, ДанныеТребования, ОтправленныеРанееСтроки, ДанныеКопирования);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС") Тогда
		Если Основание.СведКС.Количество() > 0 Тогда
			ЭтотОбъект.СведКС.Загрузить(Основание.СведКС.Выгрузить());
		КонецЕсли;
		 
		Если Основание.НетКнигаПрод.Количество() > 0 Тогда
			ЭтотОбъект.НетКнигаПрод.Загрузить(Основание.НетКнигаПрод.Выгрузить());
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Основание.ПояснИнОсн) Тогда
			ЭтотОбъект.ПояснИнОсн = Основание.ПояснИнОсн;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецЕсли