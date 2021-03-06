﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Тип <> Перечисления.ТипыНачисленийИУдержаний.Налог Тогда
		
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидНалога");
		
	КонецЕсли;
	
	Если Тип = Перечисления.ТипыНачисленийИУдержаний.Удержание 
		ИЛИ Тип = Перечисления.ТипыНачисленийИУдержаний.Налог Тогда
		
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КодДоходаНДФЛ");
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецЕсли