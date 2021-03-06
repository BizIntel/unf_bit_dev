﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Процедура формирования таблицы платежного календаря.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК Статья,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ТаблицаДокумента.СтатусУтвержденияПлатежа КАК СтатусУтвержденияПлатежа,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Касса
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	&Ссылка КАК СчетНаОплату,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	-ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.ПеремещениеДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Дата,
	|	&Организация,
	|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств,
	|	ТаблицаДокумента.ТипДенежныхСредствПолучатель,
	|	ТаблицаДокумента.СтатусУтвержденияПлатежа,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредствПолучатель = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.КассаПолучатель
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредствПолучатель = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчетПолучатель
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	&Ссылка,
	|	ТаблицаДокумента.ВалютаДокумента,
	|	ТаблицаДокумента.СуммаДокумента
	|ИЗ
	|	Документ.ПеремещениеДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Формирует таблицу данных документа.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	СтруктураДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт

	СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли