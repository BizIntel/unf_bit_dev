﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	НастройкиОтчета.ПоказыватьГруппуСтрокиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьГруппуКолонкиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьГруппуФильтрыНаФормеОтчета = Ложь;
	НастройкиОтчета.РазрешитьРедактироватьСКД = Ложь;
	НастройкиВариантов["План-фактный анализ"].ИмяМакетаОбразца = "ОбразецБюджетДвиженияДенежныхСредствПланФакт";
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ОтчетыУНФ.ДобавитьПолеВыбораПериодаПланирования(НастройкиСКД, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.УстановитьПараметрОтчетаПоУмолчанию(КомпоновщикНастроек.Настройки, "Организация", Справочники.Организации.ОсновнаяОрганизация);
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = Новый Массив;
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		ИмяПоля = Строка(ДоступноеПоле.Поле);
		Если Найти(ИмяПоля, "Сумма")=0 Тогда
			Продолжить;
		КонецЕсли; 
		МассивПолейСумм.Добавить(ИмяПоля);
	КонецЦикла; 
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСТР("ru = 'Компания,Деньги,Бюджет,План'");
	НастройкиВариантов["План-фактный анализ"].Теги = НСТР("ru = 'Компания,Деньги,Бюджет,План,Факт'");
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли