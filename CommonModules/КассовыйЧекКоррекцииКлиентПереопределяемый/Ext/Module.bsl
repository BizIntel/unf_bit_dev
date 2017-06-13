﻿#Область ПрограммныйИнтерфейс

// Функция проверяет возможность печати чека на фискальном регистраторе.
//
// Параметры:
//	ФормаОбъекта - УправляемаяФорма - Форма документа.
//
// Возвращаемое значение:
//	Булево - Признак возможности печати.
//
Функция ПроверитьВозможностьПечатиЧека(ОбработчикОповещения, ФормаОбъекта) Экспорт
	
	ПечататьЧек = Истина;
	
	// Если объект не проведен или модифицирован - выполним проведение.
	Если НЕ ФормаОбъекта.Объект.Проведен
		ИЛИ ФормаОбъекта.Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru='Операция возможна только после проведения документа, провести документ?'");
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		ПечататьЧек = Ложь;
		
	КонецЕсли;
	
	Возврат ПечататьЧек;

КонецФункции // ПроверитьВозможностьПечатиЧека()

// Функция возвращает номер чека, для устройств, которые не умеют его определять.
//
//  ВозвращаемоеЗначение
//   Число
//
Функция ПорядковыйНомерПродажи() Экспорт

	Возврат 1

КонецФункции

// Процедура рассчитывает номер чека, для устройств, которые не умеют его определять.
//
Процедура УвеличитьПорядковыйНомерПродажи() Экспорт

КонецПроцедуры

#КонецОбласти

