﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.Вставить("РежимПериода", "НаДату");
	
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		НастройкиТекВарианта.Значение.Теги = НСтр("ru = 'Персонал,Зарплата'");
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)

	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Подразделение", "Справочник.СтруктурныеЕдиницы");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Должность", "Справочник.Должности");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли
