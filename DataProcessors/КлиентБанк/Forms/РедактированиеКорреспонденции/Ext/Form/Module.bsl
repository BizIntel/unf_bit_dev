﻿&НаКлиенте
Перем КэшСтатьиРасходовНаОС; // чтобы по нескольку раз не обращаться к общему модулю за статьёй расходов. 


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Множественный Тогда
		КорреспонденцияВходящие   = Параметры.КорреспонденцияВходящих;
		КорреспонденцияИсходящие  = Параметры.КорреспонденцияИсходящих;
	Иначе
		КорреспонденцияВходящие   = Параметры.Корреспонденция;
		КорреспонденцияИсходящие  = Параметры.Корреспонденция;
	КонецЕсли;
	
	НазначениеПлатежа     = Параметры.НазначениеПлатежа;
	Исходящий             = Параметры.Исходящий;
	Множественный         = Параметры.Множественный;
	КоличествоВходящих    = Параметры.КоличествоВходящих;
	КоличествоИсходящих   = Параметры.КоличествоИсходящих;
	Если Параметры.Множественный Тогда
		Элементы.НазначениеПлатежа.Видимость = Ложь;
		
		Элементы.КорреспонденцияВходящие.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Корр. счет учета поступлений (%1 %2)'"),
				КоличествоВходящих,
				ПодобратьСловоПодЧисло(
					КоличествоВходящих,
					НСтр("ru='документ'"),
					НСтр("ru='документа'"),
					НСтр("ru='документов'")));
			
		Элементы.КорреспонденцияИсходящие.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Корр. счет учета списаний (%1 %2)'"),
				КоличествоИсходящих,
				ПодобратьСловоПодЧисло(
					КоличествоИсходящих,
					НСтр("ru='документ'"),
					НСтр("ru='документа'"),
					НСтр("ru='документов'")));
		
	Иначе
		Элементы.КорреспонденцияВходящие.Видимость   = НЕ Параметры.Исходящий;
		Элементы.Декорация4.Видимость            = НЕ Параметры.Исходящий;
		Элементы.КорреспонденцияИсходящие.Видимость  = Параметры.Исходящий;
	КонецЕсли;
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
	Если КоличествоИсходящих > 0 ИЛИ Исходящий Тогда
		ПроверяемыеРеквизиты.Добавить("КорреспонденцияИсходящие");
	КонецЕсли;
	
	Если КоличествоВходящих > 0 ИЛИ (НЕ Исходящий И НЕ Множественный) Тогда
		ПроверяемыеРеквизиты.Добавить("КорреспонденцияВходящие");
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(
		Новый Структура("Корреспонденция, КорреспонденцияИсходящих, КорреспонденцияВходящих", 
			?(Исходящий,КорреспонденцияИсходящие, КорреспонденцияВходящие),
			КорреспонденцияИсходящие,
			КорреспонденцияВходящие));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ И ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	Если Множественный Тогда
		Элементы.ГруппаНастройкиВходящих.Видимость = (КоличествоВходящих>0);
		Элементы.ГруппаНастройкиИсходящих.Видимость = (КоличествоИсходящих>0);
	Иначе
		Если Исходящий Тогда
			Элементы.ГруппаНастройкиИсходящих.Видимость = Истина;
			Элементы.ГруппаНастройкиВходящих.Видимость = Ложь;
		Иначе
			Элементы.ГруппаНастройкиИсходящих.Видимость = Ложь;
			Элементы.ГруппаНастройкиВходящих.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Подбирает слова под число
// Например:
//		ПодобратьСловоПодЧисло(21, "Дань", "Дня", "Дней") = День
//		ПодобратьСловоПодЧисло(35, "Дань", "Дня", "Дней") = Дней
//
Функция ПодобратьСловоПодЧисло(Число, СловоДляОдин, СловоДляДва, СловоДляПять) Экспорт
	
	Если Число > 4 И Число < 21 Тогда
		
		Возврат СловоДляПять;
		
	ИначеЕсли (Число % 10) = 1 Тогда
		
		Возврат СловоДляОдин;
		
	ИначеЕсли (Число % 10) <= 5 Тогда
		
		Возврат СловоДляДва;
		
	Иначе
		
		Возврат СловоДляПять;
		
	КонецЕсли;
	
КонецФункции

