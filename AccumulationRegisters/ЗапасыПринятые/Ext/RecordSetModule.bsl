﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыПринятые.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПринятыеИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПринятыеИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыПринятыеИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыПринятыеИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыПринятыеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыПринятые.НомерСтроки КАК НомерСтроки,
		|	ЗапасыПринятые.Организация КАК Организация,
		|	ЗапасыПринятые.Номенклатура КАК Номенклатура,
		|	ЗапасыПринятые.Характеристика КАК Характеристика,
		|	ЗапасыПринятые.Партия КАК Партия,
		|	ЗапасыПринятые.Контрагент КАК Контрагент,
		|	ЗапасыПринятые.Договор КАК Договор,
		|	ЗапасыПринятые.Заказ КАК Заказ,
		|	ЗапасыПринятые.ТипПриемаПередачи КАК ТипПриемаПередачи,
		|	ВЫБОР
		|		КОГДА ЗапасыПринятые.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПринятые.Количество
		|		ИНАЧЕ -ЗапасыПринятые.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью,
		|	ВЫБОР
		|		КОГДА ЗапасыПринятые.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПринятые.СуммаРасчетов
		|		ИНАЧЕ -ЗапасыПринятые.СуммаРасчетов
		|	КОНЕЦ КАК СуммаРасчетовПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПринятыеПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыПринятые КАК ЗапасыПринятые
		|ГДЕ
		|	ЗапасыПринятые.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыПринятыеИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблцу "ДвиженияЗапасыПринятыеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыПринятыеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыПринятыеИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыПринятыеИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыПринятыеИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыПринятыеИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыПринятыеИзменение.Контрагент КАК Контрагент,
		|	ДвиженияЗапасыПринятыеИзменение.Договор КАК Договор,
		|	ДвиженияЗапасыПринятыеИзменение.Заказ КАК Заказ,
		|	ДвиженияЗапасыПринятыеИзменение.ТипПриемаПередачи КАК ТипПриемаПередачи,
		|	ДвиженияЗапасыПринятыеИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
		|	ДвиженияЗапасыПринятыеИзменение.СуммаРасчетовПередЗаписью КАК СуммаРасчетовПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПринятыеПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыПринятыеИзменение КАК ДвиженияЗапасыПринятыеИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыПринятые.НомерСтроки,
		|	ЗапасыПринятые.Организация,
		|	ЗапасыПринятые.Номенклатура,
		|	ЗапасыПринятые.Характеристика,
		|	ЗапасыПринятые.Партия,
		|	ЗапасыПринятые.Контрагент,
		|	ЗапасыПринятые.Договор,
		|	ЗапасыПринятые.Заказ,
		|	ЗапасыПринятые.ТипПриемаПередачи,
		|	ВЫБОР
		|		КОГДА ЗапасыПринятые.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПринятые.Количество
		|		ИНАЧЕ -ЗапасыПринятые.Количество
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ЗапасыПринятые.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПринятые.СуммаРасчетов
		|		ИНАЧЕ -ЗапасыПринятые.СуммаРасчетов
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыПринятые КАК ЗапасыПринятые
		|ГДЕ
		|	ЗапасыПринятые.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыПринятыеИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПринятыеИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПринятыеИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыПринятыеИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗапасыПринятыеИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыПринятыеИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыПринятыеИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыПринятыеИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыПринятыеИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыПринятыеИзменение.Партия КАК Партия,
	|	ДвиженияЗапасыПринятыеИзменение.Контрагент,
	|	ДвиженияЗапасыПринятыеИзменение.Договор,
	|	ДвиженияЗапасыПринятыеИзменение.Заказ,
	|	ДвиженияЗапасыПринятыеИзменение.ТипПриемаПередачи КАК ТипПриемаПередачи,
	|	СУММА(ДвиженияЗапасыПринятыеИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыПринятыеИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыПринятыеИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи,
	|	СУММА(ДвиженияЗапасыПринятыеИзменение.СуммаРасчетовПередЗаписью) КАК СуммаРасчетовПередЗаписью,
	|	СУММА(ДвиженияЗапасыПринятыеИзменение.СуммаРасчетовИзменение) КАК СуммаРасчетовИзменение,
	|	СУММА(ДвиженияЗапасыПринятыеИзменение.СуммаРасчетовПриЗаписи) КАК СуммаРасчетовПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПринятыеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыПринятыеПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Контрагент КАК Контрагент,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Договор КАК Договор,
	|		ДвиженияЗапасыПринятыеПередЗаписью.Заказ КАК Заказ,
	|		ДвиженияЗапасыПринятыеПередЗаписью.ТипПриемаПередачи КАК ТипПриемаПередачи,
	|		ДвиженияЗапасыПринятыеПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыПринятыеПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи,
	|		ДвиженияЗапасыПринятыеПередЗаписью.СуммаРасчетовПередЗаписью КАК СуммаРасчетовПередЗаписью,
	|		ДвиженияЗапасыПринятыеПередЗаписью.СуммаРасчетовПередЗаписью КАК СуммаРасчетовИзменение,
	|		0 КАК СуммаРасчетовПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыПринятыеПередЗаписью КАК ДвиженияЗапасыПринятыеПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыПринятыеПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Организация,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Характеристика,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Партия,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Контрагент,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Договор,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Заказ,
	|		ДвиженияЗапасыПринятыеПриЗаписи.ТипПриемаПередачи,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПринятыеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПринятыеПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыПринятыеПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыПринятыеПриЗаписи.Количество,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПринятыеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПринятыеПриЗаписи.СуммаРасчетов
	|			ИНАЧЕ ДвиженияЗапасыПринятыеПриЗаписи.СуммаРасчетов
	|		КОНЕЦ,
	|		ДвиженияЗапасыПринятыеПриЗаписи.СуммаРасчетов
	|	ИЗ
	|		РегистрНакопления.ЗапасыПринятые КАК ДвиженияЗапасыПринятыеПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыПринятыеПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыПринятыеИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыПринятыеИзменение.Организация,
	|	ДвиженияЗапасыПринятыеИзменение.Номенклатура,
	|	ДвиженияЗапасыПринятыеИзменение.Характеристика,
	|	ДвиженияЗапасыПринятыеИзменение.Партия,
	|	ДвиженияЗапасыПринятыеИзменение.Контрагент,
	|	ДвиженияЗапасыПринятыеИзменение.Договор,
	|	ДвиженияЗапасыПринятыеИзменение.Заказ,
	|	ДвиженияЗапасыПринятыеИзменение.ТипПриемаПередачи
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДвиженияЗапасыПринятыеИзменение.КоличествоИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияЗапасыПринятыеИзменение.СуммаРасчетовИзменение) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	ДвиженияЗапасыПринятыеИзменение.Контрагент,
	|	ДвиженияЗапасыПринятыеИзменение.Договор,
	|	ДвиженияЗапасыПринятыеИзменение.Заказ,
	|	ТипПриемаПередачи");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыПринятыеИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПринятыеИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыПринятыеПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПринятыеПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли