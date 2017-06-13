﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	РасчетыПоНалогам.НомерСтроки КАК НомерСтроки,
	|	РасчетыПоНалогам.Организация КАК Организация,
	|	РасчетыПоНалогам.ВидНалога КАК ВидНалога,
	|	РасчетыПоНалогам.Сумма КАК СуммаПередЗаписью,
	|	РасчетыПоНалогам.Сумма КАК СуммаИзменение,
	|	РасчетыПоНалогам.Сумма КАК СуммаПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРасчетыПоНалогамИзменение
	|ИЗ
	|	РегистрНакопления.РасчетыПоНалогам КАК РасчетыПоНалогам");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыПоНалогамИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#КонецОбласти

#КонецЕсли