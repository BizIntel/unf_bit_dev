﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ИзМакета Тогда
		
		ОбщийМакет = Ложь;
		
		Если Параметры.Свойство("ОбщийМакет") Тогда
			ОбщийМакет = Параметры.ОбщийМакет;
		КонецЕсли;
		
		Если ОбщийМакет Тогда
			ТекстПоказа = ПолучитьОбщийМакет(Параметры.ИмяМакета).ПолучитьТекст();
		Иначе
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Параметры.ПутьДоМакета);
			Попытка
				ТекстПоказа = МенеджерОбъекта.ПолучитьМакет(Параметры.ИмяМакета).ПолучитьТекст();
			Исключение
				Отказ = Истина;
				Возврат;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	Заголовок = Параметры.Заголовок;
	
КонецПроцедуры
