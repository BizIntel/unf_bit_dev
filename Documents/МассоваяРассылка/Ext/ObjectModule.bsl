﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СпособОтправки = Перечисления.ВидыКаналовСвязи.SMS Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("УчетнаяЗапись"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли