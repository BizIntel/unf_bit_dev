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
	|	РасчетыСПокупателями.НомерСтроки КАК НомерСтроки,
	|	РасчетыСПокупателями.Организация КАК Организация,
	|	РасчетыСПокупателями.Контрагент КАК Контрагент,
	|	РасчетыСПокупателями.Договор КАК Договор,
	|	РасчетыСПокупателями.Документ КАК Документ,
	|	РасчетыСПокупателями.Заказ КАК Заказ,
	|	РасчетыСПокупателями.ТипРасчетов КАК ТипРасчетов,
	|	РасчетыСПокупателями.Сумма КАК СуммаПередЗаписью,
	|	РасчетыСПокупателями.Сумма КАК СуммаИзменение,
	|	РасчетыСПокупателями.Сумма КАК СуммаПриЗаписи,
	|	РасчетыСПокупателями.СуммаВал КАК СуммаВалПередЗаписью,
	|	РасчетыСПокупателями.СуммаВал КАК СуммаВалИзменение,
	|	РасчетыСПокупателями.СуммаВал КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРасчетыСПокупателямиИзменение
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями КАК РасчетыСПокупателями");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСПокупателямиИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#КонецОбласти

#КонецЕсли