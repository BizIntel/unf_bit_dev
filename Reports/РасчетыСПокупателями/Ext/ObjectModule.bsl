﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["ВедомостьВВалюте"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(
		ВариантыОформления,
		"СуммаВалКонечныйОстатокАванс,СуммаВалКонечныйОстатокДолг,СуммаВалКонечныйОстатокРасчеты"
		+ "СуммаВалНачальныйОстатокАванс,СуммаВалНачальныйОстатокДолг,СуммаВалНачальныйОстатокРасчеты"
		+ "СуммаВалОборотАванс,СуммаВалОборотДолг,СуммаВалПриходАванс"
		+ "СуммаВалПриходДолг,СуммаВалРасходАванс,СуммаВалРасходДолг"
		+ "СуммаКонечныйОстатокАванс,СуммаКонечныйОстатокДолг,СуммаКонечныйОстатокРасчеты"
		+ "СуммаНачальныйОстатокАванс,СуммаНачальныйОстатокДолг,СуммаНачальныйОстатокРасчеты"
		+ "СуммаОборотАванс,СуммаОборотДолг,СуммаПриходАванс,СуммаПриходДолг,СуммаРасходАванс,СуммаРасходДолг");
		
	КонецЦикла
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		НастройкиТекВарианта.Значение.Теги = НСтр("ru = 'Деньги,Контрагенты,Покупатели,Дебиторка,Продажи,Работы'");
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Контрагент", "Справочник.Контрагенты");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Заказ", "Документ.ЗаказПокупателя");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли
