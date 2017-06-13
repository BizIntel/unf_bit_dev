﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РасчетыВУсловныхЕдиницах")
		И Параметры.РасчетыВУсловныхЕдиницах Тогда
		
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список,"Владелец",Параметры.Владелец);
		
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список,"ВалютаДенежныхСредств",Параметры.СписокВалют,Истина,ВидСравненияКомпоновкиДанных.ВСписке);
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ТипВладельца = ТипЗнч(Параметры.Отбор.Владелец);
		Элементы.ПрямойОбмен.Видимость =
			ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками") И ТипВладельца = Тип("СправочникСсылка.Организации");
	ИначеЕсли Параметры.Свойство("ПоказыватьВладельца") Тогда
		Элементы.ВладелецДляВыбораВКлиентБанке.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти