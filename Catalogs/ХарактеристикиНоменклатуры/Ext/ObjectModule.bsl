﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") Тогда
		Возврат;
	КонецЕсли;
	
	КатегорииНоменклатурыСервер.ПроверкаЗаполненияСвойствПередЗаписью(ЭтотОбъект, Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		Категория = Владелец.КатегорияНоменклатуры;
	ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.КатегорииНоменклатуры") Тогда
		Категория = Владелец;
	КонецЕсли;
	КатегорииНоменклатурыСервер.ПроверкаЗаполненияСвойствПриЗаписи(ЭтотОбъект, Категория, Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли