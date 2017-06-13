﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЕстьДвиженияПоЭквайрингу() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РасчетыПоЭквайрингу.Организация
		|ИЗ
		|	РегистрНакопления.РасчетыПоЭквайрингу КАК РасчетыПоЭквайрингу";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

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
	|	РасчетыПоЭквайрингу.НомерСтроки КАК НомерСтроки,
	|	РасчетыПоЭквайрингу.ВидОперацииЭквайринга КАК ВидОперацииЭквайринга,
	|	РасчетыПоЭквайрингу.Организация КАК Организация,
	|	РасчетыПоЭквайрингу.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингу.ДатаПлатежа КАК ДатаПлатежа,
	|	РасчетыПоЭквайрингу.Документ КАК Документ,
	|	РасчетыПоЭквайрингу.Заказ КАК Заказ,
	|	РасчетыПоЭквайрингу.ВидПлатежнойКарты,
	|	РасчетыПоЭквайрингу.НомерПлатежнойКарты,
	|	РасчетыПоЭквайрингу.Сумма КАК СуммаПередЗаписью,
	|	РасчетыПоЭквайрингу.Сумма КАК СуммаИзменение,
	|	РасчетыПоЭквайрингу.Сумма КАК СуммаПриЗаписи,
	|	РасчетыПоЭквайрингу.СуммаВал КАК СуммаВалПередЗаписью,
	|	РасчетыПоЭквайрингу.СуммаВал КАК СуммаВалИзменение,
	|	РасчетыПоЭквайрингу.СуммаВал КАК СуммаВалПриЗаписи,
	|	РасчетыПоЭквайрингу.Комиссия КАК КомиссияПередЗаписью,
	|	РасчетыПоЭквайрингу.Комиссия КАК КомиссияИзменение,
	|	РасчетыПоЭквайрингу.Комиссия КАК КомиссияПриЗаписи,
	|	РасчетыПоЭквайрингу.КомиссияВал КАК КомиссияВалПередЗаписью,
	|	РасчетыПоЭквайрингу.КомиссияВал КАК КомиссияВалИзменение,
	|	РасчетыПоЭквайрингу.КомиссияВал КАК КомиссияВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРасчетыПоЭквайрингуИзменение
	|ИЗ
	|	РегистрНакопления.РасчетыПоЭквайрингу КАК РасчетыПоЭквайрингу");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыПоЭквайрингуИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#КонецОбласти

#КонецЕсли