﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ЭтотУзел", ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.ЭтотУзел());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершенСеансОбменаССайтом" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВызовИзПланаОбмена", Истина);
	
	ОткрытьФорму("Обработка.ПомощникСозданияОбменаДаннымиССайтом.Форма.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

